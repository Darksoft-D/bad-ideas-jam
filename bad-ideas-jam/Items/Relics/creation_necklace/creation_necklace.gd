extends Relic

var turn_count: int = 0

func _apply():
	print("apply")
	turn_count += 1
	if turn_count % 3 == 0:
		print("insert")
		var item = scene.loot_manager.items.pick_random()
		while item is HealthBag:
			item = scene.loot_manager.items.pick_random()
		scene.insert_item(scene.loot_manager.items.pick_random())
