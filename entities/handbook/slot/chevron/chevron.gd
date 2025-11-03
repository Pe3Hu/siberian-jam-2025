class_name Chevron
extends PanelContainer


@export_enum("epiphany", "ignore", "input", "output") var type: String:
	set(value_):
		type = value_
		
		%TextureRect.texture = load("res://entities/handbook/slot/chevron/images/{text}.png".format({"text": type}))
		init_colors()

var angle: float = 90
var shader_color_start: Color
var shader_color_end: Color


func init_colors() -> void:
	var max_h = 360.0
	var h_start = 0.0
	var h_end = 0.0
	var s_start = 1.0
	var s_end = 0.6
	var v_start = 0.6
	var v_end = 1.0
	
	match type:
		"epiphany":
			h_start = 200.0
			h_end = 220.0
			angle = 0.0
		"input":
			h_start = 100.0
			h_end = 120.0
			angle = -60.0
		"output":
			h_start = 50.0
			h_end = 70.0
			angle = -100.0
		"ignore":
			h_start = 340.0
			h_end = 0.0
			angle = 150.0
	
	shader_color_start = Color.from_hsv(h_start / max_h, s_start, v_start)
	shader_color_end = Color.from_hsv(h_end / max_h, s_end, v_end)
	
	%TextureRect.material = ShaderMaterial.new()
	%TextureRect.material.shader = load("res://entities/handbook/slot/chevron/gradient.gdshader")
	%TextureRect.material.set_shader_parameter("color_start", shader_color_start)
	%TextureRect.material.set_shader_parameter("color_end", shader_color_end)
	%TextureRect.material.set_shader_parameter("angle", angle)
