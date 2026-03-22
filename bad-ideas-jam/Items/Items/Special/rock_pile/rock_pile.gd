extends InvItem

@export var rock: InvItem

func _use():
	for i in 3:
		scene.insert_item(rock)
