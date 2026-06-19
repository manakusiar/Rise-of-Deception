class_name MapPassage
extends TileMapLayer

enum path_direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

@export var area: Area2D
@export var collision_shape: CollisionShape2D
@export var player_tp_point: Node2D
@export var steal_tile_map: TileMapLayer
@export var direction: path_direction

var open: bool = false

func _ready() -> void:
	area.body_entered.connect(_area_body_entered)
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
	
	collision_shape.position = (min_pos + max_pos) / 2
	collision_shape.scale = abs(max_pos - min_pos) / collision_shape.shape.size + Vector2.ONE
	collision_shape.visible = true
	

func Setup(_open: bool) -> void:
	open = _open
	
	collision_enabled = !open
	visible = !open

func _area_body_entered(body) -> void:
	if body is Player:
		print("Player ", body.name, " entered door ", name)
