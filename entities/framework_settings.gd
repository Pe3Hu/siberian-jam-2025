extends Node


const ranks = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]

const KEY_IN_HAND_LIMIT: int = 2
const HAND_LIMIT: int = 10
const HAND_DEFAULT: int = 7
const TEXT_MAX_L: int = 20
const BLACKJACK_VALUE: int = 21

const MAX_OBSTACLE_INDEX: int = 13

var current_obstacle_index: int = 0
var last_obstacle_index: int = 4

var HANDBOOK_SHOWTIME_DELAY: float = 2.5#0.1#
var SHAKE_HIT_SHIFT: float = 0.08

var key_in_hand: Dictionary
var key_exceptions: Array[KeyResource]
var weight_to_obstacle: Dictionary


var temp_obstacle_titles: Array[String]


func _init() -> void:
	init_weight_to_obstacle()
	roll_last_obstacle_index()
	
func init_weight_to_obstacle() -> void:
	weight_to_obstacle["волшебница"] = 4
	weight_to_obstacle["девушка"] = 1
	weight_to_obstacle["коршун"] = 2
	weight_to_obstacle["кошка"] = 1
	weight_to_obstacle["кукушка"] = 7
	weight_to_obstacle["малыш"] = 1
	weight_to_obstacle["мошенник"] = 1
	weight_to_obstacle["мушкетер"] = 1
	weight_to_obstacle["мышь"] = 1
	weight_to_obstacle["петушок"] = 2
	weight_to_obstacle["хищник"] = 1
	weight_to_obstacle["шаман"] = 1
	weight_to_obstacle["швея"] = 1
	weight_to_obstacle["шиншила"] = 1
	weight_to_obstacle["шут"] = 1
	
func reset() -> void:
	current_obstacle_index = 0
	temp_obstacle_titles.clear()
	key_exceptions.clear()
	key_in_hand = {}
	roll_last_obstacle_index()
	
func roll_last_obstacle_index() -> void:
	var options = weight_to_obstacle.duplicate()
	
	for option in temp_obstacle_titles:
		options.erase(option)
	
	var obstacle_title = get_random_key(options)
	var obstacle_path = "res://entities/card/resources/obstacle/{text}.tres".format({"text": obstacle_title})
	var obstacle_resource = load(obstacle_path)
	var wall = load("res://entities/deck/wall/все.tres")
	last_obstacle_index = wall.obstacles.find(obstacle_resource)
	#last_obstacle_index = 7

func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
