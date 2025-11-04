#@tool
class_name World
extends Node


@onready var board = %Board
@onready var menu = %Menu
@onready var end_game = %EndGame
@onready var final_card = %FinalCard
@onready var maze = %Maze


func _ready() -> void:
	swich_menu()
	
	if Settings.on_test:
		_on_start_button_pressed()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if board.is_started:
			swich_menu()
	
func swich_menu() -> void:
	menu.visible = !menu.visible
	board.visible = !menu.visible
	
	#if menu.visible:
		#Engine.time_scale = 0
	#else:
		#Engine.time_scale = 1
	
func _on_exit_button_pressed() -> void:
	start_new_game()
	#get_tree().quit()
	
func _on_start_button_pressed() -> void:
	if board.is_restart:
		board.is_restart = false
		start_new_game()
	else:
		swich_menu()
		board.start()
	
func show_end_game() -> void:
	Settings.current_obstacle_index -= 1
	if Settings.current_obstacle_index == Settings.MAX_OBSTACLE_INDEX:
		Settings.current_obstacle_index -= 1
	
	var rank = Settings.ranks[Settings.current_obstacle_index]
	var path = "diamonds_"
	
	if Settings.current_obstacle_index < 10:
		path += "0"
	if Settings.current_obstacle_index > 9:
		rank = rank[0]
	
	path += str(rank)
	
	final_card.texture = load("res://entities/card/images/card_{path}.png".format({"path": path}))
	swich_menu()
	end_game.visible = true
	%MenuButtons.visible = false
	%EndButtons.visible = true
	
func _on_menu_button_pressed() -> void:
	close_end_game()
	
func _on_again_button_pressed() -> void:
	start_new_game()
	
func start_new_game() -> void:
	close_end_game()
	swich_menu()
	board.reset()
	maze.reset()
	
func close_end_game() -> void:
	if end_game.visible:
		board.is_restart = true
		%EndButtons.visible = false
		end_game.visible = false
		%MenuButtons.visible = true
	
func _physics_process(delta: float) -> void:
	final_card.rotation -= delta
	
func set_player_as_winner() -> void:
	show_end_game()
	
