extends Node3D

@onready var combat_manager = $CombatManager


func _ready():
	# Conectar señales del combate
	combat_manager.combat_started.connect(_on_combat_started)
	combat_manager.combat_ended.connect(_on_combat_ended)
	combat_manager.player_turn_started.connect(_on_player_turn_started)
	combat_manager.ai_turn_started.connect(_on_ai_turn_started)

	_set_entities_positions()

	# Iniciar el combate después de un pequeño delay
	await get_tree().create_timer(1.0).timeout
	combat_manager.start_combat()


func _on_combat_started():
	print("Combat started!")


func _on_combat_ended(victory: bool, rewards: Array):
	if victory:
		print("Victory! Rewards: ", rewards)
	else:
		print("Defeat!")


func _on_player_turn_started():
	print("Player's turn started")


func _on_ai_turn_started():
	print("AI's turn started")


func _set_entities_positions():
	var player_position_node = $PlayerPosition
	var enemy_position_node = $EnemyPosition
	var player = get_node("Player")
	var enemy = get_node("Enemy")

	if player_position_node and player:
		player.global_position = player_position_node.global_position
		player_position_node.queue_free()

	if enemy_position_node and enemy:
		enemy.global_position = enemy_position_node.global_position
		enemy_position_node.queue_free()
