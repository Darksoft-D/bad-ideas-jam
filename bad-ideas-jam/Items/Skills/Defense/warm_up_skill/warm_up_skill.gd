extends Skill

func _use():
	var items = scene.loot_manager.bag.get_attack_items()
	for i in 3:
		if items.is_empty():
			return
		var item = items.pick_random()
		items.erase(item)
		item.assign_effect(effect)
