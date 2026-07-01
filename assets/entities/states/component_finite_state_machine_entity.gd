class_name ComponentFiniteStateMachineEntity
extends ComponentFiniteStateMachine

var entity: Entity = null
@export var run_margin := 10.0

func setup() -> void:
	super.setup()
	
	run_margin = entity.physics_component.walk_acceleration / 60
