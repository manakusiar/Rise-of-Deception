@tool
class_name PersistentID
extends Node

@export var unique_id: StringName = "":
	set(val):
		unique_id = val
		notify_property_list_changed()
@export var reset_id: bool = false:
	set(val):
		generate_unique_id()

func _ready() -> void:
	if Engine.is_editor_hint():
		if owner != null and owner != self:
			if unique_id == "":
				generate_unique_id()
	else:
		if unique_id == "":
			generate_unique_id()

func generate_unique_id():
	var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyz0123456789"
	var result = ""
	for i in range(16):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	
	unique_id = result
	
	if get_parent():
		get_parent().update_configuration_warnings() 
