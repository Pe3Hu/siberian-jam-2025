@tool
class_name CatRichTextEffect
extends RichTextEffect


var bbcode = "cat"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var vertical_size = char_fx.env.get("vertical_size", 3.0)
	var pivot_index = char_fx.env.get("index", 0)
	var freq = char_fx.env.get("freq", 1.0)
	
	char_fx.offset.y += (vertical_size * 
	(vertical_size - abs(pivot_index - char_fx.relative_index))) *\
	(sin(char_fx.elapsed_time * freq) * 2 ) 
	
	char_fx.transform = char_fx.transform.translated(
		Vector2(0, char_fx.elapsed_time) * 10
	)
	return true
