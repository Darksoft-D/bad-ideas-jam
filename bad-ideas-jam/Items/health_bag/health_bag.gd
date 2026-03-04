extends InvItem
class_name HealthBag

@export var value: int

signal destroyed
signal took_damage

func take_damage(damage: int):
	value -= damage
	if value <= 0:
		value = 0
		destroyed.emit()
	else:
		took_damage.emit()
