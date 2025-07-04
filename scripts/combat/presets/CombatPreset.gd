class_name CombatPreset
extends Resource

@export var preset_name: String = ""
@export var description: String = ""

@export var name: String = ""
@export var enemy_preset: EnemyPreset  # EnemyPreset
@export var scenario_preset: ScenarioPreset  # ScenarioPreset
@export var player_override_moves: Array[String] = []
@export var player_override_stats: CharacterStats  # CharacterStats
@export var custom_player_position: Vector3 = Vector3.ZERO
@export var custom_player_health: int = 0
@export var custom_enemy_position: Vector3 = Vector3.ZERO
@export var custom_enemy_health: int = 0
@export var victory_rewards: Array = []
@export var background_color: Color = Color.BLACK
