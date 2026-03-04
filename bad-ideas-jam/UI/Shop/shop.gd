extends Control

@export var items_number: int = 5
@export var items_pool: Array[InvItem]

@onready var grid_container: GridContainer = $PanelContainer/GridContainer

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")

var slots: Array[InvSlot] = []

func _ready() -> void:
	generate_grid()

func generate_grid():
	items_pool.shuffle()
	for i in items_number:
		var vbox_container = VBoxContainer.new()
		grid_container.add_child(vbox_container)
		var slot = INV_UI_SLOT.instantiate()
		vbox_container.add_child(slot)
		slots.append(slot)
		var label = Label.new()
		vbox_container.add_child(label)
		label.text = str(items_pool[i].cost)
	update_slots()

func update_slots():
	for i in range(min(items_pool.size(), slots.size())):
		slots[i].update(items_pool[i])
		slots[i].item_ui.scale = Vector2(0.9, 0.9)
