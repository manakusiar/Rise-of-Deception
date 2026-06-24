extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.external_camera_property_change.connect(_external_camera_property_change)

func _external_camera_property_change(properties: Dictionary[StringName, Variant]) -> void:
	for _property_name in properties:
		if _property_name in self:
			set(_property_name, properties[_property_name])
