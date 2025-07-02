class_name EntityFactory
extends RefCounted

static var combat_entity_scene = preload("res://scenes/CombatEntity.tscn")


static func create_player(player_data: Resource) -> Node:
	var entity = combat_entity_scene.instantiate()

	# Configure sprite and animations
	var sprite = entity.get_node("PlayerSprite")
	sprite.sprite_frames = player_data.sprite_frames
	sprite.modulate = player_data.color_modulation
	sprite.flip_h = player_data.flip_horizontal
	sprite.play("idle")  # Ensure animation is playing

	# Configure stats
	entity.stats = player_data.stats.duplicate()
	entity.max_health = player_data.max_health
	entity.current_health = player_data.current_health
	entity.experience_level = player_data.experience_level

	# Configure position and transform
	entity.position = player_data.combat_position

	# Set as player
	entity.is_player = true
	entity.entity_name = player_data.entity_name

	return entity


static func create_enemy(enemy_data: Resource) -> Node:
	var entity = combat_entity_scene.instantiate()

	# Configure sprite and animations
	var sprite = entity.get_node("PlayerSprite")
	sprite.sprite_frames = enemy_data.sprite_frames
	sprite.modulate = enemy_data.color_modulation
	sprite.flip_h = enemy_data.flip_horizontal
	sprite.play("idle")  # Ensure animation is playing

	# Configure stats
	entity.stats = enemy_data.stats.duplicate()
	entity.max_health = enemy_data.max_health
	entity.current_health = enemy_data.max_health  # Enemies start at full health

	# Configure AI
	# TODO: Import and use AIFactory for ai_profile and ai_behavior
	entity.ai_profile = (
		enemy_data.ai_profile if enemy_data.has_method("ai_profile") else null
	)
	entity.ai_behavior = null
	# Replace with AIFactory.create_behavior(enemy_data.ai_type) when available
	entity.difficulty_rating = (
		enemy_data.difficulty_rating
		if enemy_data.has_method("difficulty_rating")
		else 1
	)
	entity.region_affiliation = (
		enemy_data.region_affiliation
		if enemy_data.has_method("region_affiliation")
		else ""
	)

	# Configure position and transform
	entity.position = enemy_data.combat_position

	# Set as enemy
	entity.is_player = false
	entity.entity_name = enemy_data.entity_name

	return entity
