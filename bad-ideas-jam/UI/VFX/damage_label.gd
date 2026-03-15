extends Label

@onready var tween_property: TweenProperty = $TweenProperty
@onready var tween_property_2: TweenProperty = $TweenProperty2

func _ready() -> void:
	var down_scale = scale * 0.5
	var up_scale = scale * 1.2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", up_scale, 0.2).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", down_scale, 0.2).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.kill()
	queue_free()
