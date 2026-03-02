extends Control
class_name InventorySlot

@onready var panel_container: PanelContainer = $PanelContainer
@onready var area: Area2D = $Area

var item: Item
var on_assign_item: Item
var can_take = false
var can_assign = false

func _input(event: InputEvent) -> void:
	if can_assign and event.is_action_released("Drag"):
		print("assign")
		can_assign = false
		assign_item()

func assign_item():
	item = on_assign_item
	item.original_position = global_position

func _on_area_body_entered(body: Node2D) -> void:
	print("entered")
	if !item and body is Item:
		print("can_assign")
		on_assign_item = body
		can_assign = true

func _on_area_mouse_entered() -> void:
	pass # Replace with function body.
