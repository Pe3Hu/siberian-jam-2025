extends CardDropzone


@export var board: Board


func can_drop_card(_card_ui : CardUI):
	return _held_cards.is_empty()
	
func add_card(card_ui):
	super.add_card(card_ui)
	board.detect_combo_in_hand()
