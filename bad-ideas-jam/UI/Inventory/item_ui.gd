extends TextureRect
class_name ItemUI

@export var item: InvItem

@onready var value_label: Label = $ValueLabel

signal used(item_ui: ItemUI)

var is_dragging = false

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

func assign_item(get_item: InvItem):
	if get_item:
		item = get_item
		texture = get_item.texture
		item.used.connect(func():
			used.emit(self))
		if item is HealthBag or item is Block:
			value_label.text = str(item.value)
			value_label.show()
			item.took_damage.connect(func():
				value_label.text = str(item.value))
			item.destroyed.connect(func():
				used.emit(self))
