class_name CombatEntity
extends Node3D

signal move_executed(move: Move, caster: CombatEntity, target: CombatEntity)
signal health_changed(current_health: int, max_health: int)
signal entity_died(entity: CombatEntity)

@export var entity_name: String = "Entity"
@export var is_player: bool = false
@export var max_health: int = 100

var current_health: int

var experience_level: int = 1
var stats: CharacterStats
var moves: Array[Move] = []
var last_used_move: Move = null
var status_effects: Dictionary = {}
var defense_buffs: Array[Dictionary] = []

# AI properties
var ai_profile: AIProfile
var ai_behavior: AIBehavior
var difficulty_rating: int = 1
var region_affiliation: String = ""


func _ready():
	current_health = max_health

	if stats == null:
		stats = CharacterStats.new()

	var name_label = get_node_or_null("PlayerSprite/EntityName")
	if name_label:
		name_label.text = entity_name
		name_label.visible = not is_player


func take_damage(amount: int) -> void:
	var final_damage = _calculate_final_damage(amount)
	current_health = max(0, current_health - final_damage)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		entity_died.emit(self)


func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)


func _calculate_final_damage(base_damage: int) -> int:
	var final_damage = base_damage

	# Aplicar defensa
	var total_defense = stats.defense_bonus
	for buff in defense_buffs:
		total_defense += buff.defense

	final_damage = max(1, final_damage - total_defense)

	# Aplicar efectos de estado
	if status_effects.has("shield"):
		final_damage = max(1, final_damage / 2)

	return final_damage


func add_defense_buff(defense_amount: int, duration: int) -> void:
	defense_buffs.append({"defense": defense_amount, "duration": duration})


func add_status_effect(effect_name: String, duration: int) -> void:
	status_effects[effect_name] = duration


func remove_status_effect(effect_name: String) -> void:
	status_effects.erase(effect_name)


func remove_all_status_effects() -> void:
	status_effects.clear()


func get_available_moves() -> Array[Move]:
	var available_moves: Array[Move] = []
	for move in moves:
		if move.can_use(self):
			available_moves.append(move)
	return available_moves


func use_move(move: Move, target: CombatEntity) -> void:
	if move.can_use(self):
		last_used_move = move
		move.execute(self, target)


func update_turn() -> void:
	# Actualizar cooldowns
	for move in moves:
		move.update_cooldown()

	# Actualizar buffs de defensa
	for i in range(defense_buffs.size() - 1, -1, -1):
		defense_buffs[i].duration -= 1
		if defense_buffs[i].duration <= 0:
			defense_buffs.remove_at(i)

	# Actualizar efectos de estado
	var effects_to_remove: Array[String] = []
	for effect in status_effects:
		status_effects[effect] -= 1
		if status_effects[effect] <= 0:
			effects_to_remove.append(effect)

	for effect in effects_to_remove:
		status_effects.erase(effect)


func reset_all_cooldowns() -> void:
	for move in moves:
		move.current_cooldown = 0


func add_temporary_move(move: Move, _duration: int) -> void:
	moves.append(move)
	# El movimiento se removerá después de la duración especificada


func get_health_percentage() -> float:
	return float(current_health) / float(max_health)


func is_alive() -> bool:
	return current_health > 0


func can_act() -> bool:
	return is_alive() and not status_effects.has("stun")
