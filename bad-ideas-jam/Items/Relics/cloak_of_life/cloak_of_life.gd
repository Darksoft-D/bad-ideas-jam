extends Relic

func _assign():
	var item = scene.bag.get_max_health_bag().item
	item.value += 10
	scene.bag.get_max_health_bag().value_label.text = str(item.value)
	scene.update_health()
