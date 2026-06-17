class_name Stats
extends Resource

enum BuffableStats {
	MAX_HEALTH,
	MAX_MANA,
	ATTACK
}

const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://brqhenrycwvri"),
	BuffableStats.MAX_MANA: preload("uid://brqhenrycwvri"),
	BuffableStats.ATTACK: preload("uid://brqhenrycwvri")
}

const BASE_LEVEL_XP = 100.0

# =======
# SIGNALS
# =======

signal health_depleated
signal health_changed(cur_health: int, max_health: int)

# ====================
# ADJUSTABLE VARIABLES
# ====================

@export_subgroup("Stats")
@export var base_max_hp: float = 1.0
@export var base_max_mana: float = 1.0
@export var base_attack: float = 1.0
@export var experience: float = 0.0

var current_max_hp: float = 1.0
var current_max_mana: float = 1.0
var current_attack: float = 1.0

var stat_buffs: Array[StatBuff] = []

# =================
# DYNAMIC VARIABLES
# =================

var level: float:
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_XP) + 0.5))

var health: float = 0: 
	set(value):
		health = clampf(value, 0.0, current_max_hp)
		health_changed.emit(health, current_max_hp)
		if health <= 0:
			health_depleated.emit()

# ===============
# SETUP FUNCTIONS
# ===============

func _init() -> void:
	setup_stats.call_deferred()

func setup_stats() -> void:
	recalculate_stats()
	health = current_max_hp

# ==============
# HANDLING BUFFS
# ==============

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

# =======================
# HADNDLING DYNAMIC STATS
# =======================

func recalculate_stats() -> void:
	# Sum up all buffs
	var stat_multiplier: Dictionary = {}
	var stat_addends: Dictionary = {}
	for buff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower()
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
			StatBuff.BuffType.MULTIPLY:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 1.0
				stat_addends[stat_name] += buff.buff_amount
	
	# Calculate stats based on level
	var stat_sample_pos: float = float(level) / 100.0 - 0.01
	current_max_hp = base_max_hp * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
	current_max_mana = base_max_mana * STAT_CURVES[BuffableStats.MAX_MANA].sample(stat_sample_pos)
	current_attack = base_attack * STAT_CURVES[BuffableStats.ATTACK].sample(stat_sample_pos)
	
	# Apply buffs
	for stat_name in stat_multiplier:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multiplier[stat_name])
	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])
