class_name ComponentFiniteStateMachine
extends Node

@export var initial_state: State = null

var current_state: State
var states: Dictionary[StringName, State] = {}

func setup() -> void:
	for _state: State in find_children("*", "State"):
		_state.finished.connect(move_to_state)
		_state.fsm = self
		states[StringName(_state.name.to_lower())] = _state
	
	current_state = _get_initial_state()
	current_state.enter("")

func update(_delta: float) -> void:
	if current_state:
		current_state.update(_delta)
func physics_update(_delta: float) -> void:
	if current_state:
		current_state.physics_update(_delta)
func handle_input(_event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(_event)

func move_to_state(sent_state: State, target_state: StringName, data: Dictionary = {}) -> void:
	if sent_state == current_state and target_state in states:
		var _old_state = StringName(current_state.name.to_lower())
		current_state.exit()
		current_state = states[target_state.to_lower()]
		current_state.enter(_old_state, data)

func _get_initial_state() -> State:
	if initial_state:
		return initial_state
	else:
		return get_child(0)
