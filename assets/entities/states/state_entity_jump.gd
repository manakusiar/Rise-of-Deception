class_name StateEntityJump
extends StateEntity

func enter(previous_state_path: String, data := {}) -> void:
	super.enter(previous_state_path, data)
	
	var _effect_component := entity.effect_component
	_effect_component.set_scale_effect([
		_effect_component.get_stage(Vector2(0.75, 1.25), 0.07),
		_effect_component.get_stage(Vector2(1.0, 1.0), 0.14)
	])
	
	entity.hit_ground.connect(_hit_ground)

func exit() -> void:
	super.exit()
	
	entity.hit_ground.disconnect(_hit_ground)

func _hit_ground(velocity: Vector2) -> void:
	var _min_value = 100
	var _max_value = 600
	var _power_vel = Vector2(1.2, 0.8).lerp(Vector2(1.75, 0.25), (velocity.y - _min_value) / (_max_value - _min_value)) 
	
	var _effect_component := entity.effect_component
	_effect_component.set_scale_effect([
		_effect_component.get_stage(_power_vel, 0.035),
		_effect_component.get_stage(Vector2(1.1, 0.9), 0.14),
		_effect_component.get_stage(Vector2(1, 1), 0.035)
	])
	
	# Bouncy XD
	#if abs(velocity.y) > 256:
		#_effect_component.effect_tween.tween_property(_effect_component.sprite, "scale", Vector2(0.5, 1.5), 0.07)
		#_effect_component.effect_tween.tween_property(_effect_component.sprite, "scale", Vector2(1.0, 1.0), 0.14)
		#print(velocity)
		#entity.velocity.y = -floor(velocity.y) * 4 / 5

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if entity.velocity.y > 0:
		entity.animation_component.play_animation(StringName('fall'))
	else:
		entity.animation_component.play_animation(StringName('rise'))
	
	if entity.is_on_floor():
		finish('run')
