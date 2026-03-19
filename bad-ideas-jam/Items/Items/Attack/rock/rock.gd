extends InvItem

func _use():
	target.take_damage(damage, sender)
