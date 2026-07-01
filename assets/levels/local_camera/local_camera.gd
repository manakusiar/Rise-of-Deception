class_name LocalCamera
extends Camera2D

@export_subgroup("Components")
@export var movement_component: ComponentLocalCameraMovement

# External Nodes
var external_camera: Camera2D

var external_zoom: float:
	get():
		if external_camera:
			return external_camera.zoom.x
		else:
			return 0.0 

#region Engine Callback
func _physics_process(delta: float) -> void:
	movement_component.handle_physics(delta)

func _ready() -> void:
	# Signals
	Global.external_camera_updated.connect(_update_external_camera)
	
	# Setup
	_setup.call_deferred()
#endregion

func _setup() -> void:
	_update_external_camera(Global.external_camera)
	Global.internal_camera = self

#region Signal Callback
func _update_external_camera(_camera: ExternalCamera) -> void:
	external_camera = _camera
#endregion

func room_setup(_left: float, _right: float, _top: float, _bottom: float, transition: Utils.pixel_transition_types) -> void:
	if transition != Utils.pixel_transition_types.NONE:
		movement_component.movement_is_enabled = false
		movement_component.connect_enable_movement(SignalBus.transition_mid_way)
	movement_component.room_setup(_left, _right, _top, _bottom)
	print("CAMERA SET UP ", transition)
