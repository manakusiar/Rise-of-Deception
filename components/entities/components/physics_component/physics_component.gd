class_name PhysicsComponent
extends Node

@export var entity: CharacterBody2D

var velocity:
	get():
		return entity.velocity
	set(value):
		entity.velocity = value

func Handle_Physics(delta: float, movement_direction: Vector2) -> void:
	# Add the gravity.
	if not entity.is_on_floor():
		velocity += entity.get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := movement_direction.x
	if direction:
		velocity.x = direction * entity.SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, entity.SPEED)

	entity.move_and_slide()

func Jump(is_pressed: bool) -> void:
	if entity.is_on_floor():
		velocity.y = entity.JUMP_VELOCITY
	elif !is_pressed:
		velocity.y *= 0.5

func Attack(is_pressed: bool) -> void:
	pass

func Ability(is_pressed: bool) -> void:
	pass
