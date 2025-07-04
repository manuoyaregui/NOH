class_name EnemyPreset
extends Resource

@export var preset_name: String = ""
@export var description: String = ""

# Enemy basic properties
@export var entity_name: String = "Enemy"
@export var max_health: int = 100
@export var combat_position: Vector3 = Vector3.ZERO

# Enemy stats
@export var stats: CharacterStats

# Enemy appearance
@export var sprite_frames: SpriteFrames
@export var color_modulation: Color = Color.WHITE
@export var flip_horizontal: bool = false

# AI configuration
@export var ai_profile: AIProfile
@export var difficulty_rating: int = 1
@export var region_affiliation: String = ""

# Enemy moves
@export var available_moves: Array[String] = ["basic_attack"]
