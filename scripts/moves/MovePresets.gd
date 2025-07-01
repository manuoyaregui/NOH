class_name MovePresets
extends Resource

static var move_presets = {
	"basic_attack":
	{
		"move_type": MoveData.MoveType.OFFENSIVE,
		"damage": 15,
		"energy_cost": 0,
		"accuracy": 90
	},
	"defend":
	{
		"move_type": MoveData.MoveType.DEFENSIVE,
		"defense": 10,
		"energy_cost": 0,
		"accuracy": 100
	},
	"fire_strike":
	{
		"move_type": MoveData.MoveType.OFFENSIVE,
		"damage": 25,
		"energy_cost": 15,
		"accuracy": 85
	}
}


static func create_move(move_name: String) -> MoveData:
	var preset = move_presets.get(move_name, move_presets["basic_attack"])
	var move = MoveData.new()
	move.move_name = move_name.capitalize().replace("_", " ")
	move.move_type = preset["move_type"]
	if preset.has("damage"):
		move.damage = preset["damage"]
	if preset.has("defense"):
		move.defense = preset["defense"]
	if preset.has("energy_cost"):
		move.energy_cost = preset["energy_cost"]
	if preset.has("accuracy"):
		move.accuracy = preset["accuracy"]
	return move
