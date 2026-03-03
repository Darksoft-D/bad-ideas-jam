extends Resource
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
@export var skill: Skill

signal used

func use(get_target: Entity):
	skill.use(get_target)
	used.emit()
