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
	var default_move_ids = ["BASIC_ATTACK", "DEFEND"]
	var moves = create_moves_from_ids(default_move_ids)

	return moves


static func create_move_from_resource(resource_path: String) -> Move:
	var move_data = load(resource_path)
	if move_data is MoveData:
		return _create_move_by_type(move_data)

	push_error("Invalid move resource: " + resource_path)
	return null


static func create_move_by_id(move_id: String) -> Move:
	# Search in move resources by ID
	var resource_path = _find_move_resource_path_by_id(move_id)
	if resource_path != "":
		return create_move_from_resource(resource_path)

	# Fallback to default moves
	push_warning("Move ID not found: " + move_id + ". Using default moves.")
	return create_default_moves()[0]


static func create_move_by_name(move_name: String) -> Move:
	# Search in move resources by name
	var resource_path = _find_move_resource_path_by_name(move_name)
	if resource_path != "":
		return create_move_from_resource(resource_path)

	# Fallback to default moves
	push_warning("Move not found: " + move_name + ". Using default moves.")
	return create_default_moves()[0]


static func _find_move_resource_path_by_id(move_id: String) -> String:
	# Define possible resource directories
	var resource_dirs = [
		"res://scripts/moves/resources/offensive/",
		"res://scripts/moves/resources/defensive/",
		"res://scripts/moves/resources/special/"
	]

	# Search in each directory
	for dir in resource_dirs:
		var dir_access = DirAccess.open(dir)
		if dir_access:
			for file in dir_access.get_files():
				if file.ends_with(".tres"):
					var move_data = load(dir + file) as MoveData
					if move_data and move_data.move_id == move_id:
						return dir + file

	return ""


static func _find_move_resource_path_by_name(move_name: String) -> String:
	# Normalize move name for file search
	var normalized_name = move_name.to_lower().replace(" ", "_")

	# Define possible resource directories
	var resource_dirs = [
		"res://scripts/moves/resources/offensive/",
		"res://scripts/moves/resources/defensive/",
		"res://scripts/moves/resources/special/"
	]

	# Search in each directory
	for dir in resource_dirs:
		var resource_path = dir + normalized_name + ".tres"
		if ResourceLoader.exists(resource_path):
			return resource_path

	return ""


static func create_moves_from_ids(move_ids: Array[String]) -> Array[Move]:
	var moves: Array[Move] = []

	for move_id in move_ids:
		var move = create_move_by_id(move_id)
		if move != null:
			moves.append(move)

	return moves


static func create_moves_from_names(move_names: Array[String]) -> Array[Move]:
	var moves: Array[Move] = []

	for move_name in move_names:
		var move = create_move_by_name(move_name)
		if move != null:
			moves.append(move)

	return moves


static func get_available_moves() -> Array[String]:
	# Returns a list of all available move names from resources
	var available_moves: Array[String] = []

	var dir = DirAccess.open("res://scripts/moves/resources/")
	if dir:
		for subdir in ["offensive", "defensive", "special"]:
			var subdir_path = "res://scripts/moves/resources/" + subdir + "/"
			var subdir_access = DirAccess.open(subdir_path)
			if subdir_access:
				for file in subdir_access.get_files():
					if file.ends_with(".tres"):
						var move_data = load(subdir_path + file) as MoveData
						if move_data:
							available_moves.append(move_data.move_name)

	return available_moves


static func get_available_move_ids() -> Array[String]:
	# Returns a list of all available move IDs from resources
	var available_move_ids: Array[String] = []

	var dir = DirAccess.open("res://scripts/moves/resources/")
	if dir:
		for subdir in ["offensive", "defensive", "special"]:
			var subdir_path = "res://scripts/moves/resources/" + subdir + "/"
			var subdir_access = DirAccess.open(subdir_path)
			if subdir_access:
				for file in subdir_access.get_files():
					if file.ends_with(".tres"):
						var move_data = load(subdir_path + file) as MoveData
						if move_data:
							available_move_ids.append(move_data.move_id)

	return available_move_ids
