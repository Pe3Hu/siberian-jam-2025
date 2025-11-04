class_name Board
extends Node2D


@export var world: World
@export var bank: Bank

@onready var handbook = $Handbook
@onready var instruction = $Instruction
@onready var card_pile_ui := $CardPileUI
@onready var dropzones := [
	%CardDropzone1,
	%CardDropzone2,
	%CardDropzone3,
]
@onready var all_dropzones := [
	%CardDropzone1,
	%CardDropzone2,
	%CardDropzone3,
	%CardDropzone_Discard,
	%CardDropzone_Obstacle
]
@onready var obstacle_dropzone : = %CardDropzone_Obstacle
@onready var assault_button : = %AssaultButton
@onready var reset_button : = %ResetButton
@onready var shake_timer : = %ShakeTimer

var combo_cards: Array[CardUI]
#var is_next_card_step: bool = false
var output_keys: Array[KeyResource]
var is_started: bool = false
var is_restart: bool = false
var shake_hit_effect: float = 0

var lock_show: bool = false


func _ready():
	randomize()
	#card_pile_ui.draw(Settings.HAND_DEFAULT)
	#sort_hand()
	
	#await get_tree().create_timer(0.45).timeout
	#next_obstacle()
	
func _on_sort_button_pressed():
	#if Settings.on_test:
		#local_victory()
		#return
	
	sort_hand()
	
	#next_obstacle()
	#world.show_end_game()
	#detect_lose_hand()
	
	
func sort_hand() -> void:
	card_pile_ui.sort_hand(func(a, b): 
		if a.card_data.suit == b.card_data.suit:
			return a.card_data.value < b.card_data.value
		else:
			return a.card_data.suit < b.card_data.suit
	)

func _on_reset_button_pressed():
	shake_timer.stop()
	reset_shake()
	return_active_cards()
	
func return_active_cards():
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		card_pile_ui.place_in_hand(card)
	
func _on_show_button_pressed() -> void:
	if lock_show: return
	switch_hanbook()
	world.maze.on_pause = false
	
func switch_hanbook() -> void:
	handbook.visible = !handbook.visible
	card_pile_ui.visible = !handbook.visible
	assault_button.visible = !handbook.visible
	instruction.visible = !handbook.visible
	%SortButton.visible = !handbook.visible
	%ResetButton.visible = !handbook.visible
	world.maze.visible = !handbook.visible
	bank.visible = !handbook.visible
	world.maze.on_pause = !handbook.visible
	
	for drop_zone in all_dropzones:
		drop_zone.visible = !handbook.visible
	
func _on_assault_button_pressed() -> void:
	shake_timer.stop()
	reset_shake()
	
	if card_pile_ui.obstacle_dropzone._held_cards.is_empty(): return
	var result = check_on_success()
	
	if result:
		discard_active_cards()
	else:
		result = check_on_combo()
		
		if result:
			discard_active_cards(true)
		else:
			return_active_cards()
	
	get_step_card()
	
	if result:
		local_victory()
	else:
		bank.short_pulse()
		apply_silence()
	
	#await get_tree().create_timer(Settings.HANDBOOK_SHOWTIME_DELAY).timeout
	pull_new_cards()
	
	#if card_pile_ui._hand_pile.size() < 2:
		#world.show_end_game()
	
func check_on_success() -> bool:
	var success = false
	var flag = check_on_flash()
	if flag:
		if !Achievements.is_flash:
			Achievements.is_flash = flag
			instruction.update_textures()
		
		#return true
	success = success or flag
	flag = check_on_street()
	if flag:
		if !Achievements.is_street:
			Achievements.is_street = flag
			instruction.update_textures()
		#return true
	success = success or flag
	flag = check_on_blackjack()
	if flag:
		if !Achievements.is_blackjack:
			Achievements.is_blackjack = flag
			instruction.update_textures()
		#return true
	success = success or flag
	
	return success
	
func check_3_card() -> bool:
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty():
			return false
	
	return true
	
func check_on_flash() -> bool:
	if !check_3_card(): return false
	var cards = []
	
	for dropzone in dropzones:
		cards.append(dropzone._held_cards.front())
	
	return cards[0].card_data.suit == cards[1].card_data.suit and cards[2].card_data.suit == cards[1].card_data.suit
	
func check_on_street() -> bool:
	if !check_3_card(): return false
	var sum = get_sum_active_card()
	
	for dropzone in dropzones:
		var card = dropzone._held_cards.front()
		if sum == card.card_data.value * 3:
			return true
	
	
	return false
	
func get_sum_active_card() -> int:
	var sum = 0
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		var value = min(card.card_data.value, 10)
		
		if card.card_data.value == 14:
			value += 1
		sum += value
	
	return sum
	
func check_on_blackjack() -> bool:
	if !check_3_card(): return false
	var sum = get_sum_active_card()
	return sum >= Settings.BLACKJACK_VALUE
	
func discard_active_cards(is_combo_: bool = false) -> void:
	var discarded_cards = []
	var returned_cards = []
	
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		discarded_cards.append(card)
	
	if is_combo_ and discarded_cards.size() > 2:
		returned_cards = discarded_cards.filter(func (a): return !combo_cards.has(a))
		
		if returned_cards.is_empty():
			discarded_cards.suffle()
			var discarded_card = discarded_cards.pop_back()
			returned_cards.append(discarded_card)
		else:
			discarded_cards = discarded_cards.filter(func (a): return !returned_cards.has(a))
	
	for card in discarded_cards:
		card_pile_ui.place_in_discard(card)
	
	for card in returned_cards:
		card_pile_ui.place_in_hand(card)
	
func detect_combo_in_hand() -> void:
	if shake_hit_effect > 0:
		reset_shake()
	
	shake_timer.start()
	combo_cards.clear()
	var key_options = get_current_obstacle_card().obstacle_resource.lock.input_keys
	
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		if key_options.has(card.key_resource):
			combo_cards.append(card)
	
	for card in card_pile_ui.get_hand_cards():
		if key_options.has(card.key_resource):
			combo_cards.append(card)
	
	if combo_cards.size() < 2: return
	
	for card in combo_cards:
		card.is_combo = true
	
func check_on_combo() -> bool:
	var inplay_combo_cards = []
	
	for dropzone in dropzones:
		if dropzone._held_cards.is_empty(): continue
		var card = dropzone._held_cards.front()
		if combo_cards.has(card):
			inplay_combo_cards.append(card)
	
	return inplay_combo_cards.size() > 1
	
func local_victory() -> void:
	for combo_card in combo_cards:
		combo_card.is_combo = false
		combo_card.apply_bbcode()
	
	apply_silence()
	
	get_trophy()
	world.maze.current_gatekeeper.die()
	after_obstacle()
	
func apply_silence() -> void:
	for card in card_pile_ui._hand_pile:
		if card.key_resource.suit == "звук":
			bank.update_token(card.key_resource.suit, -1)
	
func get_trophy() -> void:
	var obstacle_card = get_current_obstacle_card()
	output_keys.append_array(obstacle_card.obstacle_resource.lock.output_keys)
	
func pull_new_cards() -> void:
	card_pile_ui.draw(output_keys.size())
	output_keys.clear()
	
func next_obstacle() -> void:
	Settings.current_obstacle_index += 1
	var card = get_current_obstacle_card()
	handbook.update_last_combo_input_keys()
	handbook.update()
	
	if handbook.has_new_words:
		switch_hanbook()
		await get_tree().create_timer(Settings.HANDBOOK_SHOWTIME_DELAY).timeout
		
		card_pile_ui.remove_card_from_game(card)
		card_pile_ui.obstacle_dropzone.add_card_obstacle()
		
		if handbook.visible:
			switch_hanbook()
	else:
		card_pile_ui.remove_card_from_game(card)
		card_pile_ui.obstacle_dropzone.add_card_obstacle()
	
	handbook.has_new_words = false
	
func after_obstacle() -> void:
	Settings.current_obstacle_index += 1
	var card = get_current_obstacle_card()
	handbook.update_last_combo_input_keys()
	handbook.update()
	lock_show = true
	
	if handbook.has_new_words:
		switch_hanbook()
		await get_tree().create_timer(Settings.HANDBOOK_SHOWTIME_DELAY).timeout
		
		card_pile_ui.remove_card_from_game(card)
		
		if handbook.visible:
			switch_hanbook()
	else:
		card_pile_ui.remove_card_from_game(card)
	
	handbook.has_new_words = false
	world.maze.after_lock_victory()
	lock_show = false
	
func get_step_card() -> void:
	var step_key = load("res://entities/card/resources/key/key_40.tres")
	output_keys.append(step_key)
	#card_pile_ui.draw(1)
	#output_keys.erase(step_key)
	
func get_current_obstacle_card() -> ObstacleCardUI:
	return card_pile_ui.obstacle_dropzone._held_cards.front()
	
func start() -> void:
	if !is_started:
		card_pile_ui.draw(Settings.HAND_DEFAULT)
		#card_pile_ui.obstacle_dropzone.add_card_obstacle()
		is_started = true
	
func reset() -> void:
	is_started = false
	card_pile_ui.end_game_reset()
	bank.reset()
	Settings.reset()
	shake_timer.stop()
	reset_shake()
	start()
	
func _on_shake_timer_timeout() -> void:
	shake_hit_effect += Settings.SHAKE_HIT_SHIFT
	
	if shake_hit_effect < 1.0:
		shake_timer.start()
		var current_hit_effect = reset_button.material.get_shader_parameter("hit_effect")
		current_hit_effect += randf_range(Settings.SHAKE_HIT_SHIFT / 2, Settings.SHAKE_HIT_SHIFT)
		assault_button.material.set_shader_parameter("hit_effect", current_hit_effect)
		current_hit_effect = reset_button.material.get_shader_parameter("hit_effect")
		current_hit_effect += randf_range(Settings.SHAKE_HIT_SHIFT / 4, Settings.SHAKE_HIT_SHIFT / 2)
		reset_button.material.set_shader_parameter("hit_effect", current_hit_effect)
	else:
		reset_shake()
		return_active_cards()
	
func reset_shake() -> void:
	shake_hit_effect = 0.0
	shake_timer.stop()
	assault_button.material.set_shader_parameter("hit_effect", 0)
	reset_button.material.set_shader_parameter("hit_effect", 0)
	
func detect_lose_hand() -> void:
	return_active_cards()
	if card_pile_ui._draw_pile.size() > 0: return
	if card_pile_ui._hand_pile.size() >= 7: return
	
	var result = check_flash_in_hand()
	if result: return
	
	result = check_street_in_hand()
	if result: return
	
	result = check_blackjack_in_hand()
	if result: return
	
	detect_combo_in_hand()
	result = combo_cards.size() >= 2
	if result: return
	
	world.show_end_game()
	
func check_flash_in_hand() -> bool:
	if card_pile_ui._hand_pile.size() < 3: return false
	var suits = {}
	
	for card in card_pile_ui._hand_pile:
		if !suits.has(card.card_data.suit):
			suits[card.card_data.suit] = 0
		
		suits[card.card_data.suit] += 1
	
	for suit in suits:
		if suits[suit] >= 3:
			return true
	
	return false
	
func check_street_in_hand() -> bool:
	if get_current_obstacle_card().obstacle_resource.type == "человек": return false
	if card_pile_ui._hand_pile.size() < 3: return false
	var values = []
	
	for card in card_pile_ui._hand_pile:
		var value = str(int(card.card_data.value))
		if !values.has(value):
			values.append(value)
	
	var pairs = []
	
	for _i in range(values.size()-1,-1,-1):
		if values.size() == _i:
			_i -= 1
		else:
			var value_a = values[_i]
			var index_a = Settings.values.find(value_a)
			
			for _j in range(_i-1,-1,-1):
				var value_b = values[_j]
				var index_b = Settings.values.find(value_b)
				
				if abs(index_a - index_b) == 1:
					var pair = [value_a, value_b]
					pairs.append(pair)
					values.erase(value_a)
					values.erase(value_b)
					break
	
	for pair in pairs:
		pair.sort()
		
	for _i in pairs.size():
		var pair_a = pairs[_i]
		for _j in range(_i+1,pairs.size(),1):
			var pair_b = pairs[_j]
			var index_shift = abs(Settings.values.find(pair_a.front())-Settings.values.find(pair_b.back()))
			if index_shift == 1: return true
			index_shift = abs(Settings.values.find(pair_a.back())-Settings.values.find(pair_b.front()))
			if index_shift == 1: return true
		
		for value in values:
			var index_shift = abs(Settings.values.find(pair_a.front())-Settings.values.find(value))
			if index_shift == 1: return true
			index_shift = abs(Settings.values.find(pair_a.back())-Settings.values.find(value))
			if index_shift == 1: return true
			
	return false
	
func check_blackjack_in_hand() -> bool:
	if get_current_obstacle_card().obstacle_resource.type == "животное": return false
	if card_pile_ui._hand_pile.size() < 3: return false
	var values = []
	
	for card in card_pile_ui._hand_pile:
		var value = card.card_data.value
		values.append(value)
	
	values.sort_custom(func(a, b): return a > b)
	return values[0] + values[1] + values[2] >= Settings.BLACKJACK_VALUE
 	
func update_gatekeeper() -> void:
	card_pile_ui.obstacle_dropzone.add_card_obstacle()
