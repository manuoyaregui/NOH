class_name CombatFactory
extends RefCounted

# TODO: Implement this file
# TODO: Add UIFactory, EffectFactory, AudioFactory imports when available


static func create_combat_scene(config: CombatConfig) -> Node:
	# Create the base scene
	var combat_scene = preload("res://scenes/Combat.tscn").instantiate()
	var combat_manager = combat_scene.get_node("CombatManager")

	# Configure entities using specific factories
	var player_entity = EntityFactory.create_player(config.player_data)
	var enemy_entity = EntityFactory.create_enemy(config.enemy_data)

	# Add entities to the scene
	combat_scene.add_child(player_entity)
	combat_scene.add_child(enemy_entity)

	# Configure combat manager
	combat_manager.player = player_entity
	combat_manager.enemy = enemy_entity

	# Configure moves
	combat_manager.player_moves = MoveFactory.create_moves(
		config.player_data.moves
	)
	combat_manager.enemy_moves = MoveFactory.create_moves(
		config.enemy_data.moves
	)

	# Configure UI and effects
	# UIFactory.setup_combat_ui(combat_scene, config)
	# EffectFactory.setup_combat_effects(combat_scene, config)

	# Configure music and ambiance
	# AudioFactory.setup_combat_audio(combat_scene, config)

	# Start the combat
	combat_manager.start_combat()

	return combat_scene


static func create_region_combat(region: String, enemy_id: String) -> Node:
	var config = CombatConfig.new()

	# Region-specific configuration
	match region:
		"crown_silent":
			config.combat_background = "crown_room"
			config.music_track = "crown_combat"
			config.lighting_setting = "authority_lighting"
		"sunken_fields":
			config.combat_background = "toy_graveyard"
			config.music_track = "nostalgia_combat"
			config.lighting_setting = "melancholic_lighting"
		"marble_throne":
			config.combat_background = "throne_room"
			config.music_track = "final_boss"
			config.lighting_setting = "dramatic_lighting"
		_:
			config.combat_background = "default"
			config.music_track = "combat_default"
			config.lighting_setting = "default"

	config.enemy_data = ResourceLoader.load(
		"res://scripts/entities/resources/enemy_data/" + enemy_id + ".tres"
	)
	# TODO: Implement get_current_player_data() or import from the appropriate module
	config.player_data = null  # Replace with actual player data retrieval

	return create_combat_scene(config)
