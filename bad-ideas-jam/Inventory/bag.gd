extends Control
class_name Bag

@export var loot_manager: LootManager
@export var inventory: Inv
@export var slots_num: int = 1

@onready var grid_container: GridContainer = $GridContainer

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var slots: Array = []
var selected_slot: InvSlot = null

func _ready() -> void:
	generate_grid()

func generate_grid():
	for i in slots_num:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
		slot.pressed.connect(Callable(loot_manager, "on_slot_clicked"))
		slot.selected.connect(Callable(loot_manager, "on_slot_selected"))
		slot.unselected.connect(Callable(loot_manager, "on_slot_unselected"))
		slot.released.connect(Callable(loot_manager, "on_slot_item_released"))
	update_slots()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
