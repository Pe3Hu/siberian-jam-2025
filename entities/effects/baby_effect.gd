@tool
class_name BabyRichTextEffect
extends RichTextEffect


var bbcode = "baby"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	#var freq = char_fx.env.get("freq", 1.0)
	#char_fx.color.r = 0.2 * char_fx.relative_index + char_fx.elapsed_time * freq
	#char_fx.color.g = 0.2 * char_fx.relative_index + char_fx.elapsed_time * freq
	#char_fx.color.r = 1 - 0.15 * char_fx.relative_index + char_fx.elapsed_time * freq 
	#char_fx.color.g = 1 - 0.3 * char_fx.relative_index  + char_fx.elapsed_time * freq
	var colors = char_fx.env.get("colors", ["gold", "sienna"])
	var color_pos = (char_fx.range.x + int(sin(char_fx.elapsed_time) * 2)) % len(colors)
	char_fx.color = colors[color_pos]
	return true
