extends ItemUI

@export var health_value: int = 20

func _assign_item():
	item.value = health_value
