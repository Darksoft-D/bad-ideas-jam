extends Skill

@export var block: PackedScene

func _use():
	scene.insert_item(block)
