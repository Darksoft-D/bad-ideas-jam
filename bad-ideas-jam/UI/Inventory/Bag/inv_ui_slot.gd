extends Panel
class_name InvSlot

@onready var sell_container: VBoxContainer = $SellContainer
@onready var sell_button: Button = $SellContainer/SellButton
@onready var center_container: CenterContainer = $CenterContainer
@onready var select_texture: TextureRect = $CenterContainer/SelectTexture

const ITEM_UI = preload("uid://dk3ifj8pbnten")

signal selected(slot: InvSlot)
signal unselected(slot: InvSlot)
signal pressed(item_ui: ItemUI, slot: InvSlot)
signal released(item_ui: ItemUI, slot: InvSlot)
signal gain(item_ui: ItemUI)

var item_ui: ItemUI
var is_selected = false
var is_dragging = false
var on_sell = false

func _input(event: InputEvent) -> void:
	if is_selected and event.is_action_pressed("Drag") and !is_dragging and item_ui:
		print("Clicked")
		is_dragging = true
		pressed.emit(item_ui, self)
	elif event.is_action_released("Drag") and is_dragging:
		print("Released")
		is_dragging = false
		released.emit(item_ui, self)
	elif is_selected and event.is_action_pressed("RightClick"):
		if !on_sell:
			if Global.shown_sell_container:
				Global.shown_sell_container.hide()
			on_sell = true
			sell_container.show()
			Global.shown_sell_container = sell_container

func update(item_scene: PackedScene):
	if !item_scene:
		return
	print("update ", item_ui)
	item_ui = item_scene.instantiate()
	center_container.add_child(item_ui)
	if item_ui.item is Block:
		gain.emit(item_ui)

func _on_mouse_entered() -> void:
	select_texture.show()
	is_selected = true
	selected.emit(self)

func _on_mouse_exited() -> void:
	select_texture.hide()
	is_selected = false
	unselected.emit(self)
