extends Sprite2D
class_name ItemUI

@export var item_export: InvItem

@onready var value_label: Label = $ValueLabel
@onready var strength_icon: Sprite2D = $StrengthIcon
@onready var tween_property: TweenProperty = $TweenAnimation/TweenProperty
@onready var tween_property_2: TweenProperty = $TweenAnimation/TweenProperty2
@onready var effects_container: HBoxContainer = $EffectsContainer
@onready var item_description: VBoxContainer = $ItemDescription
@onready var name_label: Label = $ItemDescription/NameLabel
@onready var type_label: Label = $ItemDescription/TypeLabel
@onready var description_label: RichTextLabel = $ItemDescription/DescriptionLabel

signal used(item_ui: ItemUI)

const EFFECT_DESCRIPTION_BASE = preload("uid://cffit6ssy7346")

var descriptions: Array[VBoxContainer]
var is_dragging = false
var item: InvItem
var original_scale

func _ready() -> void:
	assign_item(item_export)
	var center_pos = Vector2(0, 0)
	effects_container.position = center_pos - texture.get_size() / 2

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
		assign_descriptions()
		if item is HealthBag or item is Block:
			value_label.text = str(item.value)
			value_label.show()
			item.took_damage.connect(func():
				await scale_up()
				value_label.text = str(item.value)
				scale_down())
			item.destroyed.connect(func():
				used.emit(self))

func assign_descriptions():
	name_label.text = item.name
	type_label.text = InvItem.type.find_key(item.item_type)
	description_label.text = item.description
	descriptions.append(item_description)
	if item.skill and item.skill.effect:
		var effect_description: EffectDescription = EFFECT_DESCRIPTION_BASE.instantiate()
		add_child(effect_description)
		descriptions.append(effect_description)
		effect_description.assign_effect(item.skill.effect)
		effect_description.hide()

func assign_effect(effect: Effect):
	item.assign_effect(effect)
	var texture_rect = TextureRect.new()
	effects_container.add_child(texture_rect)
	texture_rect.texture = effect.texture
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH

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
