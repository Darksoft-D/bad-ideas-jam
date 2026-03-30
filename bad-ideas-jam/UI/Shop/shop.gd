extends Control
class_name Shop

@export var items_number: int = 5
@export var items_pool: Array[InvItem]
@export var slots: Array[InvSlot]
@export var labels: Array[Label]

@onready var grid_container: GridContainer = $ItemContainer/PanelContainer/GridContainer
@onready var bag: Bag = $Bag
@onready var gold_amount_label: Label = $HBoxContainer/GoldAmountLabel
@onready var item_container: PanelContainer = $ItemContainer
@onready var relics_grid_container: GridContainer = $ItemContainer/PanelContainer/RelicsGridContainer

const RELIC_BASE = preload("uid://d3g2oexu73d2s")
const SHOP_SLOT = preload("uid://dtf8h637pofro")

var bought_items: Array[InvItem] = []
var selected_slot: InvSlot
var is_dragging = false

func _ready() -> void:
	SoundManager.battle_theme_2_calm.stop()
	SoundManager.battle_theme_2_full.stop()
	SoundManager.shop_theme.play()
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
		slot.pressed.connect(Callable(self, "on_item_slot_pressed"))
	update_slots()
	relics_generate()

func relics_generate():
	for relic in Global.shop_relics:
		var v_box = VBoxContainer.new()
		relics_grid_container.add_child(v_box)
		var slot = SHOP_SLOT.instantiate()
		v_box.add_child(slot)
		slot.relic = relic.duplicate()
		slot.relic_buy.connect(Callable(self, "on_relic_buy"))
		var relic_base = RELIC_BASE.instantiate()
		slot.add_child(relic_base)
		relic_base.assign_relic(relic)
		slot.relic_ui = relic_base
		var label = Label.new()
		v_box.add_child(label)
		label.text = str(relic.cost)
		slot.relic_label = label
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.v_box = v_box

func on_relic_buy(relic: Relic, slot: InvSlot):
	if relic.cost <= Global.gold_amount:
		Global.gold_amount -= relic.cost
		Global.gold_changed.emit()
		SoundManager.item_equip.play()
		Global.owned_relics.append(relic)
		slot.queue_free()
		slot.v_box.queue_free()
		for shop_relic in Global.shop_relics:
			if shop_relic.name == relic.name:
				Global.shop_relics.erase(shop_relic)
				return
	else:
		SoundManager.deny.play()
	
func on_item_slot_pressed(item_ui: ItemUI, slot: InvSlot):
	if bag.get_empty_slot() and item_ui.item.cost <= Global.gold_amount:
		SoundManager.item_equip.play()
		Global.gold_amount -= item_ui.item.cost
		Global.gold_changed.emit()
		bag.get_empty_slot().update(item_ui.item)
		bought_items.append(item_ui.item)
		slot.center_container.remove_child(item_ui)
		item_ui.queue_free()
	else:
		SoundManager.deny.play()

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
	SoundManager.shop_theme.stop()
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

func _on_items_button_pressed() -> void:
	grid_container.show()
	relics_grid_container.hide()

func _on_relics_button_pressed() -> void:
	grid_container.hide()
	relics_grid_container.show()
