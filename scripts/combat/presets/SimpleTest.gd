extends Node


func _ready():
	print("=== Testing Combat Preset System ===")
	test_preset_system()


func test_preset_system():
	# Test 1: Singleton access
	print("Test 1: Singleton access...")
	var manager = CombatPresetManager.instance
	if manager:
		print("✓ CombatPresetManager singleton created successfully")
	else:
		print("✗ Failed to create CombatPresetManager singleton")
		return

	# Test 2: Preset loading
	print("\nTest 2: Preset loading...")
	var preset_names = manager.get_all_preset_names()
	print("Found " + str(preset_names.size()) + " presets: ", preset_names)

	if preset_names.size() > 0:
		print("✓ Presets loaded successfully")
	else:
		print("✗ No presets found")
		return

	# Test 3: Specific preset access
	print("\nTest 3: Specific preset access...")

	# Test basic_combat preset
	if manager.has_preset("basic_combat"):
		var preset = manager.get_preset("basic_combat")
		if preset:
			print("✓ Successfully loaded 'basic_combat' preset")
			print("  Name: " + preset.preset_name)
			print("  Description: " + preset.description)
			print("  Rewards: ", preset.victory_rewards)
			print("  Player position: ", preset.custom_player_position)
			print("  Enemy position: ", preset.custom_enemy_position)
		else:
			print("✗ Failed to get preset object")
	else:
		print("✗ 'basic_combat' preset not found")

	# Test advanced_combat preset
	if manager.has_preset("advanced_combat"):
		var preset = manager.get_preset("advanced_combat")
		if preset:
			print("✓ Successfully loaded 'advanced_combat' preset")
			print("  Name: " + preset.preset_name)
			print("  Description: " + preset.description)
			print("  Rewards: ", preset.victory_rewards)
			print("  Player health: ", preset.custom_player_health)
			print("  Enemy health: ", preset.custom_enemy_health)
		else:
			print("✗ Failed to get advanced_combat preset object")
	else:
		print("✗ 'advanced_combat' preset not found")

	# Test 4: Invalid preset
	print("\nTest 4: Invalid preset test...")
	if not manager.has_preset("invalid_preset"):
		print("✓ Correctly identified invalid preset")
	else:
		print("✗ Incorrectly found invalid preset")

	print("\n=== Test Complete ===")
