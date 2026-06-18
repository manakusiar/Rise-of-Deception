class_name Entity
extends CharacterBody2D

@export_subgroup("Nodes/Components")
@export var physics_component: PhysicsComponent 
@export var input_component: InputComponent
@export var ability_component: AbilityComponent

@export_subgroup("Settings")
@export var stats: Stats = preload("uid://bm8ogs5nwbkts")

func _ready() -> void:
	input_component.Jump.connect(_input_jump)
	input_component.Attack.connect(_input_attack)
	input_component.Ability.connect(_input_ability)

func _physics_process(delta: float) -> void:
	physics_component.Handle_Physics(delta, input_component.Get_Movement_Direction())

func _input_jump(is_pressed: bool) -> void:
	physics_component.Jump(is_pressed)
func _input_attack(is_pressed: bool) -> void:
	physics_component.Attack(is_pressed)

func _input_ability(is_pressed: bool, ability_name: StringName) -> void:
	if is_pressed:
		ability_component.try_cast(ability_name)
