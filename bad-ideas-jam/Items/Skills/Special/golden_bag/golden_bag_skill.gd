extends Skill

func _use():
	Global.gold_amount += randi_range(1, 20)
	Global.gold_changed.emit()
