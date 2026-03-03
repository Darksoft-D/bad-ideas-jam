extends Node
class_name LootManager

@export var items: Array[InvItem]

@onready var bag: Bag = $"../CanvasLayer/Bag"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var loot_container: VBoxContainer = $"../CanvasLayer/LootContainer"
@onready var button_container: HBoxContainer = $"../CanvasLayer/ButtonContainer"
@onready var loot_bag: Bag = $"../CanvasLayer/LootContainer/LootBag"

signal looting_finished

var is_looting = false
var is_loot_opened = false
var selected_slot: InvSlot

func generate_loot():
	is_loot_opened = true
	var amount = randi_range(1, 5)
	var loot: Array[InvItem] = []
	for i in amount:
		var item = items.pick_random()
		loot.append(item)
	loot_container.show()
	button_container.show()
	await loot_bag.inventory.generate_loot(loot)
	loot_bag.update_slots()

func finish_looting():
	loot_container.hide()
	button_container.hide()
	is_loot_opened = false
	looting_finished.emit()

func on_slot_clicked(item_ui: ItemUI, slot: InvSlot):
	is_looting = true
	slot.center_container.remove_child(item_ui)
	canvas_layer.add_child(item_ui)
	item_ui.is_dragging = true

func on_slot_item_released(item_ui: ItemUI, slot: InvSlot):
	is_looting = false
	if selected_slot:
		item_ui.is_dragging = false
		selected_slot.update(item_ui.item)
		item_ui.queue_free()
	elif is_loot_opened:
		item_ui.is_dragging = false
		slot.update(item_ui.item)
		item_ui.queue_free()
	else:
		item_ui.used.connect(Callable(self, "on_used"))
		if item_ui.item:
			item_ui.item.use(get_parent().enemy)

func on_used(item_ui: ItemUI):
	item_ui.used.disconnect(on_used)
	item_ui.queue_free()

func on_slot_selected(slot: InvSlot):
	selected_slot = slot

func on_slot_unselected(slot: InvSlot):
	if selected_slot == slot:
		selected_slot = null

func _on_continue_button_pressed() -> void:
	if !is_looting:
		finish_looting()
