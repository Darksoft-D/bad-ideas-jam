extends InvItem

func _use():
	damage = Global.gold_amount / 4
	target.take_damage(damage * damage_multiplier)
	Global.gold_amount -= damage
	Global.gold_changed.emit()
	used.emit()
