class_name MainMenu
extends Control

const IDLE_SPRITE = preload(
	"res://assets/prototyping/FREE_Samurai 2D Pixel Art v1.2/Sprites/IDLE.png"
)

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
			print("paso por aca")
			_return_to_menu()


func _create_test_combat() -> Node:
	# Create a basic test combat configuration
	var config = CombatConfig.new()

	# Create basic player data
	var player_data = PlayerData.new()
	player_data.entity_name = "Test Player"
	player_data.max_health = 100
	player_data.current_health = 100
	player_data.current_energy = 100
	player_data.experience_level = 1
	player_data.combat_position = Vector3(-0.5, 0.0, 0.333)
	player_data.flip_horizontal = false

	# Create sprite frames for player
	var player_sprite_frames = SpriteFrames.new()

	# Configure idle animation with multiple frames
	player_sprite_frames.add_animation("idle")
	player_sprite_frames.set_animation_speed("idle", 10.0)  # 10 FPS
	player_sprite_frames.set_animation_loop("idle", true)  # Loop enabled

	# Add frames for idle animation (assuming 4 frames horizontally)
	var frame_width = 96
	var frame_height = 96
	var total_frames = 10  # Typical idle animation frames

	for i in range(total_frames):
		var idle_atlas = AtlasTexture.new()
		idle_atlas.atlas = IDLE_SPRITE
		idle_atlas.region = Rect2(i * frame_width, 0, frame_width, frame_height)
		player_sprite_frames.add_frame("idle", idle_atlas)

	player_data.sprite_frames = player_sprite_frames

	# Create basic stats
	var player_stats = CharacterStats.new()
	player_stats.attack_bonus = 5
	player_stats.defense_bonus = 3
	player_data.stats = player_stats

	# Create basic enemy data
	var enemy_data = EnemyData.new()
	enemy_data.entity_name = "Test Enemy"
	enemy_data.max_health = 80
	enemy_data.combat_position = Vector3(0.5, 0.0, -0.333)
	enemy_data.flip_horizontal = true
	enemy_data.ai_type = "AGGRESSIVE"
	enemy_data.difficulty_rating = 1
	enemy_data.region_affiliation = "test"

	# Create sprite frames for enemy (using different color modulation)
	var enemy_sprite_frames = SpriteFrames.new()

	# Configure idle animation with multiple frames
	enemy_sprite_frames.add_animation("idle")
	enemy_sprite_frames.set_animation_speed("idle", 10.0)  # 10 FPS
	enemy_sprite_frames.set_animation_loop("idle", true)  # Loop enabled

	# Add frames for idle animation (assuming 4 frames horizontally)
	var enemy_frame_width = 96
	var enemy_frame_height = 96
	var enemy_total_frames = 10  # Typical idle animation frames

	for i in range(enemy_total_frames):
		var enemy_idle_atlas = AtlasTexture.new()
		enemy_idle_atlas.atlas = IDLE_SPRITE
		enemy_idle_atlas.region = Rect2(
			i * enemy_frame_width, 0, enemy_frame_width, enemy_frame_height
		)
		enemy_sprite_frames.add_frame("idle", enemy_idle_atlas)

	enemy_data.sprite_frames = enemy_sprite_frames
	enemy_data.color_modulation = Color.RED  # Make enemy red to distinguish

	# Create basic enemy stats
	var enemy_stats = CharacterStats.new()
	enemy_stats.attack_bonus = 3
	enemy_stats.defense_bonus = 2
	enemy_data.stats = enemy_stats

	# Set up basic moves (will be created by MoveFactory)
	var basic_attack = MoveData.new()
	basic_attack.move_name = "Basic Attack"
	basic_attack.move_type = MoveData.MoveType.OFFENSIVE
	basic_attack.damage = 15
	basic_attack.energy_cost = 0

	var defend = MoveData.new()
	defend.move_name = "Defend"
	defend.move_type = MoveData.MoveType.DEFENSIVE
	defend.defense = 10
	defend.energy_cost = 0

	player_data.moves = [basic_attack, defend] as Array[MoveData]
	enemy_data.moves = [basic_attack, defend] as Array[MoveData]

	# Configure combat settings
	config.player_data = player_data
	config.enemy_data = enemy_data
	config.combat_background = "default"
	config.music_track = "combat_default"
	config.lighting_setting = "default"

	# Create combat scene using Factory
	return CombatFactory.create_combat_scene(config)


func _on_combat_ended(victory: bool, rewards: Array = []):
	print("Combat ended. Victory: ", victory)
	if rewards.size() > 0:
		print("Rewards: ", rewards)

	_return_to_menu()


func _return_to_menu():
	print("returning to main menu")
	# Remove combat scene if it exists
	var combat_scenes = get_tree().get_nodes_in_group("combat_scene")
	for scene in combat_scenes:
		scene.queue_free()

	# Show main menu again
	visible = true
	start_combat_button.grab_focus()


func _input(event):
	# Allow returning to menu with Escape key
	if event.is_action_pressed("ui_cancel"):
		if not visible:
			_return_to_menu()
