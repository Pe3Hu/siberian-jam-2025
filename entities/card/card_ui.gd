extends CardUI


var key_resource: KeyResource

@onready var title_label := %TitleLabel
@export var is_combo: = false:
	set(value_):
		is_combo = value_
		apply_bbcode()


func _ready():
	super()
	
func roll_key_resource() -> void:
	if key_resource != null: return
	if !card_pile_ui.board.output_keys.is_empty():
		key_resource = card_pile_ui.board.output_keys[0]
		card_pile_ui.board.output_keys.erase(key_resource)
		apply_bbcode()
		return
	var stock_path = "запас "
	
	match card_data.suit:
		"H":
			stock_path += "звук"
			%SoundPanelContainer.visible = true
		"C":
			stock_path += "аромат"
		"S":
			stock_path += "прикосновение"
	
	var stock = load("res://entities/deck/stock/" + stock_path + ".tres")
	generate_key(stock)
	apply_bbcode()
	
func apply_bbcode() -> void:
	var bbcode_str = ""
	if !is_combo:
		bbcode_str = key_resource.title
		
		if Settings.plants.has(key_resource.title):
			bbcode_str = "[color=#008800]" + bbcode_str + "[/color]"
		
		title_label.text = bbcode_str
		return
	
	var part = ""
	var letters = ["щ","ш","м","т"]
	
	for letter in key_resource.title:
		if !letters.has(letter):
			part += letter
		else:
			bbcode_str += part
			part = ""
			
			bbcode_str += "[shake rate=20.0 level=5 connected=1]{text}[/shake]".format({"text": letter})
			#match key_resource.suit:
				#"прикосновение":
					#bbcode_str += "[shake rate=20.0 level=5 connected=1]{text}[/shake]".format({"text": letter})
				#"звук":
					#bbcode_str += "[tornado radius=2.0 freq=3.5 connected=1]{text}[/tornado]".format({"text": letter})
				#"аромат":
					#bbcode_str += "[wave amp=30.0 freq=3.5 connected=1]{text}[/wave]".format({"text": letter})
	
	bbcode_str += part
	
	if Settings.plants.has(key_resource.title):
		bbcode_str = "[color=dark_color]" + bbcode_str + "[/color]"
	
	title_label.text = bbcode_str#"[shake rate=20.0 level=5 connected=1]{title}[/shake]".format({"title": key_resource.title})
	
func generate_key(stock_: StockResource) -> void:
	var options = stock_.keys.filter(func (a): return !Settings.key_exceptions.has(a))
	key_resource = options.pick_random()
	
	if !Settings.key_in_hand.has(key_resource):
		Settings.key_in_hand[key_resource] = 0
	
	Settings.key_in_hand[key_resource] += 1
	
	if Settings.key_in_hand[key_resource] == Settings.KEY_IN_HAND_LIMIT:
		Settings.key_exceptions.append(key_resource)
