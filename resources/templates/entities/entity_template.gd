class_name Entity
extends CharacterBody2D

@export_subgroup("Nodes/Components")
@export var physics_component: PhysicsComponent 
@export var input_component: InputComponent
@export var ability_component: AbilityComponent
@export var inventory_component: InventoryComponent
@export var persistent_id: PersistentID

@export_subgroup("Settings")
@export var stats: Stats = preload("uid://bm8ogs5nwbkts")


func _ready() -> void:
	if input_component:
		input_component.Jump.connect(_input_jump)
		input_component.Attack.connect(_input_attack)
		input_component.Ability.connect(_input_ability)

func setup_data_manager(map: RoomScene) -> void:
	if persistent_id:
		map.game_saving.connect(_game_saving)
		map.game_loading.connect(_game_loading)

#region Saving / Loading
func _game_saving(room_data: RoomState) -> void:
	print("GAME SAVING AS: ", name, " in the ", room_data.type, " map")
	var _room_data = room_data.data
	var _id = persistent_id.unique_id
	
	if !_room_data.has(_id):
		_room_data[_id] = EntityData.new()
	
	var _data: EntityData = _room_data[_id]
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
		var _data: EntityData = _room_data[_id]
		if physics_component:
			physics_component.Load_Save_Data(_data.physics_data)
		if inventory_component:
			inventory_component.Load_Save_Data(_data.inventory)
		if ability_component:
			ability_component.Load_Save_Data(_data.abilities)
		if stats:
			stats.Load_Save_Data(_data.stats)
#endregion

func _physics_process(delta: float) -> void:
	if physics_component and input_component:
		physics_component.Handle_Physics(delta, input_component.Get_Movement_Direction())

func _input_jump(is_pressed: bool) -> void:
	physics_component.Jump(is_pressed)
func _input_attack(is_pressed: bool) -> void:
	physics_component.Attack(is_pressed)

func _input_ability(is_pressed: bool, ability_name: StringName) -> void:
	if is_pressed:
		ability_component.try_cast(ability_name)
