class_name MainMenu
extends Control

const SAMURAI_SPRITE_FRAMES = preload("res://assets/sprites/SamuraiSF.tres")

@onready var start_combat_button: Button = $VBoxContainer/StartCombatButton


func _ready():
	# Connect button signals
	start_combat_button.pressed.connect(_on_start_combat_button_pressed)

	# Set focus for keyboard navigation
	start_combat_button.grab_focus()


func _on_start_combat_button_pressed():
	print("Starting combat test...")

	# Create a test combat scene using the Factory pattern
	var combat_scene = _create_test_combat()

	if combat_scene != null:
		# Add the combat scene to the current scene tree
		get_tree().current_scene.add_child(combat_scene)

		# Hide the main menu
		visible = false

		# Connect to combat end signal to return to menu
		var combat_manager = combat_scene.get_node("CombatManager")
		if combat_manager and combat_manager.has_signal("combat_ended"):
			combat_manager.combat_ended.connect(_on_combat_ended)
		else:
			# Fallback: return to menu after a delay
			await get_tree().create_timer(5.0).timeout
			_return_to_menu()


func _create_test_combat() -> Node:
	# Create basic player data
	var player_data = PlayerData.new()
	player_data.entity_name = "Test Player"
	player_data.max_health = 100
	player_data.current_health = 100
	player_data.combat_position = Vector3.ZERO
	player_data.flip_horizontal = false

	# Use SamuraiSF.tres for player sprite frames
	player_data.sprite_frames = SAMURAI_SPRITE_FRAMES

	# Create basic stats
	var player_stats = CharacterStats.new()
	player_stats.attack_bonus = 5
	player_stats.defense_bonus = 3
	player_data.stats = player_stats

	# Set up basic moves (will be created by MoveFactory)
	var basic_attack = MoveFactory.create_move_by_id("BASIC_ATTACK")
	var defend = MoveFactory.create_move_by_id("DEFEND")

	# Store MoveData resources instead of Move objects
	player_data.moves = (
		[basic_attack.move_data, defend.move_data] as Array[MoveData]
	)

	# Create combat scene using Factory
	return CombatPresetFactory.create_specific_combat(
		player_data, "tutorial_combat"
	)


func _on_combat_ended(victory: bool, rewards: Array = []):
	print("Combat ended. Victory: ", victory)
	if rewards.size() > 0:
		print("Rewards: ", rewards)

	_return_to_menu()


func _return_to_menu():
	print("returning to main menu")

	await get_tree().create_timer(4.0).timeout
	# Remove combat scene if it exists
	var combat_scene = get_node_or_null("Combat")

	if combat_scene:
		combat_scene.queue_free()

	# Show main menu again
	visible = true
	start_combat_button.grab_focus()


func _input(event):
	# Allow returning to menu with Escape key
	if event.is_action_pressed("ui_cancel"):
		if not visible:
			_return_to_menu()
