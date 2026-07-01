class_name ComponentEntityPhysics
extends Node

@export var entity: Entity
@export var has_gravity: bool = true

var velocity:
	get(): return entity.velocity
	set(value): entity.velocity = value

var stats: EntityStats:
	get(): return entity.stats

var walk_acceleration:
	get(): return stats.get_stat(Utils.stat_names.WALK_ACCELERATION)
var jump_velocity: 
	get(): return stats.get_stat(Utils.stat_names.JUMP_VELOCITY)
var max_horizontal_velocity:
	get(): return stats.get_stat(Utils.stat_names.MAX_HORIZONTAL_VELOCITY)
var max_vertical_velocity:
	get(): return stats.get_stat(Utils.stat_names.MAX_VERTICAL_VELOCITY)

#region Save & Load
func Get_Save_Data() -> Dictionary:
	return {
		 &"velocity": entity.velocity
	}

func Load_Save_Data(data: Dictionary) -> void:
	entity.velocity = data[&"velocity"]
#endregion

func Handle_Physics(delta: float, movement_direction: Vector2) -> void:
	var direction := movement_direction
	if has_gravity:
		direction.y = 0
		if !entity.is_on_floor():
			velocity += entity.get_gravity() * delta
	
	if direction:
		velocity += direction * walk_acceleration * delta
	
	velocity.x *= 0.9
	if !has_gravity:
		velocity.y *= 0.9
	
	var _past_velocity: Vector2 = velocity
	var _was_on_floor = entity.is_on_floor()
	
	entity.move_and_slide()
	
	if entity.is_on_floor() != _was_on_floor:
		entity.hit_ground.emit(_past_velocity)
	if max_horizontal_velocity != -1:
		entity.velocity.x = clamp(entity.velocity.x, -max_horizontal_velocity, max_horizontal_velocity)
	if max_vertical_velocity != -1:
		entity.velocity.y = clamp(entity.velocity.y, -max_vertical_velocity, max_vertical_velocity)

func Jump(is_pressed: bool) -> void:
	if is_pressed and entity.is_on_floor():
		var _jump_vel = stats.get_stat(Utils.stat_names.JUMP_VELOCITY)
		velocity.y = _jump_vel
	elif !is_pressed:
		velocity.y *= 0.5

func Attack(is_pressed: bool) -> void:
	pass

func Ability(is_pressed: bool) -> void:
	pass
