extends CardUI


var key_resource: KeyResource

@onready var title_label := %TitleLabel


func _ready():
	super()
	
func roll_key_resource() -> void:
	var stock_path = "запас "
	
	match card_data.suit:
		"H":
			stock_path += "звук"
		"D":
			stock_path += "аромат"
		"S":
			stock_path += "прикосновение"
	
	var stock = load("res://entities/deck/stock/" + stock_path + ".tres")
	generate_key(stock)
	title_label.text = key_resource.title
	
func generate_key(stock_: StockResource) -> void:
	var options = stock_.keys.filter(func (a): return !Settings.key_exceptions.has(a))
	key_resource = options.pick_random()
	
	if !Settings.key_in_hand.has(key_resource):
		Settings.key_in_hand[key_resource] = 0
	
	Settings.key_in_hand[key_resource] += 1
	
	if Settings.key_in_hand[key_resource] == Settings.KEY_IN_HAND_LIMIT:
		Settings.key_exceptions.append(key_resource)
