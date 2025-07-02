class_name SimpleCombatFactory
extends RefCounted


static func create_combat_scene(config: SimpleCombatConfig = null) -> Node:
	if config == null:
		config = SimpleCombatConfig.new()
	if config.player_config == null:
		config.player_config = SimpleEntityConfig.new()
	if config.enemy_config == null:
		config.enemy_config = SimpleEntityConfig.new()

	var player_data = _convert_to_entity_data(config.player_config, true)
	var enemy_data = _convert_to_entity_data(config.enemy_config, false)

	var full_config = CombatConfig.new()
	full_config.player_data = player_data
	full_config.enemy_data = enemy_data
	full_config.combat_background = config.combat_background
	full_config.music_track = config.music_track
	full_config.lighting_setting = config.lighting_setting

	return CombatFactory.create_combat_scene(full_config)


static func _convert_to_entity_data(
	simple_config: SimpleEntityConfig, is_player: bool
) -> EntityData:
	var entity_data: EntityData
	if is_player:
		entity_data = PlayerData.new()
	else:
		entity_data = EnemyData.new()

	entity_data.entity_name = simple_config.name
	entity_data.max_health = simple_config.max_health
	entity_data.current_health = (
		simple_config.current_health
		if simple_config.current_health > 0
		else simple_config.max_health
	)

	entity_data.experience_level = simple_config.level
	entity_data.combat_position = simple_config.position
	entity_data.flip_horizontal = simple_config.flip_horizontal
	entity_data.color_modulation = simple_config.color_modulation
	entity_data.sprite_frames = SpritePresets.create_sprite_frames(
		simple_config.sprite_preset
	)
	entity_data.stats = DefaultStats.get_default_stats()

	var moves_data = []

	for move_name in simple_config.moves:
		moves_data.append(MovePresets.create_move(move_name))

	entity_data.moves = moves_data

	if not is_player:
		var enemy_data = entity_data as EnemyData
		enemy_data.ai_type = simple_config.ai_type
		enemy_data.difficulty_rating = simple_config.difficulty

	return entity_data
