class_name EntityData
extends Resource

@export var entity_name: String
@export var sprite_frames: SpriteFrames
@export var color_modulation: Color = Color.WHITE
@export var combat_position: Vector3
@export var flip_horizontal: bool = false
@export var max_health: int = 100
@export var stats: CharacterStats
@export var moves: Array[MoveData] = []
