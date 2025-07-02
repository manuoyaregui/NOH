class_name OffensiveMove
extends Move


func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
	var final_damage = move_data.damage + caster.stats.attack_bonus
	target.take_damage(final_damage)

	# Efectos especiales
	for effect in move_data.special_effects:
		_apply_special_effect(effect, caster, target)


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
