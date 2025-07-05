class_name AnimationController
extends RefCounted

var animated_sprite: AnimatedSprite3D

signal animation_finished


func _init(sprite: AnimatedSprite3D):
	animated_sprite = sprite
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	# Volver a idle cuando termine cualquier animación
	animated_sprite.play("idle")


func play_move_animation(move_data: MoveData) -> float:
	var anim_name = move_data.animation_name

	animated_sprite.play(anim_name)

	return get_animation_duration(anim_name)


func get_animation_duration(animation_name: String) -> float:
	"""Obtiene la duración de una animación en segundos"""
	if not animated_sprite or not animated_sprite.sprite_frames:
		return 1.0

	var sprite_frames = animated_sprite.sprite_frames
	var frame_count = sprite_frames.get_frame_count(animation_name)
	var fps = sprite_frames.get_animation_speed(animation_name)

	return float(frame_count) / fps
