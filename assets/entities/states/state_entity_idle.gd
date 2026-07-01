class_name StateEntityIdle
extends StateEntity

func enter(previous_state_path: String, data := {}) -> void:
	super.enter(previous_state_path, data)
	print("IDLE")
	entity.animation_component.play_animation(StringName('idle'))

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if abs(entity.velocity.x) >= fsm.run_margin:
		finish('run')
