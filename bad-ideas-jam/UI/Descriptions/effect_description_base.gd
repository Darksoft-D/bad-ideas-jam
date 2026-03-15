extends VBoxContainer
class_name EffectDescription

@onready var name_label: Label = $NameLabel
@onready var description_label: Label = $DescriptionLabel

var effect: Effect

func assign_effect(get_effect: Effect):
	effect = get_effect
	name_label.text = effect.name
	description_label.text = effect.descripiption
