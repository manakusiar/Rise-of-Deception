class_name ComponentUIPixelTransition
extends Control

var current_transition: TransitionData
var first_phase: bool = true

@export var pixel_arrow_transition: Control

var progress_tween: Tween

var all_transitions: Dictionary[Utils.pixel_transition_types, TransitionData]

var time := 0.25

func _ready() -> void:
	SignalBus.start_transition.connect(start_transition)
	
	all_transitions[Utils.pixel_transition_types.ARROW] = TransitionData.new(
		pixel_arrow_transition
	)
	
	#start_transition.call_deferred(Utils.pixel_transition_types.ARROW, Vector2.ZERO)

func start_transition(transition_type: Utils.pixel_transition_types, direction: Vector2) -> void:
	var _transition = all_transitions[transition_type]
	current_transition = _transition
	
	_reset_current_transition()
	_set_fade_in(true)
	_set_direction(direction)
	
	if progress_tween and progress_tween.is_valid():
		progress_tween.kill()
	progress_tween = create_tween()
	progress_tween.set_trans(Tween.TRANS_CUBIC)
	
	progress_tween.tween_method(
		_set_progress,
		current_transition.reset,
		current_transition.target_in,
		time
	)
	
	progress_tween.tween_callback(_phase_two_setup.bind(transition_type))
	
	progress_tween.tween_method(
		_set_progress,
		current_transition.reset,
		current_transition.target_out,
		time
	)
	
	progress_tween.tween_callback(_phase_two_end.bind(transition_type))

func _set_progress(value: float) -> void:
	current_transition.object.material.set_shader_parameter(
		"progress",
		value
	)

func _phase_two_setup(transition: Utils.pixel_transition_types) -> void:
	SignalBus.transition_mid_way.emit(transition)
	_reset_current_transition()
	_set_fade_in(false)

func _phase_two_end(transition: Utils.pixel_transition_types) -> void:
	SignalBus.transition_ended.emit(transition)
	#_reset_current_transition()

func _reset_current_transition() -> void:
	current_transition.object.material.set_shader_parameter(
		"progress",
		current_transition.reset
	)

func _set_fade_in(value: bool) -> void:
	if current_transition.has_fade_in:
		current_transition.object.material.set_shader_parameter(
			"fade_in",
			value
		)

func _set_direction(value: Vector2) -> void:
	current_transition.object.material.set_shader_parameter(
		"direction",
		value.normalized()
	)

class TransitionData:
	var object: Object
	var property: String
	var target_in: Variant
	var target_out: Variant
	var reset: Variant
	var has_fade_in: bool = true
	var fade_in: String = "fade_in"
	
	func _init(_object: Object, _property: String = "progress", _target_in: Variant = 1.0, _target_out: Variant = 1.0, _reset: Variant = 0.0) -> void:
		object = _object
		property = _property
		target_in = _target_in
		target_out = _target_out
		reset = _reset
