class_name ScenarioPreset
extends Resource

@export var preset_name: String = ""
@export var description: String = ""

@export var name: String = ""
@export var player_position: Vector3 = Vector3.ZERO
@export var enemy_position: Vector3 = Vector3.ZERO
@export var background_color: Color = Color.BLACK
@export var lighting_intensity: float = 1.0
@export var fog_enabled: bool = false
@export var fog_color: Color = Color(0.5, 0.5, 0.5)
@export var fog_density: float = 0.1
@export var victory_rewards: Array = []

# Environmental effects
@export var weather_effect: String = ""  # "rain", "snow", "wind", etc.
@export var time_of_day: String = "day"  # "day", "night", "dawn", "dusk"

# Special conditions
@export var special_conditions: Array[String] = []  # ["poison", "darkness", "confusion"]
