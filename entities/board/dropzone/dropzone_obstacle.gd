extends CardDropzone


@export var card_obstacle_scene : PackedScene


func _ready() -> void:
	#await get_tree().create_timer(0.5).timeout
	#add_card_obstacle()
	pass


func can_drop_card(card_ui : CardUI):
	return card_ui.obstacle_resource != null
	
func add_card_obstacle() -> void:
	var card_obstacle = card_obstacle_scene.instantiate()
	var wall = load("res://entities/deck/wall/все.tres")
	card_obstacle.obstacle_resource = wall.obstacles[0]
	add_card(card_obstacle)
