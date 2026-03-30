extends Skill

@export var garbage: InvItem

func _use():
	target.take_damage(damage, sender)
	scene.insert_item(garbage)
