extends InvItem

var collected_damage = 0

func _use():
	var items = scene.bag.get_items()
	var health_bags = scene.bag.get_health_bags()
	for i in range(items.size()+health_bags.size()):
		collected_damage += damage
	damage = collected_damage
	target.take_damage(damage, sender)
