extends TileMapLayer


@onready var obstacles_layer: TileMapLayer = $"../ObstaclesLayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Built-in function for TileMapLayer
func _use_tile_data_runtime_update(coords) -> bool:
	if coords in obstacles_layer.get_used_cells_by_id(0):
		# Identify any coordinates that are also used in ObstaclesLayer
		return true
	return false

# Built-in function for TileMapLayer
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in obstacles_layer.get_used_cells_by_id(0):
		# Remove navigation polygon from coordinates that are 
		# occupied by ANYTHING in ObstaclesLayer
		tile_data.set_navigation_polygon(0, null)
