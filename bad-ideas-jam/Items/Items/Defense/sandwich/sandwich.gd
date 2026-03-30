extends InvItem

func _use():
	var negative_items = []
	for slot: InvSlot in scene.bag.slots:
		if slot.item_ui and slot.item_ui.item.item_type == InvItem.type.NEGATIVE:
			negative_items.append(slot.item_ui)
	for item in negative_items:
		scene.bag.remove_item(item)
	
