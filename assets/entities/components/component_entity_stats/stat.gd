class_name Stat
extends Resource

@export var base_value: float = 1.0
@export var is_buffable: bool = false
@export var is_scalable: bool = false
@export var curve: Curve = preload("uid://brqhenrycwvri")

var value: float

func _init() -> void:
	setup.call_deferred()

func setup() -> void:
	value = base_value

func set_value(_value: float) -> void:
	value = _value
func get_value() -> float:
	return value

func recalculate(_sample_pos: float) -> void:
	if is_scalable:
		value = base_value * curve.sample(_sample_pos)
