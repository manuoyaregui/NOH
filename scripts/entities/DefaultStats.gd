class_name DefaultStats
extends Resource

static var default_stats = {
	"warrior": {"attack_bonus": 5, "defense_bonus": 3, "speed_bonus": 2},
	"mage": {"attack_bonus": 3, "defense_bonus": 2, "speed_bonus": 1},
	"rogue": {"attack_bonus": 4, "defense_bonus": 1, "speed_bonus": 5}
}


static func get_default_stats(class_type: String = "warrior") -> CharacterStats:
	var stats = CharacterStats.new()
	var defaults = default_stats.get(class_type, default_stats["warrior"])
	stats.attack_bonus = defaults["attack_bonus"]
	stats.defense_bonus = defaults["defense_bonus"]
	stats.speed_bonus = defaults["speed_bonus"]
	return stats
