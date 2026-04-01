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
@onready var tutorial_container: PanelContainer = $TutorialContainer
@onready var block_rect: ColorRect = $BlockRect
@onready var upgrades_grid_container: GridContainer = $ItemContainer/PanelContainer/UpgradesGridContainer
@onready var health_upgrade: InvSlot = $ItemContainer/PanelContainer/UpgradesGridContainer/HealthUpgrade
@onready var bag_size_upgrade: InvSlot = $ItemContainer/PanelContainer/UpgradesGridContainer/BagSizeUpgrade
@onready var relics_size_upgrade: InvSlot = $ItemContainer/PanelContainer/UpgradesGridContainer/RelicsSizeUpgrade
@onready var health_up_description: PanelContainer = $ItemContainer/PanelContainer/UpgradesGridContainer/HealthUpgrade/TextureRect/HealthUpDescription
@onready var bag_up_description: PanelContainer = $ItemContainer/PanelContainer/UpgradesGridContainer/BagSizeUpgrade/TextureRect/BagUpDescription
@onready var relic_up_description: PanelContainer = $ItemContainer/PanelContainer/UpgradesGridContainer/RelicsSizeUpgrade/TextureRect/RelicUpDescription

const RELIC_BASE = preload("uid://d3g2oexu73d2s")
const SHOP_SLOT = preload("uid://dtf8h637pofro")

var HEALTH_BAG = preload("uid://mi5pgt1to8qa")
var bought_items: Array[InvItem] = []
var selected_slot: InvSlot
var is_dragging = false
var upgrade_cost = 50

func _ready() -> void:
	set_upgrades()
	health_upgrade.is_upgrade = true
	bag_size_upgrade.is_upgrade = true
	relics_size_upgrade.is_upgrade = true
	if Global.is_tutorial:
		tutorial_container.show()
		block_rect.show()
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
	if Global.is_tutorial:
		return
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
	if Global.is_tutorial:
		return
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

func set_upgrades():
	if Global.is_bag_upgrade:
		bag_size_upgrade.queue_free()
	if Global.is_health_upgrade:
		health_upgrade.queue_free()
	if Global.is_relic_upgrade:
		relics_size_upgrade.queue_free()

func _on_proceed_button_pressed() -> void:
	if Global.is_tutorial:
		return
	SoundManager.pressed.play()
	Global.bring_items = bought_items
	SoundManager.shop_theme.stop()
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

func _on_items_button_pressed() -> void:
	SoundManager.pressed.play()
	grid_container.show()
	relics_grid_container.hide()
	upgrades_grid_container.hide()

func _on_relics_button_pressed() -> void:
	SoundManager.pressed.play()
	grid_container.hide()
	upgrades_grid_container.hide()
	relics_grid_container.show()

func _on_button_pressed() -> void:
	SoundManager.pressed.play()
	Global.is_tutorial = false
	tutorial_container.hide()
	block_rect.hide()

func _on_upgrades_button_pressed() -> void:
	SoundManager.pressed.play()
	grid_container.hide()
	upgrades_grid_container.show()
	relics_grid_container.hide()

func _on_health_upgrade_upgrade_buy(slot: InvSlot) -> void:
	if Global.gold_amount < upgrade_cost:
		SoundManager.deny.play()
		return
	SoundManager.item_equip.play()
	HEALTH_BAG.value += 10
	for bag_slot in bag.slots:
		if bag_slot.item_ui and bag_slot.item_ui.item is HealthBag:
			bag_slot.item_ui.value_label.text = str(HEALTH_BAG.value)
	Global.is_health_upgrade = true
	slot.queue_free()
	Global.gold_amount -= upgrade_cost
	Global.gold_changed.emit()

func _on_bag_size_upgrade_upgrade_buy(slot: InvSlot) -> void:
	if Global.gold_amount < upgrade_cost:
		SoundManager.deny.play()
		return
	SoundManager.item_equip.play()
	Global.slots_num += 3
	bag.increase()
	Global.is_bag_upgrade = true
	slot.queue_free()
	Global.gold_amount -= upgrade_cost
	Global.gold_changed.emit()

func _on_relics_size_upgrade_upgrade_buy(slot: InvSlot) -> void:
	if Global.gold_amount < upgrade_cost:
		SoundManager.deny.play()
		return
	SoundManager.item_equip.play()
	Global.relics_size = 2
	Global.is_relic_upgrade = true
	slot.queue_free()
	Global.gold_amount -= upgrade_cost
	Global.gold_changed.emit()

func _on_health_upgrade_mouse_entered() -> void:
	health_up_description.show()

func _on_health_upgrade_mouse_exited() -> void:
	health_up_description.hide()

func _on_bag_size_upgrade_mouse_entered() -> void:
	bag_up_description.show()

func _on_bag_size_upgrade_mouse_exited() -> void:
	bag_up_description.hide()

func _on_relics_size_upgrade_mouse_entered() -> void:
	relic_up_description.show()

func _on_relics_size_upgrade_mouse_exited() -> void:
	relic_up_description.hide()
