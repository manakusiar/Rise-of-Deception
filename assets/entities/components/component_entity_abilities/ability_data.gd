extends Resource
class_name DataAbility

@export var id: StringName = &""
@export var display_name: String = "Emtpy Ability"
@export var icon: Texture2D
@export_multiline var description: String = ""

@export_group("Costs")
@export var cooldown: float = 1.0 # In seconds
@export var mana_cost: float = 0.0

@export_group("Combat")
@export var base_damage: float = 0.0
@export var effect_scene: PackedScene
