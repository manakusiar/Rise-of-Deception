class_name AbilityComponent
extends Node

signal ability_cast(slot_name: StringName, data: AbilityData)
signal cooldown_finished(slot_name: StringName)

@export_subgroup("Nodes")
@export var effect_attachment: Node2D

@export_subgroup("Ability Settings")
@onready var slots: Dictionary[StringName, AbilityData] = {}

var _cooldowns: Dictionary[StringName, float] = {} # Spell &id and cooldown in sec

func _init() -> void:
	for _key: String in Utils.ability_slots.keys():
		slots[StringName(_key.to_lower())] = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_type():
		for slot in slots:
			if event.is_action_pressed(slot):
				try_cast(slot, slots[slot])

func try_cast(slot: StringName, data: AbilityData) -> void:
	if data == null:
		return
	if data.effect_scene == null:
		push_warning("Ability '%s' has no effect_scene" % data.display_name)
		return
	if is_on_cooldown(slot):
		return
	_cast(slot, data)

func _cast(slot: StringName, data: AbilityData) -> void:
	var effect := data.effect_scene.instantiate() as AbilityEffect
	get_parent().add_child(effect)
	effect.activate(get_parent(), _aim_direction(), data)

	_cooldowns[slot] = data.cooldown
	ability_cast.emit(slot, data)

func _process(delta: float) -> void:
	if _cooldowns.is_empty():
		return
	for key in _cooldowns.keys():
		_cooldowns[key] -= delta
		if _cooldowns[key] <= 0.0:
			_cooldowns.erase(key)
			cooldown_finished.emit(key)

# ================
# GETTER FUNCTIONS
# ================

func is_on_cooldown(slot: StringName) -> bool:
	return _cooldowns.has(slot) and _cooldowns[slot] > 0.0

func cooldown_remaining(slot_name: StringName) -> float:
	return _cooldowns.get(slot_name, 0.0)

func find_slot(slot_name: StringName) -> AbilityData:
	return slots[slot_name]

# ===================
# EQUIPMENT FUNCTIONS
# ===================

func equip(slot: StringName, new_data: AbilityData) -> AbilityData:
	var data := slots[slot]
	if data == null:
		push_warning("AbilityComponent has no slot named %s" % slot)
		return null
	var previous := data
	slots[slot] = new_data
	
	_cooldowns.erase(slot)
	return previous

func unequip(slot: StringName) -> AbilityData:
	return equip(slot, null)

#

func _aim_direction() -> Vector2:
	var caster := get_parent()
	return caster.transform.x if caster is Node2D else Vector2.RIGHT
