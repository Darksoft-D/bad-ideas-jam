extends InvItem

func _use():
	scene.player.get_max_bag().take_damage(-5)
	scene.update_health()
