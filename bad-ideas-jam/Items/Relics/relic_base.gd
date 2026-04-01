extends TextureRect
class_name RelicUI

@onready var panel_container: PanelContainer = $PanelContainer
@onready var text_container: VBoxContainer = $PanelContainer/TextContainer
@onready var name_label: Label = $PanelContainer/TextContainer/NameLabel
@onready var description_label: Label = $PanelContainer/TextContainer/DescriptionLabel

signal chosen(relic: Relic)

var text_show = false
var taken = false
var relic: Relic

func _process(delta: float) -> void:
	if !text_show:
		return
	panel_container.global_position = get_global_mouse_position() + Vector2(5, 5)

func assign_relic(get_relic: Relic):
	relic = get_relic
	texture = relic.texture
	name_label.text = relic.name
	description_label.text = relic.description

func _on_mouse_entered() -> void:
	modulate = Color(1.2, 1.2, 1.2)
	text_show = true
	panel_container.show()

func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)
	text_show = false
	panel_container.hide()

func _on_gui_input(event: InputEvent) -> void:
	if text_show and event.is_action_pressed("Drag") and !taken:
		chosen.emit(relic)
