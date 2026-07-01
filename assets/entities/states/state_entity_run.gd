class_name StateEntityRun
extends StateEntity

func enter(previous_state_path: String, data := {}) -> void:
	super.enter(previous_state_path, data)
	entity.animation_component.play_animation('run')

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if !entity.is_on_floor():
		finish('jump')
	
	if abs(entity.velocity.x) < fsm.run_margin:
		finish('idle')
