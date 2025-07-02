class_name SpecialMove
extends Move


func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
	# Efectos especiales únicos
	for effect in move_data.special_effects:
		_apply_special_effect(effect, caster, target)


func _apply_special_effect(
	effect: String, caster: CombatEntity, target: CombatEntity
) -> void:
	match effect.to_upper():
		"LIFESTEAL":
			var damage = move_data.damage + caster.stats.attack_bonus
			target.take_damage(damage)
			caster.heal(damage / 2)  # Sanar la mitad del daño

		"SWAP_STATS":
			_swap_entity_stats(caster, target)
		"MIRROR":
			# Copiar el último movimiento usado por el objetivo
			if target.last_used_move != null:
				var copied_move = target.last_used_move.duplicate()
				caster.add_temporary_move(copied_move, 1)
		"TIME_WARP":
			# Resetear cooldowns del lanzador
			caster.reset_all_cooldowns()
		"REALITY_SHIFT":
			# Cambiar el tipo de movimiento del objetivo temporalmente
			target.add_status_effect("reality_shift", 2)
		"VOID_PULL":
			# Forzar al objetivo a usar un movimiento específico
			target.add_status_effect("void_pull", 1)
		"MEMORY_ERASE":
			# Olvidar el último movimiento usado
			target.last_used_move = null
		"PSYCHIC_LINK":
			# Compartir daño entre ambos
			var shared_damage: int = move_data.damage / 2
			caster.take_damage(shared_damage)
			target.take_damage(shared_damage)
		_:
			push_warning("Unknown special effect: " + effect)


func _swap_entity_stats(caster: CombatEntity, target: CombatEntity) -> void:
	# Intercambiar estadísticas temporales
	var temp_attack = caster.stats.attack_bonus
	var temp_defense = caster.stats.defense_bonus

	caster.stats.attack_bonus = target.stats.attack_bonus
	caster.stats.defense_bonus = target.stats.defense_bonus

	target.stats.attack_bonus = temp_attack
	target.stats.defense_bonus = temp_defense

	# Aplicar efecto temporal
	caster.add_status_effect("stat_swap", 2)
	target.add_status_effect("stat_swap", 2)


func get_description() -> String:
	var desc = super.get_description()
	if move_data.special_effects.size() > 0:
		desc += " | Special: " + ", ".join(move_data.special_effects)
	return desc
