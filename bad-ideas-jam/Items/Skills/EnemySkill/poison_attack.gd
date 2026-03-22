extends Skill

@export var poison: InvItem

func _use():
	scene.insert_item(poison)
