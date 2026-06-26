class_name ExternalCamera
extends Camera2D

const base_position := Vector2(320, 180)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.external_camera_property_change.connect(_external_camera_property_change)
	Global.external_camera = self

func _external_camera_property_change(properties: Dictionary[StringName, Variant]) -> void:
	for _property_name in properties:
		if _property_name in self:
			set(_property_name, properties[_property_name])

func reset_position() -> void:
	global_position = base_position
