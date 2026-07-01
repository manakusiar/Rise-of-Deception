class_name State
extends Node

var fsm: ComponentFiniteStateMachine 

signal finished(this_state: State, next_state: StringName, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	pass

func exit() -> void:
	pass

func finish(next_state: StringName, data: Dictionary = {}) -> void:
	finished.emit(self, next_state, data)
	
