extends Panel
class_name InvSlot

@onready var select_texture: TextureRect = $CenterContainer/SelectTexture
@onready var center_container: CenterContainer = $CenterContainer

const ITEM_UI = preload("uid://dk3ifj8pbnten")

signal selected(slot: InvSlot)
signal unselected(slot: InvSlot)
signal pressed(item_ui: ItemUI, slot: InvSlot)
signal released(item_ui: ItemUI, slot: InvSlot)

var item: InvItem
var item_ui: ItemUI
var is_selected = false
var is_dragging = false

func _input(event: InputEvent) -> void:
	if is_selected and event.is_action_pressed("Drag") and !is_dragging and item:
		print("Clicked")
		is_dragging = true
		pressed.emit(item_ui, self)
		item = null
	elif event.is_action_released("Drag") and is_dragging:
		print("Released")
		is_dragging = false
		released.emit(item_ui, self)

func update(get_item: InvItem):
	if !get_item or item:
		if item_ui:
			item_ui.queue_free()
		return
	print("update")
	item = get_item
	item_ui = ITEM_UI.instantiate()
	center_container.add_child(item_ui)
	item_ui.assign_item(item)

func _on_mouse_entered() -> void:
	select_texture.show()
	is_selected = true
	selected.emit(self)

func _on_mouse_exited() -> void:
	select_texture.hide()
	is_selected = false
	unselected.emit(self)
