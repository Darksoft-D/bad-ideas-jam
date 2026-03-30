extends InvItem

func _use():
	var manager = scene.loot_manager
	manager.turns += 1
	manager.turns_num_label.text = str(manager.turns) + "/" + str(manager.max_turns)
