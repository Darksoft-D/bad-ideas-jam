extends InvItem
class_name Block

@export var value: int

signal send_damage(damage: int)
signal took_damage
signal destroyed

func take_damage(damage: int):
	print("blocking")
	value -= damage
	took_damage.emit()
	if value < 0:
		send_damage.emit(-value)
		value = 0
	else:
		send_damage.emit(0)
