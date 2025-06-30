class_name CombatConfig
extends Resource

@export var player_data: Resource
@export var enemy_data: Resource
@export var combat_background: String = "default"
@export var music_track: String = "combat_default"
@export var lighting_setting: String = "default"
@export var victory_rewards: Array[Resource] = []
@export var defeat_consequences: Array[Resource] = []
@export var combat_duration_limit: float = 300.0  # 5 minutes
