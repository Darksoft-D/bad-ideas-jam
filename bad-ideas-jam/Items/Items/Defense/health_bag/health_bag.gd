extends InvItem
class_name HealthBag

@export var value: int

signal destroyed
signal took_damage

func _condition() -> bool:
	return false

func take_damage(taken_damage: int):
	value -= taken_damage
	if value <= 0:
		value = 0
		destroyed.emit()
	else:
		took_damage.emit()
