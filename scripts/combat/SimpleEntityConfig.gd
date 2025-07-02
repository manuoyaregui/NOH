class_name SimpleEntityConfig
extends Resource

@export var name: String = "Entity"
@export var sprite_preset: String = "samurai_idle"
@export var max_health: int = 100
@export var current_health: int = -1  # Si es -1, usar max_health en la factory
@export var level: int = 1
@export var position: Vector3 = Vector3.ZERO
@export var flip_horizontal: bool = false
@export var color_modulation: Color = Color.WHITE
@export var moves: Array[String] = ["BASIC_ATTACK", "DEFEND"]  # Use move IDs (UPPER_SNAKE_CASE)
@export var ai_type: String = "AGGRESSIVE"
@export var difficulty: int = 1


func _init():
	pass  # No hace falta lógica extra, los defaults ya están
