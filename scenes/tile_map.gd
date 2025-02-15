extends TileMap

enum layers {
	layer0 = 0,
	layer1 = 1,
	layer2 = 2,
}

const grass_floor_block_atlas_pos = Vector2i(0,0) # this is the position of the texture in the atlas
const barrier_block_atlas_pos = Vector2i(1,0)
const grass_wall_block_atlas_pos = Vector2i(2,0)
const main_source = 0 # this is the source of the texture, which png


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_gen_map()
	place_boundaries()


# For blocks, that have empty space next to them, place 
# invisible boundary that prevents leaving platform
# done with a invisible texture in the grass.png 
func place_boundaries() -> void:
	var offsets = [
		Vector2i(0,-1),
		Vector2i(0,1),
		Vector2i(1, 0),
		Vector2i(-1,0),
	]
	
	var used = get_used_cells(layers.layer0) # get_used_cells is a in built function, put the layer
	for spot in used:
		for offset in offsets:
			var current_spot = spot + offset
			# if this spot is empty, place the boundary
			if get_cell_source_id(layers.layer0, current_spot) == -1:
				set_cell(layers.layer0, current_spot, main_source, barrier_block_atlas_pos)
	
func test_gen_map() -> void:
	for y in range(12):
		for x in range(12):
			set_cell(layers.layer0, Vector2i(-12+x,-12+y),
			 main_source, grass_floor_block_atlas_pos)
	
	for x in range(5):		
		set_cell(layers.layer1, Vector2i(-5-x,-10),
				 main_source, grass_wall_block_atlas_pos)
		set_cell(layers.layer1, Vector2i(-10-x,-3),
				 main_source, grass_wall_block_atlas_pos)


@export var player: CharacterBody2D
var wall_layer = layers.layer1
var player_coords: Vector2i
var cells_alpha = {}
func _tile_data_runtime_update(layer, coords, tile_data):
	tile_data.modulate.a = cells_alpha.get(coords, 1.0)
	
#Warning: Make sure this function only return true when needed. 
#Any tile processed at runtime without a need for it will imply a significant performance penalty.
func _use_tile_data_runtime_update(layer, coords):
	return cells_alpha.has(coords)

func _process(delta):
	if player == null:
		return

	player_coords = local_to_map(player.global_position)
	var coords = get_used_cells(wall_layer)
	for coord in coords:
		# print("coord:{0}, player:{1}".format([coord.y, player_coords.y]))
		if (coord.y - player_coords.y >= -1) and (coord.y - player_coords.y <= 1) and (coord.x - player_coords.x >= -1) and (coord.x - player_coords.x <= 1):
			cells_alpha[coord] = 0.4
		else:
			cells_alpha[coord] = 1.0
		notify_runtime_tile_data_update(wall_layer)
	
	
