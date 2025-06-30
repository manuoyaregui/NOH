class_name MoveData
extends Resource

enum MoveType { OFFENSIVE, DEFENSIVE, SPECIAL }

@export var move_name: String
@export var move_type: MoveType
@export var energy_cost: int = 0
@export var damage: int = 0
@export var defense: int = 0
@export var special_effects: Array[String] = []
@export var animation_name: String = ""
@export var cooldown_turns: int = 0
@export var target_type: String = "SINGLE"  # SINGLE, ALL, SELF