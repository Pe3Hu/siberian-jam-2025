extends Node2D


@onready var card_pile_ui := $CardPileUI
@onready var dropzones := [
	$CardDropzone1,
	$CardDropzone2,
	$CardDropzone3,
]


func _ready():
	randomize()
	#card_pile_ui.draw(Settings.HAND_DEFAULT)
	#sort_hand()

func _get_rand_joker():
	return "Black Joker" if randi_range(0, 1) else "Red Joker"

func _on_draw_button_pressed():
	card_pile_ui.draw(1)

func _on_draw_3_button_pressed():
	card_pile_ui.draw(3)

func _on_sort_button_pressed():
	sort_hand()
	
func sort_hand() -> void:
	card_pile_ui.sort_hand(func(a, b): 
		if a.card_data.suit == b.card_data.suit:
			return a.card_data.value < b.card_data.value
		else:
			return a.card_data.suit < b.card_data.suit
	)

func _on_reset_button_pressed():
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		card_pile_ui.place_in_hand(card)

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
	
