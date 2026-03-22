extends InvItem

@export var health_bag: InvItem

func _use():
	var health =health_bag.duplicate()
	health.value = randi_range(5 ,15)
	scene.insert_item(health)
	scene.update_health()
