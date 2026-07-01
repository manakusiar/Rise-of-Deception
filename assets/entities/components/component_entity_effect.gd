class_name ComponentEntityEffect
extends Node

var effect_tween: Tween
@export var sprite: Sprite2D

func set_scale_effect(_stages: Array[Dictionary]) -> void:
	if effect_tween and effect_tween.is_valid():
		effect_tween.kill()
	
	effect_tween = create_tween()
	for _stage in _stages:
		effect_tween.tween_property(sprite, "scale", _stage['value'], _stage['time'])

func get_stage(value: Variant, time: float) -> Dictionary:
	return {"value": value, "time": time}
