class_name SpritePresets
extends Resource

static var presets = {
	"samurai_idle":
	{
		"sprite_path":
		"res://assets/prototyping/FREE_Samurai 2D Pixel Art v1.2/Sprites/IDLE.png",
		"frame_width": 96,
		"frame_height": 96,
		"total_frames": 10,
		"fps": 10,
		"loop": true
	},
	"samurai_run":
	{
		"sprite_path":
		"res://assets/prototyping/FREE_Samurai 2D Pixel Art v1.2/Sprites/RUN.png",
		"frame_width": 96,
		"frame_height": 96,
		"total_frames": 8,
		"fps": 12,
		"loop": true
	}
}


static func create_sprite_frames(preset_name: String) -> SpriteFrames:
	var preset = presets.get(preset_name, presets["samurai_idle"])
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("idle")
	sprite_frames.set_animation_speed("idle", preset["fps"])
	sprite_frames.set_animation_loop("idle", preset["loop"])
	var texture = load(preset["sprite_path"])
	for i in range(preset["total_frames"]):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(
			i * preset["frame_width"],
			0,
			preset["frame_width"],
			preset["frame_height"]
		)
		sprite_frames.add_frame("idle", atlas)
	return sprite_frames
