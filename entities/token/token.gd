class_name Token
extends TextureRect


@export_enum("level", "action", "damage", "credit", "health", "armor", "sacrifice") var core: String:
	set(value_):
		core = value_
		texture = load("res://entities/token/images/core/" + core + ".png")
@export_enum("council", "viren", "silver", "junker") var faction: String:
	set(value_):
		faction = value_
		visible = faction != ""
		if faction != "":
			texture = load("res://entities/token/images/faction/" + faction + ".png")
@export var value_int: int = -1:
	set(value_):
		value_int = value_
		%ValueLabel.visible = value_int != -1
		%ValueLabel.text = str(value_)
@export_enum("default", "level", "conspire", "unite", "wounded", "focus", "bargain", "modification", "backstab") var condition: String = "default":
	set(value_):
		condition = value_
		%ConditionLabel.visible = condition != "default"
		%ConditionLabel.text = condition
		
