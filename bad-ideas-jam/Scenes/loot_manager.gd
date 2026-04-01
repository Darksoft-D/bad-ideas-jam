extends Node
class_name LootManager

@export var items: Array[InvItem]

@onready var bag: Bag = $"../CanvasLayer/Bag"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var loot_container: VBoxContainer = $"../CanvasLayer/LootContainer"
@onready var button_container: HBoxContainer = $"../CanvasLayer/ButtonContainer"
@onready var player: Player = $"../Player"
@onready var sell_container: PanelContainer = $"../CanvasLayer/SellContainer"
@onready var sell_label: Label = $"../CanvasLayer/SellContainer/SellLabel"
@onready var combat_layer: CanvasLayer = $"../CombatLayer"
@onready var turns_num_label: Label = $"../CombatLayer/VBoxContainer/TurnsNumLabel"
@onready var chest_2: Chest = $"../Visuals/Chest2"

signal looting_finished

const DAMAGE_LABEL = preload("uid://bofywx1j6fpv0")
const ITEM_DELETE_ANIM = preload("uid://wjxuvesugdrd")
const LOOT_BAG = preload("uid://bkb14j2jahlkb")

var common_items: Array[InvItem]
var uncommon_items: Array[InvItem]
var rare_items: Array[InvItem]
var legendary_items: Array[InvItem]
var is_looting = false
var is_loot_opened = false
var player_turn = false
var item_used = false
var on_sell = false
var selected_slot: InvSlot
var turns: int = 1
var max_turns: int = 1
var loot_bag: Bag
var turns_tutorial_shown = false

var helmet_of_hatred = false

func _ready() -> void:
	for item in items:
		match item.item_rarity:
			InvItem.rarity.Common: common_items.append(item)
			InvItem.rarity.Uncommon: uncommon_items.append(item)
			InvItem.rarity.Rare: rare_items.append(item)
			InvItem.rarity.Legendary: legendary_items.append(item)

func generate_loot():
	SoundManager.play_calm()
	player_turn = true
	is_loot_opened = true
	var amount = randi_range(5, 9)
	var loot: Array[InvItem] = []
	if helmet_of_hatred:
		var attack_items = []
		for item in items:
			if item.item_type == InvItem.type.ATTACK:
				attack_items.append(item)
		for i in amount:
			var item = attack_items.pick_random().duplicate()
			loot.append(item)
	else:
		for i in amount:
			var num = randi_range(0, 100)
			var item: InvItem
			if num <= Global.common_chance: item = common_items.pick_random().duplicate()
			elif num <= Global.uncommon_chance: item = uncommon_items.pick_random().duplicate()
			elif num <= Global.rare_chance: item = rare_items.pick_random().duplicate()
			else: item = legendary_items.pick_random().duplicate()
			loot.append(item)
	loot_container.show()
	button_container.show()
	loot_bag = LOOT_BAG.instantiate()
	loot_bag.items_resource.resize(9)
	loot_bag.items_resource.fill(null)
	loot_bag.loot_manager = self
	loot_container.add_child(loot_bag)
	await loot_bag.generate_loot(loot)
	combat_layer.hide()

func finish_looting():
	loot_container.hide()
	button_container.hide()
	await get_parent().fade_to_black()
	chest_2.hide()
	is_loot_opened = false
	looting_finished.emit()
	combat_layer.show()
	player.health_bags = []
	for slot in bag.slots:
		if slot.item_ui:
			if slot.item_ui.item is HealthBag:
				player.health_bags.append(slot.item_ui.item)
				slot.item_ui.used.connect(Callable(self, "delete_item"))
			slot.item_ui.item.apply(player, get_parent())
	loot_bag.queue_free()
	get_parent().update_health()

func on_slot_clicked(item_ui: ItemUI, slot: InvSlot):
	SoundManager.item_pick_up.play()
	if !player_turn:
		return
	for description in slot.descriptions:
		if !description:
			slot.descriptions.erase(description)
		else:
			slot.descriptions_container.remove_child(description)
			item_ui.add_child(description)
			item_ui.descriptions.append(description)
			description.hide()
	is_looting = true
	slot.sprite_pos.remove_child(item_ui)
	canvas_layer.add_child(item_ui)
	item_ui.is_dragging = true
	item_ui.item.unapply(player, get_parent())
	if is_loot_opened:
		sell_container.show()
		sell_label.text = "Sell for " + str(item_ui.item.cost*2/3)

func on_slot_item_released(item_ui: ItemUI, slot: InvSlot):
	if !player_turn:
		return
	is_looting = false
	if selected_slot == slot:
		item_ui.is_dragging = false
		canvas_layer.remove_child(item_ui)
		slot.sprite_pos.add_child(item_ui)
		await slot.assign_item(item_ui)
		slot.tooltip.show()
	elif selected_slot and !selected_slot.item_ui:
		SoundManager.item_equip.play()
		item_ui.is_dragging = false
		canvas_layer.remove_child(item_ui)
		selected_slot.sprite_pos.add_child(item_ui)
		slot.item_ui = null
		selected_slot.assign_item(item_ui)
		selected_slot.tooltip.show()
	elif on_sell:
		SoundManager.coin.play()
		Global.gold_amount += item_ui.item.cost/1.5
		item_ui.queue_free()
		Global.gold_changed.emit()
	elif is_loot_opened or !item_ui.item.condition(get_parent()):
		item_ui.is_dragging = false
		canvas_layer.remove_child(item_ui)
		slot.sprite_pos.add_child(item_ui)
		slot.assign_item(item_ui)
	elif item_used and !item_ui.item.free:
		item_ui.is_dragging = false
		canvas_layer.remove_child(item_ui)
		slot.sprite_pos.add_child(item_ui)
		slot.assign_item(item_ui)
	else:
		item_ui.used.connect(Callable(self, "on_used"))
		if item_ui.item:
			slot.item_ui = null
			for description in slot.descriptions:
				slot.descriptions.erase(description)
				if description:
					description.queue_free()
			item_ui.item.use(get_parent().enemy, get_parent(), get_parent().player)
	sell_container.hide()

func on_used(item_ui: ItemUI):
	if Global.is_tutorial and !turns_tutorial_shown and get_parent().enemy:
		get_parent().turns_tutorial.show()
		turns_tutorial_shown = true
		get_parent().block_rect.show()
	SoundManager.item_used.play()
	if !item_ui.item.free:
		turns -= 1
		turns_num_label.text = str(turns) + "/" + str(max_turns)
		if turns <= 0:
			item_used = true
	Global.last_used_item = item_ui.item
	Global.used_items.append(item_ui.item)
	var used_anim = ITEM_DELETE_ANIM.instantiate()
	item_ui.get_parent().add_child(used_anim)
	used_anim.global_position = item_ui.global_position
	if item_ui.item.item_type == InvItem.type.ATTACK:
		var damage_label = DAMAGE_LABEL.instantiate()
		canvas_layer.add_child(damage_label)
		damage_label.global_position = item_ui.global_position
		damage_label.text = str(item_ui.item.damage)
	delete_item(item_ui)
	
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
