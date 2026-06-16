extends CharacterBody2D

@export_subgroup("Nodes/Components")
@export var physics_component: PhysicsComponent
@export var input_component: InputComponent
@export var ability_component: AbiltiyCom

const SPEED := 400.0
const JUMP_VELOCITY := -400.0

func _ready() -> void:
	input_component.Jump.connect(_input_jump)

func _physics_process(delta: float) -> void:
	physics_component.Handle_Physics(delta, input_component.Get_Movement_Direction())

func _input_jump(is_pressed: bool) -> void:
	physics_component.Jump(is_pressed)
func _input_attack(is_pressed: bool) -> void:
	physics_component.Attack(is_pressed)

func _input_ability(is_pressed: bool, ability_name: StringName) -> void:
	ability_component.
