extends Skill

@export var block: InvItem

func _use():
	block.value = 5
	scene.insert_item(block)
