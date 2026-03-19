extends InvItem
class_name Block

@export var value: int

signal send_damage(damage: int)
signal took_damage
signal destroyed

func _condition() -> bool:
	return false

func take_damage(taken_damage: int):
	print("blocking")
	value -= taken_damage
	took_damage.emit()
	if value < 0:
		send_damage.emit(-value)
		value = 0
		destroyed.emit()
	else:
		send_damage.emit(0)
