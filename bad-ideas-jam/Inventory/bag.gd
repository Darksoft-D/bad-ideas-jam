extends Control
class_name Bag

@export var inventory: Inv
@export var slots_num: int = 1

@onready var grid_container: GridContainer = $GridContainer

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var slots: Array = []
var selected_slot: InvSlot = null

func _ready() -> void:
	for i in slots_num:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
		slot.pressed.connect(Callable(self, "on_slot_clicked"))
		slot.selected.connect(Callable(self, "on_slot_selected"))
		slot.unselected.connect(Callable(self, "on_slot_unselected"))
		slot.released.connect(Callable(self, "on_slot_item_released"))
	update_slots()

func on_slot_clicked(item_ui: ItemUI, slot: InvSlot):
	slot.center_container.remove_child(item_ui)
	add_child(item_ui)
	item_ui.is_dragging = true

func on_slot_item_released(item_ui: ItemUI, slot: InvSlot):
	if selected_slot:
		item_ui.is_dragging = false
		selected_slot.update(item_ui.item)
		item_ui.queue_free()
	else:
		item_ui.is_dragging = false
		slot.update(item_ui.item)
		item_ui.queue_free()

func on_slot_selected(slot: InvSlot):
	selected_slot = slot

func on_slot_unselected(slot: InvSlot):
	if selected_slot == slot:
		selected_slot = null

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
