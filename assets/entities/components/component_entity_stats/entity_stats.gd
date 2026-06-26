class_name EntityStats
extends Resource

# =====================
# STAT SETTINGS SECTION
# =====================

@export var all_stats: Dictionary[Utils.stat_names, Stat] = {}

# =========
# VARIABLES
# =========

const BASE_LEVEL_XP = 100.0

var level: float = 1.0

var stat_buffs: Array[StatBuff] = []

# ===============
# SETUP FUNCTIONS
# ===============

func _init() -> void:
	setup_stats.call_deferred()

func setup_stats() -> void:
	#for _key in all_stats:
		#print(Utils.stat_names.keys()[_key], ": ", all_stats[_key].value)
	recalculate_stats()

# ==================
# SAVING AND LOADING
# ==================

func Get_Save_Data() -> Dictionary:
	return {
		"stats": all_stats,
		"stat_buffs": stat_buffs
	}

func Load_Save_Data(data: Dictionary) -> void:
	all_stats = data["stats"]
	stat_buffs = data["stat_buffs"]

# =======================
# HADNDLING DYNAMIC STATS
# =======================

func recalculate_stats() -> void:
	# Sum up all buffs
	var stat_multiplier: Dictionary = {}
	var stat_addends: Dictionary = {}
	for buff in stat_buffs:
		var stat_name: Utils.stat_names = buff.stat
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
			StatBuff.BuffType.MULTIPLY:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 1.0
				stat_addends[stat_name] += buff.buff_amount
		#for i in buff.get_property_list():
			#print(i.name, ": ", buff.get(i.name))
	
	# Calculate stats based on level
	var stat_sample_pos: float = float(level) / 100.0 - 0.01
	for _stat in all_stats.keys():
		all_stats[_stat].recalculate(stat_sample_pos)
	
	# Apply buffs
	for stat_name in stat_multiplier:
		all_stats[stat_name].value *= stat_multiplier[stat_name]
		print(stat_name, " multiplied by: ", stat_multiplier[stat_name])
	for stat_name in stat_addends:
		all_stats[stat_name].value += stat_addends[stat_name]

# ==============
# HANDLING BUFFS
# ==============

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

# =============
# STAT HANDLING
# =============

func get_stat(_stat: Utils.stat_names) -> float:
	if all_stats.has(_stat):
		return all_stats[_stat].get_value()
	else:
		#print(Utils.stat_names.keys()[_stat])
		return -4
func set_stat(_stat: Utils.stat_names, _value: float):
	if all_stats.has(_stat):
		all_stats[_stat].set_value(_value)
	else:
		push_error("Trying to SET %s, wihtout it being present" % Utils.stat_names.keys()[_stat])
