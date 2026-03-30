extends InvItem

func _turn_end():
	var items = scene.loot_manager.bag.get_items()
	for item in items:
		if item.item.skill == self:
			items.erase(item)
	if items.is_empty():
		return
	var item = items.pick_random()
	scene.loot_manager.bag.remove_item(item)
	damage += 8

func _use():
	target.take_damage(damage, sender)
