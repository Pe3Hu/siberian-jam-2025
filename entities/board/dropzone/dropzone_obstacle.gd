extends CardDropzone


@export var instruction: Instruction


func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	add_card_obstacle(true)
	
func can_drop_card(card_ui : CardUI):
	return card_ui.obstacle_resource != null
	
func add_card_obstacle(is_same_: = false) -> void:
	var rank = Settings.ranks[Settings.current_obstacle_index]
	var nice_name = str(rank) + " of Diamonds"
	var card_data = card_pile_ui._get_card_data_by_nice_name(nice_name)
	var card_obstacle = card_pile_ui._create_obstacle_card_ui(card_data)
	card_obstacle.visible = false
	add_card(card_obstacle)
	var wall = load("res://entities/deck/wall/все.tres")
	
	if is_same_:
		card_obstacle.set_obstacle_resource(wall.obstacles[Settings.last_obstacle_index])
	else:
		var options = wall.obstacles.filter(func (a): return !Achievements.visited_locks.has(a))
		card_obstacle.set_obstacle_resource(options.pick_random())
		
	await get_tree().create_timer(0.15).timeout
	card_obstacle.visible = true
	instruction.type = card_obstacle.obstacle_resource.type
