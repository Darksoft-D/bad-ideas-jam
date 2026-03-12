extends Sprite2D
class_name ItemUI

@export var item_export: InvItem

@onready var value_label: Label = $ValueLabel
@onready var strength_icon: Sprite2D = $StrengthIcon
@onready var tween_property: TweenProperty = $TweenAnimation/TweenProperty
@onready var tween_property_2: TweenProperty = $TweenAnimation/TweenProperty2

signal used(item_ui: ItemUI)

var is_dragging = false
var item: InvItem
var original_scale

func _ready() -> void:
	assign_item(item_export)

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

func assign_item(get_item: InvItem):
	if get_item:
		item = get_item.duplicate()
		texture = get_item.texture
		scale = item.texture_scale
		original_scale = scale
		strength_icon.scale = Vector2(1, 1) / item.texture_scale
		item.used.connect(func():
			used.emit(self))
		_assign_item()
		if item is HealthBag or item is Block:
			value_label.text = str(item.value)
			value_label.show()
			item.took_damage.connect(func():
				await scale_up()
				value_label.text = str(item.value)
				scale_down())
			item.destroyed.connect(func():
				used.emit(self))

func scale_up():
	var new_scale = scale * 1.2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", new_scale, 0.2).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.kill()

func scale_down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale, 0.2).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.kill()

func _assign_item():
	pass
