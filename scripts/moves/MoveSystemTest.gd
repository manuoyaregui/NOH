class_name MoveSystemTest
extends RefCounted


# Test script to demonstrate the move system
static func test_move_system():
	print("=== Testing Move System ===")

	# Test 1: Create moves from resources using IDs
	print("\n1. Testing resource-based move creation:")
	var fire_strike = MoveFactory.create_move_by_id("FIRE_STRIKE")
	var defend = MoveFactory.create_move_by_id("DEFEND")
	var heal = MoveFactory.create_move_by_id("HEAL")
	var void_pull = MoveFactory.create_move_by_id("VOID_PULL")

	print("Fire Strike created: ", fire_strike != null)
	print("Defend created: ", defend != null)
	print("Heal created: ", heal != null)
	print("Void Pull created: ", void_pull != null)

	# Test 2: Create multiple moves from IDs
	print("\n2. Testing multiple move creation:")
	var move_ids = ["BASIC_ATTACK", "DEFEND", "HEAL"]
	var moves = MoveFactory.create_moves_from_ids(move_ids)
	print("Created ", moves.size(), " moves from IDs")

	# Test 3: Test move properties
	print("\n3. Testing move properties:")
	if fire_strike != null:
		print("Fire Strike - ID: ", fire_strike.move_data.move_id)
		print("Fire Strike - Type: ", fire_strike.move_data.move_type)
		print("Fire Strike - Damage: ", fire_strike.move_data.damage)
		print("Fire Strike - Accuracy: ", fire_strike.move_data.accuracy)
		print("Fire Strike - Effects: ", fire_strike.move_data.special_effects)

	# Test 4: Test available moves
	print("\n4. Testing available moves list:")
	var available_moves = MoveFactory.get_available_moves()
	print("Available moves: ", available_moves)

	# Test 5: Test available move IDs
	print("\n5. Testing available move IDs:")
	var available_move_ids = MoveFactory.get_available_move_ids()
	print("Available move IDs: ", available_move_ids)

	# Test 6: Test default moves fallback
	print("\n6. Testing default moves fallback:")
	var invalid_move = MoveFactory.create_move_by_id("NON_EXISTENT_MOVE")
	print("Invalid move fallback: ", invalid_move != null)

	print("\n=== Move System Test Complete ===")


# Example of how to use the move system in combat
static func create_player_moves() -> Array[Move]:
	# Create a basic set of moves for testing using IDs
	var move_ids = ["BASIC_ATTACK", "DEFEND", "HEAL"]
	return MoveFactory.create_moves_from_ids(move_ids)


static func create_enemy_moves() -> Array[Move]:
	# Create moves for enemy testing using IDs
	var move_ids = ["BASIC_ATTACK", "FIRE_STRIKE"]
	return MoveFactory.create_moves_from_ids(move_ids)


static func test_move_execution():
	print("=== Testing Move Execution ===")

	# Create test entities (simplified)
	var player_moves = create_player_moves()
	var enemy_moves = create_enemy_moves()

	print("Player moves created: ", player_moves.size())
	print("Enemy moves created: ", enemy_moves.size())

	# Test move validation
	if player_moves.size() > 0:
		var first_move = player_moves[0]
		print("First move ID: ", first_move.move_data.move_id)
		print("First move name: ", first_move.move_data.move_name)
		print("First move type: ", first_move.move_data.move_type)

	print("=== Move Execution Test Complete ===")
