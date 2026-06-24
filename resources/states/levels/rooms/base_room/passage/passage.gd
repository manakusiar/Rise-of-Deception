class_name RoomPassage
extends TileMapLayer

enum path_direction {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

@export var area: Area2D
@export var collision_shape: CollisionShape2D
@export var steal_tile_map: TileMapLayer
@export var direction: path_direction

@export var player_tp_position: Vector2
@export var player_tp_properties: Dictionary[StringName, Variant]
@export var player_tp_stats: Dictionary[Utils.stat_names, float]

var open: bool = false:
	set(value):
		open = value
		
		collision_shape.disabled = !open
		
		collision_enabled = !open
		#visible = !open

const path_direction_vector2i: Dictionary[RoomPassage.path_direction, Vector2i] = {
	RoomPassage.path_direction.LEFT: Vector2i(-1, 0),
	RoomPassage.path_direction.RIGHT: Vector2i(1, 0),
	RoomPassage.path_direction.TOP: Vector2i(0, 1),
	RoomPassage.path_direction.BOTTOM: Vector2i(0, -1),
}

const path_direction_opposites: Dictionary[RoomPassage.path_direction, RoomPassage.path_direction] = {
	RoomPassage.path_direction.LEFT: RoomPassage.path_direction.RIGHT,
	RoomPassage.path_direction.RIGHT: RoomPassage.path_direction.LEFT,
	RoomPassage.path_direction.TOP: RoomPassage.path_direction.BOTTOM,
	RoomPassage.path_direction.BOTTOM: RoomPassage.path_direction.TOP,
}

func _ready() -> void:
	area.body_entered.connect(_area_body_entered)
	
	Steal()

func Steal() -> void:
	tile_set = steal_tile_map.tile_set
	
	var _used_cells = get_used_cells()
	clear()
	
	var min_pos := Vector2.INF
	var max_pos := Vector2.ZERO
	
	for coords in _used_cells:
		var _tile_data = steal_tile_map.get_cell_tile_data(coords)
		if _tile_data:
			var _source_id = steal_tile_map.get_cell_source_id(coords)
			var _atlas_coords = steal_tile_map.get_cell_atlas_coords(coords)
			var _alt_tile = steal_tile_map.get_cell_alternative_tile(coords)
			
			steal_tile_map.erase_cell(coords)
			set_cell(coords, _source_id, _atlas_coords, _alt_tile)
			
			min_pos = to_global(map_to_local(coords).min(min_pos))
			max_pos = to_global(map_to_local(coords).max(max_pos))
	
	if min_pos != Vector2.INF:
		collision_shape.position = (min_pos + max_pos) / 2
		collision_shape.scale = abs(max_pos - min_pos) / collision_shape.shape.size + Vector2(0.5, 1)
		collision_shape.visible = true

func Setup(_open: bool) -> void:
	open = _open

func _area_body_entered(body) -> void:
	#print("BODY ", body.name, " entered door ", direction)
	if body is Player:
		print("Player ", body.name, " entered door ", path_direction.keys()[direction])
		SignalBus.passage_player_entered.emit(self, body)
