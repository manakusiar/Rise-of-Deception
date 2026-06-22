class_name StatBuff
extends Resource

enum BuffType {
	MULTIPLY,
	ADD
}

@export var stat: Utils.stat_names
@export var buff_amount: float
@export var buff_type: BuffType

func _init(
		_stat: Utils.stat_names = Utils.stat_names.MAX_HEALTH, 
		_buff_amount: float = 1.0,
		_buff_type: StatBuff.BuffType = BuffType.MULTIPLY):
	
	stat = _stat
	buff_amount = _buff_amount
	buff_type = _buff_type
