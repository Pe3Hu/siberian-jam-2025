@tool
class_name BirdRichTextEffect
extends RichTextEffect


var bbcode = "bird"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var vertical_size = char_fx.env.get("vertical_size", 3.0)
	var pivot_index = char_fx.env.get("index", 0)
	var freq = char_fx.env.get("freq", 1.0)
	
	char_fx.offset.y += (vertical_size * 
	abs(pivot_index - char_fx.relative_index)) *\
	(sin(char_fx.elapsed_time * freq) * 2 ) 
	return true
