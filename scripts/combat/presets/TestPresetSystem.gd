class_name TestPresetSystem
extends RefCounted


static func test_preset_loading():
	print("=== Testing Combat Preset System ===")

	# Test singleton access
	var manager = CombatPresetManager.instance
	print("✓ CombatPresetManager singleton created")

	# Test preset loading
	var preset_names = manager.get_all_preset_names()
	print("✓ Loaded " + str(preset_names.size()) + " presets: ", preset_names)

	# Test specific preset access
	if manager.has_preset("basic_combat"):
		var preset = manager.get_preset("basic_combat")
		print("✓ Successfully loaded preset: " + preset.preset_name)
		print("  Description: " + preset.description)
		print("  Rewards: ", preset.victory_rewards)
	else:
		print("✗ Failed to find basic_combat preset")

	print("=== Test Complete ===")
