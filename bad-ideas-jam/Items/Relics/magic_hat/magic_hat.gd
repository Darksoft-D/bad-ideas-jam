extends Relic

func _assign():
	scene.loot_manager.max_turns += 1

func _combat_start():
	var item = scene.bag.get_items().pick_random()
	scene.bag.remove_item(item)
