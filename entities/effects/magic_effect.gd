@tool
class_name CustomRichTextEffect
extends RichTextEffect


var bbcode = "test"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq = char_fx.env.get("freq", 1.0)
	var amp = char_fx.env.get("amp", 1.0)
	var off = char_fx.env.get("off", 1.0)
	
	
	return true
