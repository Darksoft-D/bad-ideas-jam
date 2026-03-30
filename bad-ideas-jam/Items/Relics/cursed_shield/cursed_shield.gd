extends Relic

const STRENGTH_EFFECT = preload("uid://ctx3y68dk30rd")

func _assign():
	scene.player.took_damage.connect(Callable(self, "on_player_took_damage"))

func on_player_took_damage():
	var item = scene.bag.get_attack_items().pick_random()
	item.assign_effect(STRENGTH_EFFECT)
