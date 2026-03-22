extends Sprite2D

func _ready() -> void:
	var down_scale = scale * 0.5
	var up_scale = scale * 1.2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", up_scale, 0.4).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", down_scale, 0.4).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.4)
	await tween.finished
	tween.kill()
	queue_free()
