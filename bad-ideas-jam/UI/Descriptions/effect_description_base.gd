extends VBoxContainer
class_name EffectDescription

@onready var name_label: Label = $HBoxContainer/NameLabel
@onready var effect_icon: TextureRect = $HBoxContainer/EffectIcon
@onready var description_label: RichTextLabel = $DescriptionLabel

var effect: Effect

func assign_effect(get_effect: Effect):
	effect = get_effect
	name_label.text = effect.name
	description_label.text = effect.description
	effect_icon.texture = effect.texture
