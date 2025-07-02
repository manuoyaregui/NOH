class_name DefensiveMove
extends Move


func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
	var defense_bonus = move_data.defense + caster.stats.defense_bonus
	caster.add_defense_buff(defense_bonus, 1)  # 1 turno

	# Efectos especiales
	for effect in move_data.special_effects:
		_apply_special_effect(effect, caster, target)


func calculate_defense(caster: CombatEntity) -> int:
	return move_data.defense + caster.stats.defense_bonus


func calculate_heal(caster: CombatEntity) -> int:
	var heal_amount = move_data.defense / 2  # Sanar la mitad de la defensa

	# Buscar efecto HEAL en special_effects
	for effect in move_data.special_effects:
		if effect.to_upper() == "HEAL":
			heal_amount = move_data.defense  # Sanar el valor completo de defensa
			break

	return heal_amount


func _apply_special_effect(
	effect: String, caster: CombatEntity, _target: CombatEntity
) -> void:
	match effect.to_upper():
		"HEAL":
			var heal_amount = move_data.defense / 2  # Sanar la mitad de la defensa
			caster.heal(heal_amount)
		"CLEANSE":
			caster.remove_all_status_effects()
		"SHIELD":
			caster.add_status_effect("shield", 2)  # Escudo por 2 turnos
		"REFLECT":
			caster.add_status_effect("reflect", 1)  # Reflejar daño por 1 turno
		"COUNTER":
			caster.add_status_effect("counter", 1)  # Contraataque por 1 turno
		_:
			push_warning("Unknown special effect: " + effect)


func get_description() -> String:
	var desc = super.get_description()
	if move_data.special_effects.size() > 0:
		desc += " | Effects: " + ", ".join(move_data.special_effects)
	return desc
