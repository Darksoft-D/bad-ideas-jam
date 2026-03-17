extends InvItem
class_name TweenItem

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	var items = get_scene.loot_manager.bag.get_items()
	for item in items:
		if item.item is TweenItem:
			damage += 4
	damage *= damage_multiplier
	get_target.take_damage(damage, get_sender)
	used.emit()
