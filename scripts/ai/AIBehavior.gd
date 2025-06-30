class_name AIBehavior
extends RefCounted

var aggression_level: float = 0.5
var defense_priority: float = 0.3
var special_move_chance: float = 0.2
var retreat_threshold: float = 0.2

func choose_move(enemy: CombatEntity, player: CombatEntity) -> Move:
    # Implementado en subclases
    return null

func should_retreat(enemy: CombatEntity, player: CombatEntity) -> bool:
    var health_ratio = float(enemy.current_health) / float(enemy.max_health)
    return health_ratio <= retreat_threshold 