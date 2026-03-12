extends Skill

const ROCK = preload("uid://4uivwpgputqq")

func _use():
	for i in 3:
		scene.insert_item(ROCK)
