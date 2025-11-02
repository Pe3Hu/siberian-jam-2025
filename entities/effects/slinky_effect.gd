@tool
class_name SlinkyRichTextEffect
extends RichTextEffect


var bbcode = "slinky"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq = char_fx.env.get("freq", 1.0)
	var grade = char_fx.env.get("grade", 2.0)
	var size = char_fx.env.get("size", 1.0)
	char_fx.offset.x += pow((size - char_fx.relative_index) * 2 * cos(char_fx.elapsed_time * freq), grade)
	char_fx.offset.y += pow((size - char_fx.relative_index) * 2 * sin(char_fx.elapsed_time * freq), grade)
	var colors = char_fx.env.get("colors", ["forest_green", "red"])
	var color_pos = (char_fx.range.x + 1) % len(colors)
	char_fx.color = colors[color_pos]
	return true
