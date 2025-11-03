class_name Handbook
extends PanelContainer


@export var board: Board
var last_combo_input_keys: Array[KeyResource]
var last_obstacle: ObstacleResource

@onready var certificates = [
	%Certificate2,
	%Certificate3,
	%Certificate4,
	%Certificate5,
	%Certificate6,
	%Certificate7,
	%Certificate8,
	%Certificate9,
	%Certificate10,
	%Certificate11,
	%Certificate12,
	%Certificate13,
	%Certificate14,
	%Certificate15,
]

var has_new_words: bool = false


func update() -> void:
	first_meet()
	
func first_meet() -> void:
	if Achievements.visited_locks.has(last_obstacle): return
	has_new_words = true
	
	var certificate = get_certificate(last_obstacle)
	certificate.is_visited = true
	certificate.add_new_word(last_obstacle.title)
	Achievements.visited_locks.append(last_obstacle)
	
	for key_resource in last_obstacle.lock.output_keys:
		if !Achievements.key_output_lock.has(key_resource):
			Achievements.key_output_lock[key_resource] = []
		
		Achievements.key_output_lock[key_resource].append(last_obstacle.lock)
		certificate.add_new_word(key_resource.title)
	
	apply_new_combo()
	
	certificate.update_labels()
	
func get_certificate(obstacle_resource_: ObstacleResource) -> Variant:
	for certificate in certificates:
		if certificate.obstacle_resource == obstacle_resource_:
			return certificate
	
	return null
	
func update_last_combo_input_keys() -> void:
	last_obstacle = board.get_current_obstacle_card().obstacle_resource
	
	for card in board.combo_cards:
		if !last_combo_input_keys.has(card.key_resource):
			last_combo_input_keys.append(card.key_resource)
	
func apply_new_combo() -> void:
	var certificate = get_certificate(last_obstacle)
	
	for key_resource in last_combo_input_keys:
		if !Achievements.key_input_lock.has(key_resource):
			Achievements.key_input_lock[key_resource] = []
		
		Achievements.key_input_lock[key_resource].append(last_obstacle.lock)
		certificate.add_new_word(key_resource.title)
