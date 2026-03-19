extends InvItem

func _turn_end():
	target.take_damage(damage)
