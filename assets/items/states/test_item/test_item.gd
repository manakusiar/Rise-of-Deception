extends BaseItem
class_name TestItem

var buff: StatBuff

func on_create() -> void:
	if entity is Entity and entity.stats:
		buff = StatBuff.new(
			Utils.stat_names.WALK_ACCELERATION,
			2.0,
			StatBuff.BuffType.MULTIPLY
		)
		entity.stats.add_buff(buff)
		print(entity.stats.stat_buffs)

func on_destroy() -> void:
	if entity is Entity and entity.stats:
		entity.stats.add_buff(buff)
