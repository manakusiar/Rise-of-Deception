class_name PlayerInputComponent
extends InputComponent

func _init() -> void:
	for _key: String in Utils.ability_slots.keys():
		abilities.append(StringName(_key.to_lower() + "_ability"))

func _input(event: InputEvent) -> void:
	if event.is_action_type():
		# Press and release signals
		var event_and_signal: Dictionary[String, Signal]= {
			"attack": Attack,
			"jump": Jump
		}
		
		for _key in event_and_signal:
			if event.is_action(_key):
				event_and_signal[_key].emit(event.is_action_pressed(_key))
				return
		
		# Ability signals
		for _ability in abilities:
			if event.is_action(_ability):
				Ability.emit(event.is_action_pressed(_ability), _ability)
				return

func Get_Movement_Direction() -> Vector2:
	movement_direction.x = Input.get_axis("move_left", "move_right")
	movement_direction.y = Input.get_axis("look_up", "look_down")
	return movement_direction
