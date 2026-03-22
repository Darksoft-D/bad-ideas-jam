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
signal gain(item_ui: ItemUI)
signal gain_health(item_ui: ItemUI)

var item_ui: ItemUI
var is_selected = false
var is_dragging = false
var on_sell = false
var loot_slot = false
var generated = false
var current_state = state.DEFAULT
var last_state
var original_damage
var descriptions: Array = []

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
	elif is_selected and event.is_action_pressed("RightClick"):
		if !on_sell:
			if Global.shown_sell_container:
				Global.shown_sell_container.hide()
			on_sell = true
			sell_container.show()
			Global.shown_sell_container = sell_container

func update(item_resource: InvItem):
	if !item_resource:
		return
	item_ui = ITEM_UI.instantiate()
	item_ui.export_item = item_resource.duplicate()
	item_ui.global_position = sprite_pos.global_position
	sprite_pos.add_child(item_ui)
	item_ui.on_ready()
	if item_ui.item is HealthBag and !loot_slot:
		gain_health.emit(item_ui)
	assign_item(item_ui)

func assign_item(new_item: ItemUI):
	item_ui = new_item
	item_ui.global_position = sprite_pos.global_position
	for description in item_ui.descriptions:
		item_ui.remove_child(description)
		descriptions_container.add_child(description)
		description.show()
		descriptions.append(description)
	if loot_slot:
		if !generated:
			for i in descriptions.size()/2:
				descriptions[i].queue_free()
				descriptions.remove_at(i)
	generated = false
	apply()

func unassign_item():
	if !item_ui:
		return
	item_ui.queue_free()
	item_ui = null

func _on_mouse_entered() -> void:
	select_texture.show()
	is_selected = true
	selected.emit(self)
	if item_ui:
		tooltip.show()

func _on_mouse_exited() -> void:
	select_texture.hide()
	is_selected = false
	unselected.emit(self)
	tooltip.hide()

func show_state():
	match current_state:
		state.DEFAULT:
			strength_rect.hide()
		state.STRENGHT:
			strength_rect.show()

func apply():
	print("apply ", current_state)
	match current_state:
		state.STRENGHT:
			if !item_ui:
				return
			print(item_ui.item.damage)
			if item_ui.item.item_type == InvItem.type.ATTACK:
				print(item_ui.item.damage)
				item_ui.item.damage_multiplier = 2
				item_ui.strength_icon.show()
				change_state(state.DEFAULT)

func change_state(new_state: state):
	last_state = current_state
	if current_state == new_state:
		return
	current_state = new_state
	show_state()
	apply()
