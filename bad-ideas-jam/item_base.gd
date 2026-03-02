extends Node2D
class_name Item

var can_drag
var is_dragging := false
var original_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if Input.is_action_pressed("Drag") and can_drag:
		global_position = get_global_mouse_position()
	elif Input.is_action_just_released("Drag"):
		can_drag = false
		global_position = original_position

func _on_area_2d_mouse_entered() -> void:
	if !can_drag:
		original_position = global_position
		can_drag = true
