extends Relic

func _assign():
	scene.enemy_died.connect(Callable(self, "on_enemy_died"))

func on_enemy_died():
	var item = scene.bag.get_max_health_bag().item
	item.value += 5
	scene.bag.get_max_health_bag().value_label.text = str(item.value)
	scene.update_health()
