class_name CombatManager
extends Node

signal combat_started
signal combat_ended(victory: bool, rewards: Array)
signal turn_started(entity: CombatEntity)
signal turn_ended(entity: CombatEntity)
signal entity_damaged(entity_id, new_health)
signal entity_name_changed(entity_id, new_name)

@export var player: CombatEntity
@export var enemy: CombatEntity
var player_moves: Array[Move] = []
var enemy_moves: Array[Move] = []

var current_turn: CombatEntity
var turn_order: Array[CombatEntity] = []
var combat_state: String = "idle"  # idle, active, ended
var victory_rewards: Array = []

@onready var combat_ui = get_parent().get_node("CombatUI")


func _ready():
	# Add to combat scene group for easy access
	add_to_group("combat_scene")

	# Connect entity signals
	if player:
		player.entity_died.connect(_on_entity_died)
	if enemy:
		enemy.entity_died.connect(_on_entity_died)

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

	# Handle AI turn
	if current_turn == enemy and enemy.ai_behavior:
		await get_tree().create_timer(1.0).timeout  # Small delay for AI
		execute_ai_turn()


func execute_ai_turn():
	if not enemy or not enemy.ai_behavior:
		end_turn()
		return

	var chosen_move = enemy.ai_behavior.choose_move(enemy, player)
	if chosen_move and chosen_move.can_use(enemy):
		enemy.use_move(chosen_move, player)
		await get_tree().create_timer(0.5).timeout  # Animation delay

	end_turn()


func end_turn():
	if combat_state != "active":
		return

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
		combat_ended.emit(victory, victory_rewards)
		return true

	return false


func _on_entity_died(_entity: CombatEntity):
	# This will be handled by check_combat_end in the next turn
	pass


func set_victory_rewards(rewards: Array):
	victory_rewards = rewards


func get_current_turn() -> CombatEntity:
	return current_turn


func is_player_turn() -> bool:
	return current_turn == player


func force_end_combat(victory: bool = false):
	combat_state = "ended"
	combat_ended.emit(victory, victory_rewards)


func _on_move_selected(move_id):
	# Lógica para manejar la selección de movimiento
	combat_ui.add_log_message("Player selected move: %s" % move_id)


func apply_damage(entity: CombatEntity, damage: int):
	var new_health_value = entity.current_health - damage
	_update_health_billboards(entity, new_health_value)


func _update_health_billboards(entity: CombatEntity, new_value: int):
	emit_signal("entity_damaged", entity, new_value)


func set_entity_name(entity: CombatEntity, new_name: String):
	# Aquí se asignaría el nombre real a la entidad
	emit_signal("entity_name_changed", entity, new_name)
