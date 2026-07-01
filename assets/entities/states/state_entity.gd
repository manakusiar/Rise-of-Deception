class_name StateEntity
extends State

var entity: Entity = null

func enter(previous_state_path: String, data := {}) -> void:
	setup()

func exit() -> void:
	dissasemble()

func physics_update(_delta: float) -> void:
	if entity:
		_entity_handle_physics(_delta)

#region Entity State functions
func setup() -> void:
	if fsm is ComponentFiniteStateMachineEntity:
		entity = fsm.entity
		
		if entity.input_component:
			entity.input_component.Jump.connect(_input_jump)
			entity.input_component.Attack.connect(_input_attack)
			entity.input_component.Ability.connect(_input_ability)
	else:
		push_error("Error: Entity state is not under an non-entity state machine!")

func dissasemble() -> void:
	if entity:
		if entity.input_component:
			entity.input_component.Jump.disconnect(_input_jump)
			entity.input_component.Attack.disconnect(_input_attack)
			entity.input_component.Ability.disconnect(_input_ability)
#endregion

#region Input into Physics component

func _entity_handle_physics(_delta: float) -> void:
	if entity.physics_component and entity.input_component:
		var _direction = entity.input_component.Get_Movement_Direction()
		entity.physics_component.Handle_Physics(_delta, _direction)
		if _direction.x != 0.0:
			entity.animation_component.flip_sprite(_direction.x < 0)

func _input_jump(is_pressed: bool) -> void:
	entity.physics_component.Jump(is_pressed)

func _input_attack(is_pressed: bool) -> void:
	entity.physics_component.Attack(is_pressed)

func _input_ability(is_pressed: bool, ability_name: StringName) -> void:
	if is_pressed:
		entity.ability_component.try_cast(ability_name)
#endregion
