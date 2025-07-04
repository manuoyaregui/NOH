class_name CombatPreset
extends Resource

@export var preset_name: String = ""
@export var description: String = ""

# Basic combat configuration
@export var background_color: Color = Color.BLACK
@export var victory_rewards: Array[String] = []

# Optional custom positions
@export var custom_player_position: Vector3 = Vector3.ZERO
@export var custom_enemy_position: Vector3 = Vector3.ZERO

# Optional custom health overrides
@export var custom_player_health: int = -1
@export var custom_enemy_health: int = -1

@export var enemy_preset: String = ""
@export var scenario_preset: String = ""
@export var player_override_moves: Array[String] = []
@export var player_override_stats: Resource = null
