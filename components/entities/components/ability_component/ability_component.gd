class_name AbilityComponent
extends Node

signal ability_cast(slot_name: StringName, data: AbilityData)
signal cooldown_finished(slot_name: StringName)

@export_subgroup("Nodes")
@export var effect_attachment: Node2D

@export_subgroup("Ability Settings")
@export var slots: Array[AbilitySlot] = []

var _cooldowns: Dictionary[StringName, float] = {} # Spell &id and cooldown in sec

func _unhandled_input(event: InputEvent) -> void:
	for slot in slots:
		if event.is_action_pressed(slot.input_action):
			try_cast(slot)

func try_cast(slot: AbilitySlot) -> void:
	if slot == null or slot.ability == null:
		return
	if slot.ability.effect_scene == null:
		push_warning("Ability '%s' has no effect_scene" % slot.ability.display_name)
		return
	if is_on_cooldown(slot):
		return
	_cast(slot)

func _cast(slot: AbilitySlot) -> void:
	var data := slot.ability
	var effect := data.effect_scene.instantiate() as AbilityEffect
	get_parent().add_child(effect)
	effect.activate(get_parent(), _aim_direction(), data)

	_cooldowns[slot.slot_name] = data.cooldown
	ability_cast.emit(slot.slot_name, data)

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

func is_on_cooldown(slot: AbilitySlot) -> bool:
	return _cooldowns.has(slot.slot_name) and _cooldowns[slot.slot_name] > 0.0

func cooldown_remaining(slot_name: StringName) -> float:
	return _cooldowns.get(slot_name, 0.0)

func find_slot(slot_name: StringName) -> AbilitySlot:
	for slot in slots:
		if slot.slot_name == slot_name:
			return slot
	return null

# ===================
# EQUIPMENT FUNCTIONS
# ===================

func equip(slot_name: StringName, data: AbilityData) -> AbilityData:
	var slot := find_slot(slot_name)
	if slot == null:
		push_warning("AbilityComponent has no slot named %s" % slot_name)
		return null
	var previous := slot.ability
	slot.ability = data
	
	_cooldowns.erase(slot_name)
	return previous

func unequip(slot_name: StringName) -> AbilityData:
	return equip(slot_name, null)

#

func _aim_direction() -> Vector2:
	var caster := get_parent()
	return caster.transform.x if caster is Node2D else Vector2.RIGHT
