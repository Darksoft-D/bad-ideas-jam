extends InvItem

func _use():
	target.take_damage(damage)
	scene.insert_item(scene.loot_manager.items.pick_random())
