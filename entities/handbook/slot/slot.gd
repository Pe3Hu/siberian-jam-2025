class_name Slot
extends TextureRect


@export_enum("title", "input", "output", "ignore") var type: String = "title"
@export var index: int = 1
@export var value: String = ""
@export var is_solved: bool = false:
	set(value_):
		is_solved = value_
		%FactLabel.visible = is_solved
		%FactLabel.visible = !is_solved
