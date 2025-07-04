extends Node


func _ready():
	print("=== Testing FASE 3: Presets Simples ===")
	test_simple_preset()


func test_simple_preset():
	# Crear player_data de prueba
	var player_data = PlayerData.new()
	player_data.entity_name = "TestPlayer"
	player_data.max_health = 100
	player_data.current_health = 100
	player_data.combat_position = Vector3(-2, 0, 0)
	player_data.available_moves = ["basic_attack", "defend"]
	player_data.stats = DefaultStats.get_default_stats()

	# Crear combate usando el preset simple
	var combat = CombatPresetFactory.create_specific_combat(
		player_data, "tutorial_combat"
	)
	if combat:
		print("✓ Combat scene created successfully with tutorial_combat preset")
		var cm = combat.get_node_or_null("CombatManager")
		if cm:
			print("  Player: ", cm.player.entity_name)
			print("  Enemy: ", cm.enemy.entity_name)
			print("  Player moves: ", cm.player_moves)
			print("  Enemy moves: ", cm.enemy_moves)
			print("  Rewards: ", cm.victory_rewards)
		else:
			print("✗ CombatManager not found in scene")
	else:
		print("✗ Failed to create combat scene from preset")

	print("=== FASE 3 Test Complete ===")
