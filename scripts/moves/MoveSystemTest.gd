class_name MoveSystemTest
extends RefCounted

# Test script to demonstrate the move system
static func test_move_system():
    print("=== Testing Move System ===")
    
    # Test 1: Create moves from resources
    print("\n1. Creating moves from resources:")
    var basic_attack = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/basic_attack.tres")
    var fire_strike = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/fire_strike.tres")
    var defend = MoveFactory.create_move_from_resource("res://scripts/moves/resources/defensive/defend.tres")
    var heal = MoveFactory.create_move_from_resource("res://scripts/moves/resources/defensive/heal.tres")
    var void_pull = MoveFactory.create_move_from_resource("res://scripts/moves/resources/special/void_pull.tres")
    
    if basic_attack:
        print("✓ Basic Attack created: " + basic_attack.get_display_name())
    if fire_strike:
        print("✓ Fire Strike created: " + fire_strike.get_display_name())
    if defend:
        print("✓ Defend created: " + defend.get_display_name())
    if heal:
        print("✓ Heal created: " + heal.get_display_name())
    if void_pull:
        print("✓ Void Pull created: " + void_pull.get_display_name())
    
    # Test 2: Create default moves
    print("\n2. Creating default moves:")
    var default_moves = MoveFactory.create_default_moves()
    for move in default_moves:
        print("✓ Default move: " + move.get_display_name() + " - " + move.get_description())
    
    # Test 3: Test move properties
    print("\n3. Testing move properties:")
    if fire_strike:
        print("Fire Strike - Type: " + str(fire_strike.move_data.move_type))
        print("Fire Strike - Damage: " + str(fire_strike.move_data.damage))
        print("Fire Strike - Energy Cost: " + str(fire_strike.move_data.energy_cost))
        print("Fire Strike - Special Effects: " + str(fire_strike.move_data.special_effects))
        print("Fire Strike - Cooldown: " + str(fire_strike.move_data.cooldown_turns))
    
    # Test 4: Test cooldown system
    print("\n4. Testing cooldown system:")
    if fire_strike:
        print("Fire Strike initial cooldown: " + str(fire_strike.get_cooldown_remaining()))
        fire_strike.current_cooldown = 2
        print("Fire Strike set cooldown to 2: " + str(fire_strike.get_cooldown_remaining()))
        fire_strike.update_cooldown()
        print("Fire Strike after update: " + str(fire_strike.get_cooldown_remaining()))
        fire_strike.update_cooldown()
        print("Fire Strike after second update: " + str(fire_strike.get_cooldown_remaining()))
    
    print("\n=== Move System Test Complete ===")

# Example of how to use the move system in combat
static func create_player_moves() -> Array[Move]:
    var player_moves: Array[Move] = []
    
    # Add basic attack
    var basic_attack = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/basic_attack.tres")
    if basic_attack:
        player_moves.append(basic_attack)
    
    # Add fire strike
    var fire_strike = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/fire_strike.tres")
    if fire_strike:
        player_moves.append(fire_strike)
    
    # Add defend
    var defend = MoveFactory.create_move_from_resource("res://scripts/moves/resources/defensive/defend.tres")
    if defend:
        player_moves.append(defend)
    
    # Add heal
    var heal = MoveFactory.create_move_from_resource("res://scripts/moves/resources/defensive/heal.tres")
    if heal:
        player_moves.append(heal)
    
    return player_moves

static func create_enemy_moves() -> Array[Move]:
    var enemy_moves: Array[Move] = []
    
    # Add basic attack
    var basic_attack = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/basic_attack.tres")
    if basic_attack:
        enemy_moves.append(basic_attack)
    
    # Add void pull for special enemy
    var void_pull = MoveFactory.create_move_from_resource("res://scripts/moves/resources/special/void_pull.tres")
    if void_pull:
        enemy_moves.append(void_pull)
    
    return enemy_moves 