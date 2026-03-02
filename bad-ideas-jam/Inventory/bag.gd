extends Control
class_name Bag

@export var inventory: Inv
@export var slots_num: int = 1

@onready var grid_container: GridContainer = $GridContainer

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var slots: Array = []

func _ready() -> void:
	for i in slots_num:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
	update_slots()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
