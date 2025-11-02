extends PanelContainer


@export_enum("малыш", "кошка", "шут", "кукушка", "коршун", "петушок", "мышь", "шиншила", "шаман", "швея", "волшебница", "мушкетер", "мошенник", "девушка", "хищник") var title: String = "":
	set(value_):
		title = value_
		init_labels()

var obstacle_resource: ObstacleResource
var riddles: Dictionary
var is_visited: bool = true#false

@onready var title_label: Label = %TitleLabel
@onready var output_label: Label = %OutputLabel
@onready var input_label: Label = %InputLabel
@onready var ignore_label: Label = %IgnoreLabel


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
	
	riddles.output = []
	riddles.input = []
	riddles.ignore = []
	
func update_labels() -> void:
	var mystery = "???"
	
	if is_visited:
		title_label.text = obstacle_resource.title
	else:
		title_label.text = mystery
	
	for key in riddles.keys():
		var text = ""
		var facts = obstacle_resource.lock.get(key + "_keys")
		facts = facts.filter(func (a): return !riddles[key].has(a.title))
		
		for fact in facts:
			text += fact.title + ","
		for _i in riddles[key].size():
			text += mystery + ","
		
		text = text.left(-1)
		var label_path = "%" + key.capitalize() + "Label"
		var label = get_node(label_path)
		label.text = text
