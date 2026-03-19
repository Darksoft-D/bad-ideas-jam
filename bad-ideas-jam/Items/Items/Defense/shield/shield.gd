extends InvItem

@export var block: InvItem

func _use():
	scene.insert_item(block)
