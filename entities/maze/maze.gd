class_name Maze
extends Node2D


@export var gatekeeper_scene: PackedScene
@export var godray_scene: PackedScene
@export var world: World

@onready var tile_map_layer_maze = %TileMapLayerMaze
@onready var tile_map_layer_ladder = %TileMapLayerLadder
@onready var robber = %Robber
@onready var gatekeepers = %Gatekeepers
@onready var godrays = %Godrays


var gatekeepers_skulls: int = 0

var start_coord: Vector2i
var borderland_coords: Array[Vector2i]
var coord_to_neighbours: Dictionary
var occupied_coords: Array[Vector2i]
var expelled_coords: Array[Vector2i]

var highlighted_gatekeepers: Array[Gatekeeper]
var coord_to_gatekeepers: Dictionary
var obstacle_options: Array

var is_first_level: bool = true
var on_pause: bool = false
var on_focus: bool = false
var on_exit: bool = false

var is_broken_reset: bool = false

var current_gatekeeper: Gatekeeper
var borderland_gatekeepers: Array[Gatekeeper]

var ladder_coords: Array[Vector2i]


func reset() -> void:
	on_pause = false
	on_focus = false
	on_exit = false
	borderland_coords.clear()
	occupied_coords.clear()
	expelled_coords.clear()
	
	highlighted_gatekeepers.clear()
	coord_to_gatekeepers.clear()
	
	coord_to_gatekeepers = {}
	
	reset_tiles()
	init_gatekeepers()
	init_highlighted_gatekeepers()
	
	if is_broken_reset:
		is_broken_reset = false
		reset()
	
func reset_gatekeepers() -> void:
	while gatekeepers.get_child_count() > 0:
		var gatekeeper = gatekeepers.get_child(0)
		gatekeepers.remove_child(gatekeeper)
		gatekeeper.queue_free()
	
	while godrays.get_child_count() > 0:
		var godray = godrays.get_child(0)
		godrays.remove_child(godray)
		godray.queue_free()
	
func _ready() -> void:
	#await get_tree().create_timer(0.5).timeout
	init_coord_to_neighbours()
	reset_tiles()
	init_gatekeepers()
	init_highlighted_gatekeepers()
	
func init_coord_to_neighbours() -> void:
	for _i in Settings.LOCK_AXIS.y:
		for _j in Settings.LOCK_AXIS.x:
			var coord = Vector2i(_i * Settings.NEIGHBOUR_STEP + 1, _j * Settings.NEIGHBOUR_STEP + 1)
			coord_to_neighbours[coord] = []
	
	for coord in coord_to_neighbours:
		for direction in Settings.DIRECTIONS:
			var neighbour_coord = coord + direction * Settings.NEIGHBOUR_STEP
			if coord_to_neighbours.has(neighbour_coord):
				coord_to_neighbours[coord].append(neighbour_coord)
	
func reset_tiles() -> void:
	gatekeepers_skulls = 0
	borderland_coords.clear()
	occupied_coords.clear()
	reset_ladder()
	reset_locks()
	init_start_coord()
	init_expelled_coords()

func reset_ladder() -> void:
	for ladder_coord in ladder_coords:
		tile_map_layer_ladder.set_cell(ladder_coord, 0, Vector2i(-1, -1))
	
	ladder_coords.clear()
	
func reset_locks() -> void:
	for coord in coord_to_neighbours:
		set_tile_as_lock(coord)
	
func init_start_coord() -> void:
	start_coord = Settings.start_coords.pick_random()
	update_borderland_coords(start_coord)
	
	set_tile_as_floor(start_coord)
	set_tile_as_ladder(start_coord)
	robber.position = start_coord * Settings.TILE_SIZE
	robber.position += Settings.TILE_SIZE * 0.5
	#robber.exit_position = robber.position
	robber.exit_position = to_global(tile_map_layer_maze.map_to_local(start_coord))
	
func update_borderland_coords(coord_: Vector2i) -> void:
	borderland_coords.erase(coord_)
	occupied_coords.append(coord_)
	borderland_coords.append_array(coord_to_neighbours[coord_])
	borderland_coords = borderland_coords.filter(func (a): return !occupied_coords.has(a))
	borderland_coords = borderland_coords.filter(func (a): return !expelled_coords.has(a))
	
func open_tile(position_: Vector2) -> void:
	var tile_coord = tile_map_layer_maze.local_to_map(position_)
	set_tile_as_floor(tile_coord)
	
func set_tile_as_floor(coord_: Vector2i) -> void:
	tile_map_layer_maze.set_cell(coord_, 1, Vector2i(3, 1))
	
func set_tile_as_lock(coord_: Vector2i) -> void:
	tile_map_layer_maze.set_cell(coord_, 1, Vector2i(0, 0))
	
func set_tile_as_wall(coord_: Vector2i) -> void:
	tile_map_layer_maze.set_cell(coord_, 1, Vector2i(8, 3))
	
func set_tile_as_ladder(coord_: Vector2i) -> void:#33 35
	tile_map_layer_ladder.set_cell(coord_, 0, Vector2i(3, 5))
	var next_coord = Vector2i(coord_.x, coord_.y -1)
	tile_map_layer_ladder.set_cell(next_coord, 0, Vector2i(3, 3))
	#tile_map_layer_ladder.set_cell(Vector2i(coord_.x, coord_.y -2), 0, Vector2i(3, 3))
	ladder_coords.append(coord_)
	ladder_coords.append(next_coord)
	
func init_expelled_coords() -> void:
	expelled_coords.clear()
	
	if is_first_level:
		var options = coord_to_neighbours[start_coord]
		var expelled_coord = options.pick_random()
		expelled_coords.append(expelled_coord)
		options.erase(expelled_coord)
		
		if options.is_empty():
			init_coord_to_neighbours()
			_ready()
			return
		
		var free_direction = options.front() - start_coord
		expelled_coord += free_direction
		expelled_coords.append(expelled_coord)
	else:
		var options = coord_to_neighbours.keys()
		options.shuffle()
		var expelled_coord = options.pop_back()
		expelled_coords.append(expelled_coord)
		expelled_coord = options.pop_back()
		expelled_coords.append(expelled_coord)
	
func init_gatekeepers() -> void:
	reset_gatekeepers()
	obstacle_options.clear()
	var wall = load("res://entities/deck/wall/все.tres")
	obstacle_options.append_array(wall.obstacles)
	obstacle_options.shuffle()
	highlighted_gatekeepers.clear()
	coord_to_gatekeepers = {}
	
	for _i in Settings.MAX_OBSTACLE_INDEX:#Settings.MAX_OBSTACLE_INDEX:
		add_gatekeeper()
	
	if Settings.MAX_OBSTACLE_INDEX != gatekeepers.get_child_count():
		is_broken_reset = true
		return
	#print([Settings.VICTORY_SKULL, gatekeepers.get_child_count()])
	fill_expelled_coords_as_wall()
	
func broken_reset() -> void:
	reset()
	
func add_gatekeeper() -> void:
	if borderland_coords.is_empty(): return
	var gatekeeper_coord = borderland_coords.pick_random()
	update_borderland_coords(gatekeeper_coord)
	var gatekeeper = gatekeeper_scene.instantiate()
	gatekeeper.maze = self
	gatekeeper.coord = gatekeeper_coord
	gatekeeper.obstacle_resource = obstacle_options.pop_back()
	gatekeepers.add_child(gatekeeper)
	gatekeeper.position = gatekeeper_coord * Settings.TILE_SIZE
	gatekeeper.position += Settings.TILE_SIZE * 0.5
	coord_to_gatekeepers[gatekeeper_coord] = gatekeeper
	
func fill_expelled_coords_as_wall() -> void:
	for coord in expelled_coords:
		set_tile_as_wall(coord)
	
func init_highlighted_gatekeepers() -> void:
	if is_broken_reset: return
	if gatekeepers_skulls == 0:
		update_borderland_gatekeepers(start_coord)
		
		#var godray_coord = occupied_coords[1]
		#var gatekeeper = coord_to_gatekeepers[godray_coord]
		#add_godray(gatekeeper)
		
		pick_pack_gatekeepers_for_godray()
	else:
		pick_pack_gatekeepers_for_godray(2)
	
func pick_pack_gatekeepers_for_godray(count_fact_: int = 0, count_mystery_: int = 1) -> void:
	borderland_gatekeepers.shuffle()
	
	for _i in count_fact_:
		pick_gatekeeper_for_godray(true)
	
	for _i in count_mystery_:
		pick_gatekeeper_for_godray()
	
func pick_gatekeeper_for_godray(is_fact_: bool  = false) -> void:
	borderland_gatekeepers = borderland_gatekeepers.filter(func (a): return a != null)
	if borderland_gatekeepers.is_empty(): return
	var gatekeeper = borderland_gatekeepers.pick_random()
	add_godray(gatekeeper, is_fact_)
	update_borderland_gatekeepers(gatekeeper.coord)
	
func update_borderland_gatekeepers(coord_: Vector2i) -> void:
	for neighbour_coord in coord_to_neighbours[coord_]:
		if coord_to_gatekeepers.has(neighbour_coord):
			var gatekeeper = coord_to_gatekeepers[neighbour_coord]
			borderland_gatekeepers.append(gatekeeper)
	
	if borderland_gatekeepers.is_empty(): return
	borderland_gatekeepers = borderland_gatekeepers.filter(func(a): return a != null)
	borderland_gatekeepers = borderland_gatekeepers.filter(func(a): return a.godray == null)
	
func add_godray(gatekeeper_: Gatekeeper, is_fact_: bool = false) -> void:
	var godray = godray_scene.instantiate()
	godray.maze = self
	godray.gatekeeper = gatekeeper_
	godray.is_fact = is_fact_
	gatekeeper_.godray = godray
	godrays.add_child(godray)
	borderland_gatekeepers.erase(gatekeeper_)
	
func after_lock_victory() -> void:
	init_highlighted_gatekeepers()
	current_gatekeeper = null
	on_pause = false
	
	if gatekeepers_skulls == Settings.VICTORY_SKULL:
		go_on_exit()
	
func _on_panel_container_mouse_entered() -> void:
	on_focus = true
	
func _on_panel_container_mouse_exited() -> void:
	on_focus = false
	
func go_on_exit() -> void:
	on_pause = false
	on_exit = true
	#var target_position = start_coord * Settings.TILE_SIZE
	#target_position = Vector2(target_position) + Settings.TILE_SIZE * 0.5
	robber.target_mouse_postion = robber.exit_position
	robber.current_state = robber.State.FOLLOW
	#print([robber.position, robber.exit_position])
	
func game_over() -> void:
	if is_first_level:
		is_first_level = false
	world.show_end_game()
