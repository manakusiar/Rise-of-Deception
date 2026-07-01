class_name Entity
extends CharacterBody2D

@export_subgroup("Nodes/Components")
@export var physics_component: ComponentEntityPhysics
@export var input_component: ComponentEntityInput
@export var ability_component: ComponentEntityAbilities
@export var inventory_component: ComponentEntityInventory
@export var animation_component: ComponentEntityAnimation
@export var state_machine: ComponentFiniteStateMachineEntity
@export var persistent_id: PersistentID
@export var effect_component: ComponentEntityEffect

@export_subgroup("Settings")
@export var stats: EntityStats = preload("uid://bm8ogs5nwbkts")

signal hit_ground(_velocity: Vector2)

#region Saving / Loading
func setup_data_manager(map: RoomScene) -> void:
	if persistent_id:
		map.game_saving.connect(_game_saving)
		map.game_loading.connect(_game_loading)

func _game_saving(room_data: RoomState) -> void:
	print("GAME SAVING AS: ", name, " in the ", room_data.type, " map")
	var _room_data = room_data.data
	var _id = persistent_id.unique_id
	
	if !_room_data.has(_id):
		_room_data[_id] = DataEntity.new()
	
	var _data: DataEntity = _room_data[_id]
	if physics_component:
		_data.physics_data = physics_component.Get_Save_Data()
	if inventory_component:
		_data.inventory = inventory_component.Get_Save_Data()
	if ability_component:
		_data.abilities = ability_component.Get_Save_Data()
	if stats:
		_data.stats = stats.Get_Save_Data()
	
	print("FINISHED SAVING DATA")

func _game_loading(room_data: RoomState) -> void:
	print("GAME LOADING AS: ", name, " in the ", room_data.type, " map")
	var _room_data = room_data.data
	var _id = persistent_id.unique_id
	
	if _room_data.has(_id):
		var _data: DataEntity = _room_data[_id]
		if physics_component:
			physics_component.Load_Save_Data(_data.physics_data)
		if inventory_component:
			inventory_component.Load_Save_Data(_data.inventory)
		if ability_component:
			ability_component.Load_Save_Data(_data.abilities)
		if stats:
			stats.Load_Save_Data(_data.stats)
#endregion

func _ready() -> void:
	if state_machine:
		state_machine.entity = self
		state_machine.setup()

func _process(delta: float) -> void:
	if state_machine:
		state_machine.update(delta)

func _physics_process(delta: float) -> void:
	if state_machine:
		state_machine.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if state_machine:
		state_machine.handle_input(event)
