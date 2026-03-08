extends Node
class_name LootManager

@export var items: Array[PackedScene]

@onready var bag: Bag = $"../CanvasLayer/Bag"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var loot_container: VBoxContainer = $"../CanvasLayer/LootContainer"
@onready var button_container: HBoxContainer = $"../CanvasLayer/ButtonContainer"
@onready var loot_bag: Bag = $"../CanvasLayer/LootContainer/LootBag"
@onready var player: Player = $"../Player"
@onready var sell_container: PanelContainer = $"../CanvasLayer/SellContainer"
@onready var sell_label: Label = $"../CanvasLayer/SellContainer/SellLabel"
@onready var combat_layer: CanvasLayer = $"../CombatLayer"
@onready var chest: Chest = $"../Visuals/Chest"

signal looting_finished

var is_looting = false
var is_loot_opened = false
var player_turn = false
var item_used = false
var on_sell = false
var selected_slot: InvSlot
var turns: int = 1

func _ready() -> void:
	chest.chest_opened.connect(func():
		generate_loot())

func generate_loot():
	player_turn = true
	is_loot_opened = true
	var amount = randi_range(2, 5)
	var loot: Array[PackedScene] = []
	for i in amount:
		var item = items.pick_random()
		loot.append(item)
	loot_container.show()
	button_container.show()
	await loot_bag.generate_loot(loot)
	loot_bag.update_slots()
	combat_layer.hide()

func finish_looting():
	loot_container.hide()
	button_container.hide()
	chest.hide()
	is_loot_opened = false
	looting_finished.emit()
	combat_layer.show()
	player.health_bags = []
	player.blocks = []
	for slot in bag.slots:
		if slot.item_ui:
			if slot.item_ui.item is HealthBag:
				player.health_bags.append(slot.item_ui.item)
				slot.item_ui.used.connect(Callable(self, "delete_item"))
			elif slot.item_ui.item is Block:
				player.blocks.append(slot.item_ui.item)
				slot.item_ui.used.connect(Callable(self, "delete_item"))

func on_slot_clicked(item_ui: ItemUI, slot: InvSlot):
	print("loot manager: clicked")
	if !player_turn:
		return
	is_looting = true
	slot.center_container.remove_child(item_ui)
	canvas_layer.add_child(item_ui)
	item_ui.is_dragging = true
	if is_loot_opened:
		sell_container.show()
		sell_label.text = "Sell for " + str(item_ui.item.cost)

func on_slot_item_released(item_ui: ItemUI, slot: InvSlot):
	if !player_turn:
		return
	is_looting = false
	if selected_slot and !selected_slot.item_ui:
		item_ui.is_dragging = false
		selected_slot.update(load(item_ui.scene_file_path))
		item_ui.queue_free()
	elif on_sell:
		Global.gold_amount += item_ui.item.cost
		print(Global.gold_amount)
		item_ui.queue_free()
		Global.gold_changed.emit()
	elif is_loot_opened or !item_ui.item.skill or item_used:
		item_ui.is_dragging = false
		slot.update(load(item_ui.scene_file_path))
		item_ui.queue_free()
	else:
		item_ui.used.connect(Callable(self, "on_used"))
		if item_ui.item:
			item_ui.item.use(get_parent().enemy, get_parent())
	sell_container.hide()

func on_used(item_ui: ItemUI):
	Global.last_used_item = item_ui.item
	delete_item(item_ui)
	turns -= 1
	if turns <= 0:
		item_used = true
	
func delete_item(item_ui: ItemUI):
	item_ui.used.disconnect(on_used)
	item_ui.queue_free()

func on_slot_selected(slot: InvSlot):
	if !player_turn:
		return
	selected_slot = slot

func on_slot_unselected(slot: InvSlot):
	if !player_turn:
		return
	if selected_slot == slot:
		selected_slot = null

func _on_continue_button_pressed() -> void:
	if !is_looting:
		finish_looting()

func _on_sell_container_mouse_entered() -> void:
	if is_looting:
		on_sell = true

func _on_sell_container_mouse_exited() -> void:
	on_sell = false
