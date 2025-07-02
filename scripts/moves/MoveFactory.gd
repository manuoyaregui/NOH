class_name MoveFactory
extends RefCounted


static func create_moves(move_data_list: Array[MoveData]) -> Array[Move]:
	var moves: Array[Move] = []

	for move_data in move_data_list:
		var move = _create_move_by_type(move_data)
		if move != null:
			moves.append(move)

	return moves


static func _create_move_by_type(move_data: MoveData) -> Move:
	match move_data.move_type:
		MoveData.MoveType.OFFENSIVE:
			return OffensiveMove.new(move_data)
		MoveData.MoveType.DEFENSIVE:
			return DefensiveMove.new(move_data)
		MoveData.MoveType.SPECIAL:
			return SpecialMove.new(move_data)
		_:
			push_error("Unknown move type: " + str(move_data.move_type))
			return null


static func create_default_moves() -> Array[Move]:
	# Movimientos básicos para casos de emergencia
	var basic_attack = MoveData.new()
	basic_attack.move_name = "Basic Attack"
	basic_attack.move_type = MoveData.MoveType.OFFENSIVE
	basic_attack.damage = 10

	var basic_defend = MoveData.new()
	basic_defend.move_name = "Defend"
	basic_defend.move_type = MoveData.MoveType.DEFENSIVE
	basic_defend.defense = 5

	return create_moves([basic_attack, basic_defend])


static func create_move_from_resource(resource_path: String) -> Move:
	var move_data = load(resource_path)
	if move_data is MoveData:
		return _create_move_by_type(move_data)

	push_error("Invalid move resource: " + resource_path)
	return null


static func create_move_by_name(move_name: String) -> Move:
	# Search in move resources
	var resource_path = (
		"res://scripts/moves/resources/"
		+ move_name.to_lower().replace(" ", "_")
		+ ".tres"
	)
	return create_move_from_resource(resource_path)
