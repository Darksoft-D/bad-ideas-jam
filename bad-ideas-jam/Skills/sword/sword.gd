extends Skill

func _use():
	target.take_damage(damage)
	var slot = scene.loot_manager.bag.get_empty_slot()
	if slot:
		slot.change_state(InvSlot.state.STRENGHT)
