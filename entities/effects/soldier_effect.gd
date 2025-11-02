@tool
class_name SoldierRichTextEffect
extends RichTextEffect


var bbcode = "soldier"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var duration = char_fx.env.get("duration", 1.0)
	var t = (char_fx.elapsed_time - char_fx.relative_index) / duration
	var a = clamp(t, 0.0, 1.0)
	char_fx.color.a = 0.0 if a < 1.0 else 1.0
	return true
