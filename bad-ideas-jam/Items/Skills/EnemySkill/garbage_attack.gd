extends Skill

@export var garbage: InvItem

func _use():
	target.take_damage(damage)
	scene.insert_item(garbage)
