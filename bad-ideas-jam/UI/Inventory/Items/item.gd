extends Resource
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
@export var skill: Skill
@export var cost: int = 0

signal used

func use(get_target: Entity, get_scene: Node2D):
	if skill:
		skill.use(get_target, get_scene)
		used.emit()
