extends Skill

func condition(get_scene: Node2D) -> bool:
	scene = get_scene
	var items = scene.loot_manager.bag.get_items()
	var has_attack_only = true
	for item in items:
		if item.item.item_type != InvItem.type.ATTACK:
			has_attack_only = false
	return has_attack_only

func _use():
	target.take_damage(damage)
