class_name MoveEffectProcessor
extends RefCounted

signal effect_processed(effect_data: Dictionary)

# Strategy pattern for different move types
var effect_strategies: Dictionary = {}


func _init():
	_setup_strategies()


func _setup_strategies():
	effect_strategies["offensive"] = _handle_offensive_move
	effect_strategies["defensive"] = _handle_defensive_move
	effect_strategies["special"] = _handle_special_move


func process_move_effect(
	move: Move, caster: CombatEntity, target: CombatEntity
) -> Dictionary:
	var move_type = _get_move_type(move)
	var strategy = effect_strategies.get(move_type, _handle_unknown_move)

	var effect_data = strategy.call(move, caster, target)
	effect_processed.emit(effect_data)

	return effect_data


func _get_move_type(move: Move) -> String:
	if move is OffensiveMove:
		return "offensive"

	if move is DefensiveMove:
		return "defensive"

	if move is SpecialMove:
		return "special"

	return "unknown"


func _handle_offensive_move(
	move: Move, caster: CombatEntity, target: CombatEntity
) -> Dictionary:
	var raw_damage = move.calculate_damage(caster, target)
	var real_damage = target._calculate_final_damage(raw_damage)

	return {
		"type": "damage",
		"caster": caster,
		"target": target,
		"damage": real_damage,
		"move_name": move.get_display_name(),
		"message":
		(
			"%s deals %d damage to %s!"
			% [caster.entity_name, real_damage, target.entity_name]
		)
	}


func _handle_defensive_move(
	move: Move, caster: CombatEntity, target: CombatEntity
) -> Dictionary:
	var move_id = move.move_data.move_id.to_upper()
	var effect_data = {
		"type": "defensive",
		"caster": caster,
		"target": target,
		"move_name": move.get_display_name()
	}

	match move_id:
		"HEAL":
			var heal_amount = move.calculate_heal(caster)
			caster.heal(heal_amount)
			effect_data["heal_amount"] = heal_amount
			effect_data["message"] = (
				"%s heals for %d HP!" % [caster.entity_name, heal_amount]
			)

		"DEFEND":
			var defense_amount = move.calculate_defense(caster)
			caster.add_defense_buff(defense_amount, 1)
			effect_data["defense_amount"] = defense_amount
			effect_data["message"] = "%s raises defense!" % [caster.entity_name]

		_:
			effect_data["message"] = (
				"%s uses defensive move: %s!"
				% [caster.entity_name, move.get_display_name()]
			)

	return effect_data


func _handle_special_move(
	move: Move, caster: CombatEntity, target: CombatEntity
) -> Dictionary:
	# Special moves can have custom logic here
	return {
		"type": "special",
		"caster": caster,
		"target": target,
		"move_name": move.get_display_name(),
		"message":
		(
			"%s uses special move: %s!"
			% [caster.entity_name, move.get_display_name()]
		)
	}


func _handle_unknown_move(
	move: Move, caster: CombatEntity, target: CombatEntity
) -> Dictionary:
	return {
		"type": "unknown",
		"caster": caster,
		"target": target,
		"move_name": move.get_display_name(),
		"message":
		"%s uses: %s!" % [caster.entity_name, move.get_display_name()]
	}
