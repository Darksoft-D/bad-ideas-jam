extends InvItem

@export var attack_items: Array[PackedScene]

func _use():
	for i in 3:
		scene.insert_item(attack_items.pick_random())
