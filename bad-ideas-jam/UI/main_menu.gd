extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton

func _on_start_button_pressed() -> void:
	pass # Replace with function body.

func _on_start_button_mouse_entered() -> void:
	start_button.modulate = Color(1.2, 1.2, 1.2)

func _on_start_button_mouse_exited() -> void:
	start_button.modulate = Color(1, 1, 1)

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_mouse_entered() -> void:
	settings_button.modulate = Color(1.2, 1.2, 1.2)

func _on_settings_button_mouse_exited() -> void:
	settings_button.modulate = Color(1, 1, 1)
