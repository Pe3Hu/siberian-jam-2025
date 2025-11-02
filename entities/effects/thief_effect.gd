@tool
class_name ThiefRichTextEffect
extends RichTextEffect


var bbcode = "thief"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var duration = char_fx.env.get("duration", 1.0)
	var t = char_fx.elapsed_time / duration
	#var t = (char_fx.elapsed_time - char_fx.relative_index) / duration
	var a = clamp(t, 0.0, 1.0)
	char_fx.color.a = a
	return true
