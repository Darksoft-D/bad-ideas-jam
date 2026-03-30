extends InvItem

func _condition() -> bool:
	return false

func _turn_end():
	scene.enemy.take_damage(damage)
