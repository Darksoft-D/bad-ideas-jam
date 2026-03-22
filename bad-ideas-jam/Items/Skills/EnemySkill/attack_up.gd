extends Skill

@export var texture: Texture2D

const DEFENSE_UP_ANIM = preload("uid://cm1fdy3uag5o3")

func _use():
	sender.damage_multiplier = 2
	var defense_up_anim = DEFENSE_UP_ANIM.instantiate()
	defense_up_anim.texture = texture
	defense_up_anim.global_position = sender.global_position
	scene.add_child(defense_up_anim)
