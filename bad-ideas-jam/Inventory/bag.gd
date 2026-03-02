extends Control
class_name Bag

@onready var inventory_slot_container: VBoxContainer = $InventorySlotContainer

const INVENTORY_SLOT = preload("uid://crrd2wadq3nf4")

func _ready() -> void:
	for n in range(3):
		var h_box_containner = HBoxContainer.new()
		inventory_slot_container.add_child(h_box_containner)
		h_box_containner.add_theme_constant_override("separation", 40)
		for i in range(5):
			var slot = INVENTORY_SLOT.instantiate()
			h_box_containner.add_child(slot)
