extends InvItem

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	damage = Global.gold_amount / 4
	get_target.take_damage(damage * damage_multiplier)
	Global.gold_amount -= damage
	Global.gold_changed.emit()
	used.emit()
