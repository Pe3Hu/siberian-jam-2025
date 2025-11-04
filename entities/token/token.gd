class_name Token
extends TextureRect


@export var value_int: int = -1:
	set(value_):
		value_int = value_
		%ValueLabel.visible = value_int != -1
		%ValueLabel.text = str(value_)
@export_enum("тишина") var type: String = "тишина":
	set(value_):
		type = value_
		%ConditionLabel.text = type
