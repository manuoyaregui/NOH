class_name AIBehavior
extends RefCounted

var aggression_level: float = 0.5
var defense_priority: float = 0.3
var special_move_chance: float = 0.2
var retreat_threshold: float = 0.2


func choose_move(enemy: CombatEntity, player: CombatEntity) -> Move:
	var available_moves = enemy.get_available_moves()

	if available_moves.size() == 0:
		return null

	# Si la salud está baja, priorizar movimientos defensivos
	var health_ratio = float(enemy.current_health) / float(enemy.max_health)

	if health_ratio <= retreat_threshold:
		return _choose_defensive_move(available_moves)

	# Si el jugador tiene mucha salud, usar movimientos especiales
	var player_health_ratio = (
		float(player.current_health) / float(player.max_health)
	)
	if player_health_ratio > 0.7 and randf() < special_move_chance:
		return _choose_special_move(available_moves)

	# En general, usar movimientos ofensivos
	return _choose_offensive_move(available_moves)


func _choose_offensive_move(available_moves: Array[Move]) -> Move:
	for move in available_moves:
		if move is OffensiveMove:
			return move

	# Si no hay movimientos ofensivos, elegir el primero disponible
	if available_moves.size() > 0:
		return available_moves[0]

	return null


func _choose_defensive_move(available_moves: Array[Move]) -> Move:
	for move in available_moves:
		if move is DefensiveMove:
			return move

	# Si no hay movimientos defensivos, elegir el primero disponible
	if available_moves.size() > 0:
		return available_moves[0]

	return null


func _choose_special_move(available_moves: Array[Move]) -> Move:
	for move in available_moves:
		if move is SpecialMove:
			return move

	# Si no hay movimientos especiales, elegir el primero disponible
	if available_moves.size() > 0:
		return available_moves[0]

	return null


func should_retreat(enemy: CombatEntity, _player: CombatEntity) -> bool:
	var health_ratio = float(enemy.current_health) / float(enemy.max_health)
	return health_ratio <= retreat_threshold
