extends Control
class_name Bag

@export var items_resource: Array[InvItem]
@export var loot_manager: Node
@export var slots_num: int = 1

@onready var grid_container: GridContainer = $GridContainer
@onready var bag_size_1: TextureRect = $BagSize1
@onready var bag_size_2: TextureRect = $BagSize2

const INV_UI_SLOT = preload("uid://dijoj8qysu0hg")
const ITEM_DELETE_ANIM = preload("uid://wjxuvesugdrd")

@export var slots: Array[InvSlot] = []
var selected_slot: InvSlot = null

func _ready() -> void:
	slots_num = Global.slots_num

func generate_grid():
	for i in slots_num:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
	if slots_num > 6:
		bag_size_1.hide()
		bag_size_2.show()
	connect_slots()
	update_slots()

func increase():
	slots_num += 3
	for i in 3:
		var slot = INV_UI_SLOT.instantiate()
		grid_container.add_child(slot)
		slots.append(slot)
		slot.pressed.connect(Callable(loot_manager, "on_slot_clicked"))
		slot.selected.connect(Callable(loot_manager, "on_slot_selected"))
		slot.unselected.connect(Callable(loot_manager, "on_slot_unselected"))
		slot.released.connect(Callable(loot_manager, "on_slot_item_released"))
	if slots_num > 6:
		bag_size_1.hide()
		bag_size_2.show()

func connect_slots():
	if slots.is_empty():
		return
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

func get_items() -> Array:
	var items = []
	for slot in slots:
		if slot.item_ui and !slot.item_ui.item is HealthBag:
			items.append(slot.item_ui)
	return items

func get_attack_items() -> Array:
	var item_uis = get_items()
	var items = []
	for item_ui in item_uis:
		if item_ui.item.item_type == InvItem.type.ATTACK:
			items.append(item_ui)
	return items

func get_max_health_bag() -> ItemUI:
	var max_item = null
	for slot in slots:
		if slot.item_ui and slot.item_ui.item is HealthBag:
			if max_item == null:
				max_item = slot.item_ui
			elif slot.item_ui.item.value > max_item.item.value:
				max_item = slot.item_ui
	return max_item

func get_health_bags() -> Array:
	var items = []
	for slot in slots:
		if slot.item_ui and slot.item_ui.item is HealthBag:
			items.append(slot.item_ui)
	return items

func remove_item(item_ui: ItemUI):
	for slot in slots:
		if slot.item_ui == item_ui:
			var remove_anim = ITEM_DELETE_ANIM.instantiate()
			add_child(remove_anim)
			remove_anim.global_position = item_ui.global_position
			slot.item_ui = null
			for description in slot.descriptions:
				slot.descriptions.erase(description)
				description.queue_free()
			item_ui.queue_free()
			return

func update_slots():
	for slot in slots:
		if slot.item_ui:
			slot.item_ui.queue_free()
	for i in range(items_resource.size()):
		slots[i].update(items_resource[i])
