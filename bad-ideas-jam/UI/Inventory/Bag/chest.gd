extends Control
class_name Chest

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var control: Control = $Control

signal chest_opened

var can_open = false
var disabled = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Drag") and can_open:
		open()

func open():
	SoundManager.open_chest.play()
	animated_sprite_2d.play("Open")
	await animated_sprite_2d.animation_finished
	chest_opened.emit()
	disabled = true

func _on_control_mouse_entered() -> void:
	if disabled:
		return
	animated_sprite_2d.modulate = Color(1.2, 1.2, 1.2)
	can_open = true

func _on_control_mouse_exited() -> void:
	animated_sprite_2d.modulate = Color(1, 1, 1)
	can_open = false
