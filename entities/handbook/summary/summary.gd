class_name Summary
extends PanelContainer


@export_enum("малыш", "кошка", "шут", "кукушка", "коршун", "петушок", "мышь", "шиншила", "шаман", "швея", "волшебница", "мушкетер", "мошенник", "девушка", "хищник") var title: String = "":
	set(value_):
		title = value_
		init_labels()

var obstacle_resource: ObstacleResource
var riddles: Dictionary
var is_visited: bool = true#false

@onready var output_label = %OutputLabel
@onready var input_label  = %InputLabel
@onready var ignore_label = %IgnoreLabel


func  _ready() -> void:
	update_labels()
	
func init_labels() -> void:
	obstacle_resource = load("res://entities/card/resources/obstacle/{title}.tres".format({"title": title}))

	riddles.input = []
	for input_key in obstacle_resource.lock.input_keys:
		riddles.input.append(input_key.title)
	
	riddles.output = []
	for output_key in obstacle_resource.lock.output_keys:
		riddles.output.append(output_key.title)
	
	riddles.ignore = []
	for ignore_key in obstacle_resource.lock.ignore_keys:
		riddles.ignore.append(ignore_key.title)
	
	for key_resource in Achievements.key_input_lock:
		if Achievements.key_input_lock[key_resource].has(obstacle_resource.lock):
			riddles.input.erase(key_resource.title)
	
	for key_resource in Achievements.key_output_lock:
		if Achievements.key_output_lock[key_resource].has(obstacle_resource.lock):
			riddles.output.erase(key_resource.title)
	
	for key_resource in Achievements.key_ignore_lock:
		if Achievements.key_ignore_lock[key_resource].has(obstacle_resource.lock):
			riddles.ignore.erase(key_resource.title)
	
func update_labels() -> void:
	var mystery = "???"
	
	for key in riddles.keys():
		var text = ""
		var facts = obstacle_resource.lock.get(key + "_keys")
		facts = facts.filter(func (a): return !riddles[key].has(a.title))
		var parts = []
		for fact in facts:
			parts.append(fact.title)
		for _i in riddles[key].size():
			parts.append(mystery)
		
		for part in parts:
			text += str("[p]",part,"[/p]")
		
		var label_path = "%" + key.capitalize() + "Label"
		var label = get_node(label_path)
		label.text = text
		var panel_path = "%" + key.capitalize()
		var panel = get_node(panel_path)
		panel.custom_minimum_size.y = parts.size() * 22
		panel.size = panel.custom_minimum_size
