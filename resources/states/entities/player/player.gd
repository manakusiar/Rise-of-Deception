extends Entity
class_name Player

func _game_saving(room_data: RoomState) -> void:
	var _player_data = DataManager.master_data.player_data
	var _id = persistent_id.unique_id
	
	if !_player_data.has(_id):
		_player_data[_id] = EntityData.new()
	
	var _data: EntityData = _player_data[_id]
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
	print("GAME LOADING AS: ", name)
	
	var _player_data = DataManager.master_data.player_data
	var _id = persistent_id.unique_id
	
	if _player_data.has(_id):
		var _data: EntityData = _player_data[_id]
		if physics_component:
			physics_component.Load_Save_Data(_data.physics_data)
		if inventory_component:
			inventory_component.Load_Save_Data(_data.inventory)
		if ability_component:
			ability_component.Load_Save_Data(_data.abilities)
		if stats:
			stats.Load_Save_Data(_data.stats)
