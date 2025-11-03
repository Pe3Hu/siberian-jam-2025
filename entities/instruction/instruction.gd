@tool
class_name Instruction
extends PanelContainer


@export_enum("человек", "животное") var type: String = "человек":
	set(value_):
		type = value_
		update_textures()

@export var gap: int = 175:
	set(value_):
		gap = value_
		
		if backjack_fact != null:
			backjack_fact.add_theme_constant_override("separation", gap)
			backjack_mystery.add_theme_constant_override("separation", gap)
			flash_fact.add_theme_constant_override("separation", gap)
			flash_mystery.add_theme_constant_override("separation", gap)
			street_fact.add_theme_constant_override("separation", gap)
			street_mystery.add_theme_constant_override("separation", gap)

@onready var backjack_fact = %BlackjackFact
@onready var backjack_mystery = %BlackjackMystery
@onready var flash_fact = %FlashFact
@onready var flash_mystery = %FlashFactMystery
@onready var street_fact = %StreetFact
@onready var street_mystery = %StreetFactMystery


func _ready() -> void:
	update_textures()
	
func update_textures() -> void:
	if flash_fact == null: return
	%Flash.visible = true
	
	flash_fact.visible = Achievements.is_flash
	flash_mystery.visible = !Achievements.is_flash
	%Blackjack.visible = false
	%Street.visible = false
	
	match type:
		"человек":
			%Blackjack.visible = true
			backjack_fact.visible = Achievements.is_blackjack
			backjack_mystery.visible = !Achievements.is_blackjack
		"животное":
			%Street.visible = true
			street_fact.visible = Achievements.is_street
			street_mystery.visible = !Achievements.is_street
