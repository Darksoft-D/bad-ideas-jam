@tool
extends RichTextEffect
class_name ShakeEffect

var bbcode = "shake"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var strength = char_fx.env.get("strength", 2.0)
	var speed = char_fx.env.get("speed", 10.0)
	var t = Time.get_ticks_msec() / 1000.0 + char_fx.relative_index
	char_fx.offset.x += sin(t * speed) * strength
	char_fx.offset.y += cos(t * speed) * strength
	return true
