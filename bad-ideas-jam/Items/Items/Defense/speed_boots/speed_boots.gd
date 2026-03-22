extends InvItem

func _apply():
	print("apply")
	scene.loot_manager.max_turns += 1
	
func _unapply():
	scene.loot_manager.max_turns -= 1
