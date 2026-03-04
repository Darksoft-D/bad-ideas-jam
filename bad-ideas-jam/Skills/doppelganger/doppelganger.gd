extends Skill

func _use():
	if Global.last_used_item:
		Global.last_used_item.use(target, scene)
	
