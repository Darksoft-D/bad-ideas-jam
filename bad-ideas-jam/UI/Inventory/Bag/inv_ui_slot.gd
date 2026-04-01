extends Panel
class_name InvSlot

@onready var sell_container: VBoxContainer = $SellContainer
@onready var sell_button: Button = $SellContainer/SellButton
@onready var center_container: CenterContainer = $CenterContainer
@onready var select_texture: TextureRect = $CenterContainer/SelectTexture
@onready var strength_rect: ColorRect = $StrengthRect
@onready var sprite_pos: Node2D = $SpritePos
@onready var tooltip: PanelContainer = $Tooltip
@onready var descriptions_container: HBoxContainer = $Tooltip/DescriptionsContainer

const ITEM_UI = preload("uid://dk3ifj8pbnten")

signal selected(slot: InvSlot)
signal unselected(slot: InvSlot)
signal pressed(item_ui: ItemUI, slot: InvSlot)
signal released(item_ui: ItemUI, slot: InvSlot)
signal gain_health(item_ui: ItemUI)
signal relic_buy(relic: Relic, slot: InvSlot)
signal upgrade_buy(slot: InvSlot)

var item_ui: ItemUI
var relic: Relic
var relic_label: Label
var relic_ui: RelicUI
var v_box: VBoxContainer
var relic_bought = false
var is_selected = false
var is_dragging = false
var on_sell = false
var loot_slot = false
var show_descriptions = false
var is_upgrade = false
var generated = true
var current_state = state.DEFAULT
var last_state
var original_damage
var descriptions: Array = []
var scene: Stage

enum state {
	DEFAULT,
	STRENGHT,
}

func _input(event: InputEvent) -> void:
	if is_selected and event.is_action_pressed("Drag") and !is_dragging and item_ui:
		print("Clicked")
		is_dragging = true
		pressed.emit(item_ui, self)
		tooltip.hide()
	elif event.is_action_released("Drag") and is_dragging:
		print("Released")
		is_dragging = false
		released.emit(item_ui, self)
	elif is_selected and event.is_action_pressed("Drag") and relic and !relic_bought:
		print("Relic buy")
		relic_buy.emit(relic, self)
		relic_bought = true
	elif is_selected and event.is_action_pressed("Drag") and is_upgrade:
		upgrade_buy.emit(self)
	elif is_selected and event.is_action_pressed("RightClick"):
		if !on_sell:
			if Global.shown_sell_container:
				Global.shown_sell_container.hide()
			on_sell = true
			sell_container.show()
			Global.shown_sell_container = sell_container

func update(item_resource: InvItem):
	if !item_resource:
		unassign_item()
		return
	item_ui = ITEM_UI.instantiate()
	item_ui.export_item = item_resource.duplicate()
	item_ui.global_position = sprite_pos.global_position
	sprite_pos.add_child(item_ui)
	item_ui.on_ready()
	if item_ui.item is HealthBag and !loot_slot:
		gain_health.emit(item_ui)
	generated = false
	assign_item(item_ui)

func assign_item(new_item: ItemUI):
	item_ui = new_item
	item_ui.global_position = sprite_pos.global_position
	for description in item_ui.descriptions:
		if description:
			item_ui.remove_child(description)
			descriptions_container.add_child(description)
			description.show()
			descriptions.append(description)
	if item_ui.item is HealthBag and !loot_slot:
		gain_health.emit(item_ui)
	item_ui.descriptions.clear()
	if !loot_slot and scene:
		item_ui.item.apply(scene.enemy, scene)

func unassign_item():
	if !item_ui:
		return
	item_ui.queue_free()
	item_ui = null

func _on_mouse_entered() -> void:
	SoundManager.hover.play()
	select_texture.show()
	is_selected = true
	selected.emit(self)
	if item_ui and !item_ui.is_dragging:
		tooltip.show()

func _on_mouse_exited() -> void:
	select_texture.hide()
	is_selected = false
	unselected.emit(self)
	tooltip.hide()
