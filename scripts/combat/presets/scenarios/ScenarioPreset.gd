class_name ScenarioPreset
extends Resource

@export var preset_name: String = ""
@export var description: String = ""

# Visual environment
@export var background_color: Color = Color.BLACK
@export var lighting_intensity: float = 1.0
@export var fog_enabled: bool = false
@export var fog_color: Color = Color.WHITE
@export var fog_density: float = 0.1

# Combat positions
@export var player_position: Vector3 = Vector3(-2, 0, 0)
@export var enemy_position: Vector3 = Vector3(2, 0, 0)

# Environmental effects
@export var weather_effect: String = ""  # "rain", "snow", "wind", etc.
@export var time_of_day: String = "day"  # "day", "night", "dawn", "dusk"

# Special conditions
@export var special_conditions: Array[String] = []  # ["poison", "darkness", "confusion"]
@export var victory_rewards: Array[String] = ["experience", "gold"]
