extends CardDropzone


func can_drop_card(_card_ui : CardUI):
	return _held_cards.is_empty()
