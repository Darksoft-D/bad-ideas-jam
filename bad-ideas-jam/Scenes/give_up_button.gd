extends Button

@export var player: Player

@onready var give_up_description: PanelContainer = $GiveUpDescription

var is_shown

func _process(delta: float) -> void:
	if is_shown:
		give_up_description.global_position = get_global_mouse_position() + Vector2(10, 10)

func _on_mouse_entered() -> void:
	is_shown = true
	give_up_description.show()

func _on_mouse_exited() -> void:
	is_shown = false
	give_up_description.hide()

func _on_pressed() -> void:
	player.died.emit()
	player.queue_free()
