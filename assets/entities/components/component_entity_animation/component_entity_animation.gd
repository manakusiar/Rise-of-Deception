class_name ComponentEntityAnimation
extends Node

@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer

signal animation_finished(anim_name: StringName)
signal animation_changed(old_name: StringName, new_name: StringName)
signal current_animation_changed(anim_name: StringName)

var queue: Array[StringName] = []

func _ready() -> void:
	anim_player.animation_finished.connect(_animation_finished)

func play_animation(anim_name: StringName) -> void:
	if anim_player and anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
		queue.clear()

func get_current_animation() -> String:
	if anim_player:
		return anim_player.current_animation
	return ""

func flip_sprite(is_flipped: bool) -> void:
	sprite.flip_h = is_flipped

func _animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
	if queue.size() > 0:
		var _new_anim = queue.pop_front()
		play_animation(_new_anim)
