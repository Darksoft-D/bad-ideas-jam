extends Skill

func _use():
	target.take_damage(damage, sender)
