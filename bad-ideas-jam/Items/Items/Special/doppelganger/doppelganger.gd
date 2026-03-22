extends InvItem
class_name Doppelganger

var id = 1

func _use():
	if Global.last_used_item:
		print("Using Doppelganger, last used item: ", Global.last_used_item)
		var item = Global.used_items[Global.used_items.size() - id]
		if item is Doppelganger:
			id += 1
			_use()
		else:
			item.use(target, scene, sender)
