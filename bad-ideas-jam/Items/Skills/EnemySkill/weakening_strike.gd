extends Skill

func _use():
	target.take_damage(damage)
	var items = scene.loot_manager.bag.get_attack_items()
	if items.is_empty():
		return
	var item = items.pick_random()
	item.assign_effect(effect)
