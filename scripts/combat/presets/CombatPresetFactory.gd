class_name CombatPresetFactory
extends RefCounted

# Paths for different preset types
const ENEMY_PRESETS_PATH = "res://scripts/combat/presets/enemies/"
const SCENARIO_PRESETS_PATH = "res://scripts/combat/presets/scenarios/"

# Preload scenes
static var combat_scene_scene = preload("res://scenes/Combat.tscn")


static func create_combat_with(
	player_data: PlayerData,
	enemy_preset_name: String,
	scenario_preset_name: String = "default_scenario"
) -> Node:
	# Load enemy preset
	var enemy_preset = _load_enemy_preset(enemy_preset_name)
	if not enemy_preset:
		push_error("Failed to load enemy preset: " + enemy_preset_name)
		return null

	# Load scenario preset
	var scenario_preset = _load_scenario_preset(scenario_preset_name)
	if not scenario_preset:
		push_error("Failed to load scenario preset: " + scenario_preset_name)
		return null

	# Create combat scene
	var combat_scene = combat_scene_scene.instantiate()
	var combat_manager = combat_scene.get_node("CombatManager")

	# Generate player from player_data
	var player = _generate_player_from_data(player_data, scenario_preset)
	if player:
		combat_manager.player = player
		combat_scene.add_child(player)

	# Generate enemy from enemy preset
	var enemy = _generate_enemy_from_preset(enemy_preset, scenario_preset)
	if enemy:
		combat_manager.enemy = enemy
		combat_scene.add_child(enemy)

	# Set up moves
	combat_manager.player_moves = _load_moves_from_names(
		player_data.available_moves
	)
	combat_manager.enemy_moves = _load_moves_from_names(
		enemy_preset.available_moves
	)

	# Set victory rewards from scenario
	combat_manager.victory_rewards = scenario_preset.victory_rewards

	# Apply scenario effects
	_apply_scenario_effects(combat_scene, scenario_preset)

	return combat_scene


static func _load_enemy_preset(preset_name: String) -> EnemyPreset:
	var preset_path = ENEMY_PRESETS_PATH + preset_name + ".tres"

	if not ResourceLoader.exists(preset_path):
		push_error("Enemy preset not found: " + preset_path)
		return null

	var preset = load(preset_path) as EnemyPreset
	if not preset:
		push_error("Failed to load enemy preset: " + preset_path)
		return null

	return preset


static func _load_scenario_preset(preset_name: String) -> ScenarioPreset:
	var preset_path = SCENARIO_PRESETS_PATH + preset_name + ".tres"

	if not ResourceLoader.exists(preset_path):
		push_error("Scenario preset not found: " + preset_path)
		return null

	var preset = load(preset_path) as ScenarioPreset
	if not preset:
		push_error("Failed to load scenario preset: " + preset_path)
		return null

	return preset


static func _generate_player_from_data(
	player_data: PlayerData, scenario_preset: ScenarioPreset
) -> CombatEntity:
	# Create player entity using existing EntityFactory
	var player = EntityFactory.create_player(player_data)

	# Apply scenario position override
	if scenario_preset.player_position != Vector3.ZERO:
		player.position = scenario_preset.player_position

	return player


static func _generate_enemy_from_preset(
	enemy_preset: EnemyPreset, scenario_preset: ScenarioPreset
) -> CombatEntity:
	# Create enemy data from preset
	var enemy_data = EnemyData.new()
	enemy_data.entity_name = enemy_preset.entity_name
	enemy_data.max_health = enemy_preset.max_health
	enemy_data.combat_position = enemy_preset.combat_position
	enemy_data.stats = enemy_preset.stats
	enemy_data.sprite_frames = enemy_preset.sprite_frames
	enemy_data.color_modulation = enemy_preset.color_modulation
	enemy_data.flip_horizontal = enemy_preset.flip_horizontal
	enemy_data.ai_profile = enemy_preset.ai_profile
	enemy_data.difficulty_rating = enemy_preset.difficulty_rating
	enemy_data.region_affiliation = enemy_preset.region_affiliation
	enemy_data.sprite_frames = enemy_preset.sprite_frames

	# Create enemy entity using existing EntityFactory
	var enemy = EntityFactory.create_enemy(enemy_data)

	# Apply scenario position override
	if scenario_preset.enemy_position != Vector3.ZERO:
		enemy.position = scenario_preset.enemy_position

	return enemy


static func _load_moves_from_names(move_names: Array[String]) -> Array[Move]:
	var moves: Array[Move] = []

	for move_name in move_names:
		var move = MoveFactory.create_move_by_name(move_name)
		if move:
			moves.append(move)
		else:
			push_error("Failed to load move: " + move_name)

	return moves


static func _apply_scenario_effects(
	combat_scene: Node, scenario_preset: ScenarioPreset
):
	# Apply background color
	var world_env = combat_scene.get_node_or_null("WorldEnvironment")
	if world_env and world_env.environment:
		world_env.environment.background_color = (
			scenario_preset.background_color
		)
		world_env.environment.background_mode = Environment.BG_COLOR

	# Apply lighting
	var light = combat_scene.get_node_or_null("DirectionalLight3D")
	if light:
		light.light_energy = scenario_preset.lighting_intensity

	# Apply fog if enabled
	if scenario_preset.fog_enabled:
		var environment = combat_scene.get_node_or_null("WorldEnvironment")
		if environment and environment.environment:
			environment.environment.fog_enabled = true
			environment.environment.fog_light_color = scenario_preset.fog_color
			environment.environment.fog_density = scenario_preset.fog_density


static func create_specific_combat(
	player_data: PlayerData, preset_name: String
) -> Node:
	var preset = CombatPresetManager.instance.get_preset(preset_name)
	if not preset:
		push_error("CombatPreset not found: " + preset_name)
		return null

	var enemy_preset = _load_enemy_preset(preset.enemy_preset.preset_name)
	if not enemy_preset:
		push_error("Enemy preset not found: " + preset.enemy_preset)
		return null

	var scenario_preset = _load_scenario_preset(
		preset.scenario_preset.preset_name
	)
	if not scenario_preset:
		push_error("Scenario preset not found: " + preset.scenario_preset)
		return null

	# Crear escena de combate
	var combat_scene = combat_scene_scene.instantiate()
	var combat_manager = combat_scene.get_node("CombatManager")

	# Player: aplicar overrides si existen
	var player = EntityFactory.create_player(player_data)
	if preset.player_override_moves.size() > 0:
		player.moves = _load_moves_from_names(preset.player_override_moves)
	if preset.player_override_stats:
		player.stats = preset.player_override_stats
	if preset.custom_player_position != Vector3.ZERO:
		player.position = preset.custom_player_position
	if preset.custom_player_health > 0:
		player.current_health = preset.custom_player_health
		player.max_health = preset.custom_player_health
	combat_manager.player = player
	combat_scene.add_child(player)

	# Enemy
	var enemy = _generate_enemy_from_preset(enemy_preset, scenario_preset)
	if preset.custom_enemy_position != Vector3.ZERO:
		enemy.position = preset.custom_enemy_position
	if preset.custom_enemy_health > 0:
		enemy.current_health = preset.custom_enemy_health
		enemy.max_health = preset.custom_enemy_health
	combat_manager.enemy = enemy
	combat_scene.add_child(enemy)

	# Moves
	combat_manager.player_moves = (
		player.moves
		if preset.player_override_moves.size() > 0
		else _load_moves_from_names(player_data.available_moves)
	)
	combat_manager.enemy_moves = _load_moves_from_names(
		enemy_preset.available_moves
	)

	# Rewards
	combat_manager.victory_rewards = (
		preset.victory_rewards
		if preset.victory_rewards.size() > 0
		else scenario_preset.victory_rewards
	)

	# Background color override
	if preset.background_color != Color.BLACK:
		_apply_scenario_effects(combat_scene, scenario_preset)
		var world_env = combat_scene.get_node_or_null("WorldEnvironment")
		if world_env:
			world_env.environment.background_color = preset.background_color
	else:
		_apply_scenario_effects(combat_scene, scenario_preset)

	# Obtener nodos de posición de referencia
	var player_position_node = combat_scene.get_node_or_null("PlayerPosition")
	var enemy_position_node = combat_scene.get_node_or_null("EnemyPosition")

	print("Position player", player_position_node.global_transform.origin)

	# Asignar posiciones si existen los nodos
	if player_position_node:
		player.global_transform.origin = (
			player_position_node.global_transform.origin
		)

	if enemy_position_node:
		enemy.global_transform.origin = (
			enemy_position_node.global_transform.origin
		)

	return combat_scene
