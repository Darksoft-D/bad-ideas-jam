extends InvItem
class_name Chaos

var real_damage = 0

func _turn_end():
	var items = scene.loot_manager.bag.get_items()
	for item in items:
		if item.item is Chaos:
			items.erase(item)
	if items.is_empty():
		return
	var item = items.pick_random()
	scene.loot_manager.bag.remove_item(item)
	real_damage += damage

func _use():
	damage = real_damage
	target.take_damage(damage, sender)
