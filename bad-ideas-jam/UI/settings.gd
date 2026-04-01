extends Control

@onready var close_button: Button = $PanelContainer/CloseButton

signal close

func _on_close_button_pressed() -> void:
	close.emit()

func _on_close_button_mouse_entered() -> void:
	close_button.modulate = Color(1.2, 1,2, 1.2)

func _on_close_button_mouse_exited() -> void:
	close_button.modulate = Color(1, 1, 1)
