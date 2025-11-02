extends CardDropzone


@export var card_obstacle_scene : PackedScene


func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	add_card_obstacle()
	
func can_drop_card(card_ui : CardUI):
	return card_ui.obstacle_resource != null
	
func add_card_obstacle() -> void:
	var rank = Settings.ranks[Settings.current_obstacle_index + 1]
	var nice_name = str(rank) + " of Diamonds"
	var card_data = card_pile_ui._get_card_data_by_nice_name(nice_name)
	var card_obstacle = card_pile_ui._create_obstacle_card_ui(card_data)
	card_obstacle.visible = false
	add_card(card_obstacle)
	var wall = load("res://entities/deck/wall/все.tres")
	card_obstacle.set_obstacle_resource(wall.obstacles[0])
	await get_tree().create_timer(0.15).timeout
	card_obstacle.visible = true
