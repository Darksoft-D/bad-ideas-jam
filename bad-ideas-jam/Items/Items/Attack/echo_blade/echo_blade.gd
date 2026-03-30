extends InvItem

func _use():
	target.take_damage(damage)
	var item = scene.loot_manager.items.pick_random()
	while item is HealthBag:
		item = scene.loot_manager.items.pick_random()
	scene.insert_item(scene.loot_manager.items.pick_random())
