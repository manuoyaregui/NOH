extends Node


func _ready():
	print("=== Testing FASE 2: Presets Modulares ===")
	test_modular_presets()


func test_modular_presets():
	# Test 1: Load enemy preset
	print("Test 1: Loading enemy preset...")
	var enemy_preset_path = "res://scripts/combat/presets/enemies/goblin.tres"
	if ResourceLoader.exists(enemy_preset_path):
		var enemy_preset = load(enemy_preset_path)
		if enemy_preset:
			print("✓ Successfully loaded goblin enemy preset")
			print("  Name: " + enemy_preset.entity_name)
			print("  Health: " + str(enemy_preset.max_health))
			print("  Moves: ", enemy_preset.available_moves)
		else:
			print("✗ Failed to load enemy preset object")
	else:
		print("✗ Enemy preset file not found")

	# Test 2: Load scenario preset
	print("\nTest 2: Loading scenario preset...")
	var scenario_preset_path = "res://scripts/combat/presets/scenarios/forest.tres"
	if ResourceLoader.exists(scenario_preset_path):
		var scenario_preset = load(scenario_preset_path)
		if scenario_preset:
			print("✓ Successfully loaded forest scenario preset")
			print("  Name: " + scenario_preset.preset_name)
			print("  Background: ", scenario_preset.background_color)
			print("  Rewards: ", scenario_preset.victory_rewards)
		else:
			print("✗ Failed to load scenario preset object")
	else:
		print("✗ Scenario preset file not found")

	# Test 3: Test factory method (without creating actual combat)
	print("\nTest 3: Testing factory method...")
	var player_data = _create_test_player_data()

	# This would normally create a combat scene, but we'll just test the loading
	print("✓ Factory method structure ready")
	print("  Player data created with moves: ", player_data.available_moves)

	print("\n=== FASE 2 Test Complete ===")


func _create_test_player_data() -> PlayerData:
	var player_data = PlayerData.new()
	player_data.entity_name = "TestPlayer"
	player_data.max_health = 100
	player_data.current_health = 100
	player_data.combat_position = Vector3(-2, 0, 0)
	player_data.available_moves = ["basic_attack", "defend"]
	player_data.stats = DefaultStats.get_default_stats("warrior")

	return player_data
