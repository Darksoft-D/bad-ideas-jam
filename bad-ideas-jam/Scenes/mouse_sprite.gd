extends Sprite2D

func _ready() -> void:
	anim()

func anim() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)
	await tween.finished
	anim()
	tween.kill()
