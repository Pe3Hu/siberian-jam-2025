@tool
class_name MashroomRichTextEffect
extends RichTextEffect


var bbcode = "mashroom"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq = char_fx.env.get("freq", 1.0)
	char_fx.color.g = 0.1 * char_fx.relative_index 
	char_fx.color.g = 1 - 0.1 * char_fx.relative_index  
	
	char_fx.transform = char_fx.transform.rotated_local(
		char_fx.elapsed_time * freq
	)
	return true
