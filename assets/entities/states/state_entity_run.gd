class_name StateEntityRun
extends StateEntity

func enter(previous_state_path: String, data := {}) -> void:
	super.enter(previous_state_path, data)
	print("RUNNING")
	entity.animation_component.play_animation('run')

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if abs(entity.velocity.x) < fsm.run_margin:
		finish('idle')
