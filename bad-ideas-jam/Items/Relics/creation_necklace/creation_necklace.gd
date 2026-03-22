extends Relic

var turn_count: int = 0

func _apply():
	print("apply")
	turn_count += 1
	if turn_count % 3 == 0:
		print("insert")
		scene.insert_item(scene.loot_manager.items.pick_random())
