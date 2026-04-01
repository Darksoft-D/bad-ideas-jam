extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var name_label: Label = $NameLabel
@onready var settings: Control = $Settings
@onready var color_rect: ColorRect = $ColorRect2

func _ready() -> void:
	SoundManager.boss_theme_calm.play()
	settings.close.connect(func():
		SoundManager.pressed.play()
		settings.hide()
		start_button.show()
		settings_button.show()
		name_label.show())
		
func fade_to_black():
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0), 0.5).set_ease(Tween.EASE_IN)
	await tween.finished

func _on_start_button_pressed() -> void:
	SoundManager.pressed.play()
	await fade_to_black()
	SoundManager.boss_theme_calm.stop()
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

func _on_start_button_mouse_entered() -> void:
	SoundManager.hover.play()
	start_button.modulate = Color(1.2, 1.2, 1.2)

func _on_start_button_mouse_exited() -> void:
	start_button.modulate = Color(1, 1, 1)

func _on_settings_button_pressed() -> void:
	SoundManager.pressed.play()
	settings.show()
	start_button.hide()
	settings_button.hide()
	name_label.hide()

func _on_settings_button_mouse_entered() -> void:
	SoundManager.hover.play()
	settings_button.modulate = Color(1.2, 1.2, 1.2)

func _on_settings_button_mouse_exited() -> void:
	settings_button.modulate = Color(1, 1, 1)
