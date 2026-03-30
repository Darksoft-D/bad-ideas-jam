extends Bag

func _ready() -> void:
	connect_slots()
	#for child in grid_container.get_children():
		#if child is InvSlot:
			#slots.append(child)
			#child.loot_slot = true

func generate_loot(loot: Array[InvItem]):
	print("Generating loot")
	for item in items_resource:
		item = null
	var slots_number: Array[int] = []
	for i in range(items_resource.size()):
		slots_number.append(i)
	for i in range(loot.size()):
		var id = slots_number.pick_random()
		slots_number.erase(id)
		items_resource[id] = loot[i]
	update_slots()
