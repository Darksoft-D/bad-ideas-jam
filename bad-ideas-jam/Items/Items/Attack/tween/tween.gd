extends InvItem
class_name TweenItem

func _use():
	var items = scene.loot_manager.bag.get_items()
	for item in items:
		if item.item is TweenItem:
			damage += 4
	damage *= damage_multiplier
	target.take_damage(damage, sender)
	used.emit()
