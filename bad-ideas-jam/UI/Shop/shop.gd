extends Control
class_name Shop

@export var items_number: int = 5
@export var items_pool: Array[InvItem]
@export var slots: Array[InvSlot]
@export var labels: Array[Label]

@onready var grid_container: GridContainer = $PanelContainer/GridContainer
@onready var bag: Bag = $Bag
@onready var gold_amount_label: Label = $HBoxContainer/GoldAmountLabel

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var bought_items: Array[InvItem] = []
var selected_slot: InvSlot
var is_dragging = false

func _ready() -> void:
	bag.generate_grid()
	for slot in slots:
		var label = Label.new()
		slot.add_child(label)
		label.position.y = 60
		labels.append(label)
	if bag.items_resource[0]:
		bought_items.append(bag.items_resource[0])
	gold_amount_label.text = str(Global.gold_amount)
	Global.gold_changed.connect(func():
		gold_amount_label.text = str(Global.gold_amount))
	for slot in slots:
		slot.pressed.connect(Callable(self, "on_slot_pressed"))
	update_slots()

func on_slot_pressed(item_ui: ItemUI, slot: InvSlot):
	if bag.get_empty_slot() and item_ui.item.cost <= Global.gold_amount:
		Global.gold_amount -= item_ui.item.cost
		Global.gold_changed.emit()
		bag.get_empty_slot().update(item_ui.item)
		bought_items.append(item_ui.item)
		slot.center_container.remove_child(item_ui)
		item_ui.queue_free()
	else:
		return

func update_slots():
	for i in slots.size():
		slots[i].update(items_pool.pick_random())
		labels[i].text = str(slots[i].item_ui.item.cost)
		slots[i].select_texture.size = Vector2(60, 60)

func on_slot_clicked(item_ui: ItemUI, slot: InvSlot):
	print("loot manager: clicked")
	is_dragging = true
	slot.center_container.remove_child(item_ui)
	add_child(item_ui)
	item_ui.is_dragging = true

func on_slot_item_released(item_ui: ItemUI, slot: InvSlot):
	is_dragging = false
	if selected_slot and !selected_slot.item_ui:
		item_ui.is_dragging = false
		selected_slot.update(load(item_ui.scene_file_path))
		item_ui.queue_free()
	else:
		item_ui.is_dragging = false
		slot.update(load(item_ui.scene_file_path))
		item_ui.queue_free()

func on_slot_selected(slot: InvSlot):
	selected_slot = slot

func on_slot_unselected(slot: InvSlot):
	if selected_slot == slot:
		selected_slot = null

func _on_proceed_button_pressed() -> void:
	Global.bring_items = bought_items
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
