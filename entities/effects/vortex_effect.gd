@tool
class_name VortexRichTextEffect
extends RichTextEffect


var bbcode = "vortex"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq = char_fx.env.get("freq", 1.0)
	#var radius = char_fx.env.get("freq", 10.0)
	#var center = char_fx.env.get("center", 1.0)
	#var size = char_fx.env.get("size", 1.0) #(size - char_fx.relative_index) * 2
	#char_fx.offset.x =  cos(char_fx.elapsed_time * freq + char_fx.relative_index * off) * radius
	#char_fx.offset.y =  cos(char_fx.elapsed_time * freq + char_fx.relative_index * off) * radius 
	#char_fx.offset.x =  cos(char_fx.elapsed_time * freq  ) * radius * abs(center - char_fx.relative_index)
	#char_fx.offset.y =  sin(char_fx.elapsed_time * freq  ) * radius * abs(center - char_fx.relative_index)
	char_fx.transform = char_fx.transform.rotated((char_fx.elapsed_time + pow(char_fx.relative_index, 1.2)) * freq) * 1.5
	return true
