class_name OffensiveMove
extends Move


func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
	var final_damage = calculate_final_damage(caster, target)
	target.take_damage(final_damage)

	# Efectos especiales
	for effect in move_data.special_effects:
		_apply_special_effect(effect, caster, target)


func calculate_final_damage(caster: CombatEntity, target: CombatEntity) -> int:
	var base_damage = move_data.damage + caster.stats.attack_bonus

	# Aplicar modificadores especiales
	for effect in move_data.special_effects:
		match effect.to_upper():
			"CRITICAL":
				base_damage = int(base_damage * 1.5)
			"PIERCE":
				pass

	# Aplicar defensa
	var total_defense = target.stats.defense_bonus
	for buff in target.defense_buffs:
		total_defense += buff.defense

	var final_damage = max(1, base_damage - total_defense)

	# Aplicar efectos de estado
	if target.status_effects.has("shield"):
		final_damage = max(1, final_damage / 2)

	return final_damage


func calculate_damage(caster: CombatEntity, target: CombatEntity) -> int:
	return calculate_final_damage(caster, target)


func _apply_special_effect(
	effect: String, _caster: CombatEntity, target: CombatEntity
) -> void:
	match effect.to_upper():
		"BURN":
			target.add_status_effect("burn", 3)  # 3 turnos
		"STUN":
			target.add_status_effect("stun", 1)  # 1 turno
		"BLEED":
			target.add_status_effect("bleed", 2)  # 2 turnos
		"CRITICAL":
			# Daño crítico (ya aplicado en el daño base)
			pass
		"PIERCE":
			# Ignora defensa (ya aplicado en el daño base)
			pass
		_:
			push_warning("Unknown special effect: " + effect)


func get_description() -> String:
	var desc = super.get_description()
	if move_data.special_effects.size() > 0:
		desc += " | Effects: " + ", ".join(move_data.special_effects)
	return desc
