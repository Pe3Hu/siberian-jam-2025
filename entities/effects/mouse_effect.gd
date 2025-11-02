@tool
class_name MouseRichTextEffect
extends RichTextEffect


var bbcode = "mouse"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq = char_fx.env.get("freq", 1.0)
	var amp = char_fx.env.get("amp", 1.0)
	var off = char_fx.env.get("off", 1.0)
	
	char_fx.offset.x = amp * cos(
		char_fx.elapsed_time * freq + char_fx.relative_index * off
	)
	char_fx.offset.y = amp * sin(
		char_fx.elapsed_time * freq + char_fx.relative_index * off
	)
	
	char_fx.transform = char_fx.transform.translated(
		Vector2(char_fx.elapsed_time, 0.0) * 10
	)
	return true
