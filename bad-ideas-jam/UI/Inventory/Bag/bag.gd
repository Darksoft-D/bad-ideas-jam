extends Control
class_name Bag

@export var items_export: Array[PackedScene]
@export var loot_manager: Node
@export var slots_num: int = 1

@onready var grid_container: GridContainer = $GridContainer

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var slots: Array[InvSlot] = []
var selected_slot: InvSlot = null
var is_loot_bag = false

func _ready() -> void:
	generate_grid()

func generate_grid():
	for i in slots_num:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
	connect_slots()
	update_slots()

func connect_slots():
	for slot in slots:
		slot.pressed.connect(Callable(loot_manager, "on_slot_clicked"))
		slot.selected.connect(Callable(loot_manager, "on_slot_selected"))
		slot.unselected.connect(Callable(loot_manager, "on_slot_unselected"))
		slot.released.connect(Callable(loot_manager, "on_slot_item_released"))

func get_empty_slot() -> InvSlot:
	for slot in slots:
		if !slot.item_ui:
			return slot
	return 

func update_slots():
	print("Item export ", items_export)
	for slot in slots:
		if slot.item_ui:
			slot.item_ui.queue_free()
	for i in range(items_export.size()):
		slots[i].update(items_export[i])
		if slots[i].item_ui:
			slots[i].apply()
	if !is_loot_bag:
		slots[0].change_state(InvSlot.state.STRENGHT)
