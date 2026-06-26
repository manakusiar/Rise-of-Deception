class_name ComponentEntityAbilities
extends Node

signal ability_cast(slot_name: StringName, data: DataAbility)
signal cooldown_finished(slot_name: StringName)

@export_subgroup("Nodes")
@export var effect_attachment: Node2D

@export_subgroup("Ability Settings")
@onready var slots: Dictionary[StringName, DataAbility] = {}

var _cooldowns: Dictionary[StringName, float] = {} # Spell &id and cooldown in sec

# ==================
# SAVING AND LOADING
# ==================

func Get_Save_Data() -> Dictionary:
	return slots

func Load_Save_Data(data: Dictionary[StringName, DataAbility]) -> void:
	slots = data

# ===============
# ENGINE CALLBACK
# ===============

func _ready() -> void:
	for _key: String in Utils.ability_slots.keys():
		slots[StringName(_key.to_lower()) + "_ability"] = null

func _process(delta: float) -> void:
	if _cooldowns.is_empty():
		return
	for key in _cooldowns.keys():
		_cooldowns[key] -= delta
		if _cooldowns[key] <= 0.0:
			_cooldowns.erase(key)
			cooldown_finished.emit(key)

# =======
# CASTING
# =======

func try_cast(slot: StringName) -> void:
	var _data = slots[slot]
	
	
	if _data == null:
		return
	if _data.effect_scene == null:
		push_warning("Ability '%s' has no effect_scene" % _data.display_name)
		return
	if is_on_cooldown(slot):
		return
	
	_cast(slot)

func _cast(slot: StringName) -> void:
	print("Casting ", slot)
	var _data = slots[slot]
	var effect := _data.effect_scene.instantiate() as AbilityEffect
	
	get_parent().add_child(effect)
	effect.activate(get_parent(), _aim_direction(), _data)

	_cooldowns[slot] = _data.cooldown
	ability_cast.emit(slot, _data)

# ================
# GETTER FUNCTIONS
# ================

func is_on_cooldown(slot: StringName) -> bool:
	return _cooldowns.has(slot) and _cooldowns[slot] > 0.0

func cooldown_remaining(slot_name: StringName) -> float:
	return _cooldowns.get(slot_name, 0.0)

func find_slot(slot_name: StringName) -> DataAbility:
	return slots[slot_name]

func _aim_direction() -> Vector2:
	var caster := get_parent()
	return caster.transform.x if caster is Node2D else Vector2.RIGHT

# ===================
# EQUIPMENT FUNCTIONS
# ===================

func equip(slot: StringName, new_data: DataAbility) -> DataAbility:
	var data := slots[slot]
	if data == null:
		push_warning("AbilityComponent has no slot named %s" % slot)
		return null
	var previous := data
	slots[slot] = new_data
	
	_cooldowns.erase(slot)
	return previous

func unequip(slot: StringName) -> DataAbility:
	return equip(slot, null)
