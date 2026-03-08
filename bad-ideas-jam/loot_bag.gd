extends Bag

func _ready() -> void:
	is_loot_bag = true
	for child in grid_container.get_children():
		if child is InvSlot:
			slots.append(child)
	connect_slots()

func generate_loot(loot: Array[PackedScene]):
	for item in items_export:
		item = null
	var slots_number: Array[int] = []
	for i in range(items_export.size()):
		slots_number.append(i)
	for i in range(loot.size()):
		var id = slots_number.pick_random()
		slots_number.erase(id)
		items_export[id] = loot[i]
	update_slots()
