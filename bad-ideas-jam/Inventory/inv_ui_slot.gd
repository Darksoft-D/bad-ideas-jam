extends Panel
class_name InvSlot

@onready var item_display: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var texture_rect: TextureRect = $CenterContainer/Panel/TextureRect

func update(item: InvItem):
	if !item:
		return
	texture_rect.texture = item.texture
