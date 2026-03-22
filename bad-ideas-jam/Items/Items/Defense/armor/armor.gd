extends InvItem

func _condition() -> bool:
	return false

func _apply():
	scene.player.resistance -= 0.25

func _unapply():
	scene.player.resistance += 0.25
