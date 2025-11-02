@tool
class_name NeedleRichTextEffect
extends RichTextEffect


var bbcode = "needle"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	#char_fx.color = Color.SILVER
	var freq = char_fx.env.get("freq", 1.0)
	var amp = char_fx.env.get("amp", 1.0)
	
	char_fx.offset.y = amp * cos(
		char_fx.elapsed_time * freq 
	)
	
	return true
