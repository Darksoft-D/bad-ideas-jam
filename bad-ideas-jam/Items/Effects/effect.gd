extends Resource
class_name Effect

@export var texture: Texture2D
@export var name: String = ""
@export var descripiption: String = ""

var item: InvItem

func apply(get_item: InvItem):
	item = get_item
	_apply()

func _apply():
	pass
