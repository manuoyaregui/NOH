class_name CombatManager
extends Node

signal combat_started
signal combat_ended(victory: bool, rewards: Array)
signal turn_started(entity: CombatEntity)
signal turn_ended(entity: CombatEntity)
signal entity_damaged(entity_id, new_health)
signal entity_name_changed(entity_id, new_name)
signal player_turn_started
signal ai_turn_started

@export var player: CombatEntity
@export var enemy: CombatEntity
var player_moves: Array[Move] = []
var enemy_moves: Array[Move] = []

var current_turn: CombatEntity
var turn_order: Array[CombatEntity] = []
var combat_state: String = "idle"  # idle, active, ended
var victory_rewards: Array = []
var waiting_for_player_input: bool = false

@onready var combat_ui = get_parent().get_node("CombatUI")


func _ready():
	# Add to combat scene group for easy access
	add_to_group("combat_scene")

	# Connect entity signals
	if player:
		player.entity_died.connect(_on_entity_died)
		player.move_executed.connect(_on_move_executed)
	if enemy:
		enemy.entity_died.connect(_on_entity_died)
		enemy.move_executed.connect(_on_move_executed)

	set_entity_name(player, player.entity_name)
	set_entity_name(enemy, enemy.entity_name)

	combat_ui.set_moves(player.get_available_moves())
	combat_ui.move_selected.connect(_on_move_selected)

	_update_health_billboards(player, player.current_health)
	_update_health_billboards(enemy, enemy.current_health)

	combat_ui.add_log_message("Combat started!")


func start_combat():
	if combat_state != "idle":
		return

	combat_state = "active"

	# Set up turn order (player goes first)
	turn_order = [player, enemy]
	current_turn = player

	# Assign moves to entities
	if player and player_moves.size() > 0:
		player.moves = player_moves
	if enemy and enemy_moves.size() > 0:
		enemy.moves = enemy_moves

	# Start first turn
	combat_started.emit()
	start_turn()


func start_turn():
	if combat_state != "active":
		return

	turn_started.emit(current_turn)

	# Handle different turn types
	if current_turn == player:
		start_player_turn()
	elif current_turn == enemy:
		start_ai_turn()


func start_player_turn():
	player_turn_started.emit()
	waiting_for_player_input = true

	# Update available moves in UI
	var available_moves = player.get_available_moves()
	combat_ui.set_moves(available_moves)
	combat_ui.add_log_message("Your turn! Choose a move.")


func start_ai_turn():
	ai_turn_started.emit()
	combat_ui.add_log_message("Enemy's turn...")

	# Disable player moves during AI turn
	# TODO hide ui move buttons

	await get_tree().create_timer(1.0).timeout  # Small delay for AI
	execute_ai_turn()


func execute_ai_turn():
	if not enemy or not enemy.ai_behavior:
		end_turn()
		return

	var chosen_move = enemy.ai_behavior.choose_move(enemy, player)
	if chosen_move and chosen_move.can_use(enemy):
		combat_ui.add_log_message(
			"Enemy uses: %s" % chosen_move.get_display_name()
		)
		enemy.use_move(chosen_move, player)
		await get_tree().create_timer(0.5).timeout  # Animation delay
	else:
		combat_ui.add_log_message("Enemy couldn't use any move!")

	end_turn()


func end_turn():
	if combat_state != "active":
		return

	waiting_for_player_input = false
	turn_ended.emit(current_turn)

	# Update entity states
	if current_turn:
		current_turn.update_turn()

	# Check for combat end
	if check_combat_end():
		return

	# Switch to next turn
	var current_index = turn_order.find(current_turn)
	var next_index = (current_index + 1) % turn_order.size()
	current_turn = turn_order[next_index]

	# Start next turn
	start_turn()


func check_combat_end() -> bool:
	var player_alive = player and player.is_alive()
	var enemy_alive = enemy and enemy.is_alive()

	if not player_alive or not enemy_alive:
		combat_state = "ended"
		var victory = player_alive and not enemy_alive

		if victory:
			combat_ui.add_log_message("Victory! You defeated the enemy!")
		else:
			combat_ui.add_log_message("Defeat! You were defeated!")

		combat_ended.emit(victory, victory_rewards)
		return true

	return false


func _on_entity_died(_entity: CombatEntity):
	# This will be handled by check_combat_end in the next turn
	pass


func _on_move_executed(move: Move, caster: CombatEntity, target: CombatEntity):
	# Handle move execution effects
	var move_name = move.get_display_name()

	if move is OffensiveMove:
		# Calcular el daño real que se infligió, considerando defensa y efectos
		var raw_damage = move.calculate_damage(caster, target)
		var real_damage = target._calculate_final_damage(raw_damage)
		combat_ui.add_log_message(
			(
				"%s deals %d damage to %s!"
				% [caster.entity_name, real_damage, target.entity_name]
			)
		)

	elif move is DefensiveMove:
		if move.move_type == "heal":
			var heal_amount = move.calculate_heal(caster)
			caster.heal(heal_amount)
			combat_ui.add_log_message(
				"%s heals for %d HP!" % [caster.entity_name, heal_amount]
			)
		elif move.move_type == "defend":
			var defense_amount = move.calculate_defense(caster)
			caster.add_defense_buff(defense_amount, 1)
			combat_ui.add_log_message(
				"%s raises defense!" % [caster.entity_name]
			)

	elif move is SpecialMove:
		combat_ui.add_log_message(
			"%s uses special move: %s!" % [caster.entity_name, move_name]
		)

	# Update health displays
	_update_health_billboards(player, player.current_health)
	_update_health_billboards(enemy, enemy.current_health)


func set_victory_rewards(rewards: Array):
	victory_rewards = rewards


func get_current_turn() -> CombatEntity:
	return current_turn


func is_player_turn() -> bool:
	return current_turn == player


func force_end_combat(victory: bool = false):
	combat_state = "ended"
	combat_ended.emit(victory, victory_rewards)


func _on_move_selected(move: Move):
	if not waiting_for_player_input or current_turn != player:
		return

	# Execute player move
	combat_ui.add_log_message("You use: %s" % move.get_display_name())
	player.use_move(move, enemy)

	# Small delay for animation
	await get_tree().create_timer(0.5).timeout

	# End turn
	end_turn()


func apply_damage(entity: CombatEntity, damage: int):
	var new_health_value = entity.current_health - damage
	_update_health_billboards(entity, new_health_value)


func _update_health_billboards(entity: CombatEntity, new_value: int):
	emit_signal("entity_damaged", entity, new_value)


func set_entity_name(entity: CombatEntity, new_name: String):
	# Aquí se asignaría el nombre real a la entidad
	emit_signal("entity_name_changed", entity, new_name)
