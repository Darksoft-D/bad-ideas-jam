extends Inv
class_name LootInv

func generate_loot(loot: Array[InvItem]):
	for item in items:
		item = null
	var slots: Array[int] = []
	for i in range(items.size()):
		slots.append(i)
	slots.shuffle()
	for i in range(loot.size()):
		var id = slots[i]
		items[id] = loot[i]
