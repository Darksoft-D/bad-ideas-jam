extends Skill

func _turn_end():
	target.take_damage(damage)
