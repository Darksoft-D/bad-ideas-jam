extends InvItem

func _condition() -> bool:
	var items = scene.loot_manager.bag.get_items()
	var has_attack_only = true
	for item in items:
		if item.item.item_type != InvItem.type.ATTACK:
			has_attack_only = false
	return has_attack_only

func _use():
	target.take_damage(damage)
