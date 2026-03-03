extends Resource
class_name Skill

@export var skill_name: String
@export var description: String

var target: Entity

func use(get_target: Entity):
	target = get_target
	_use()

func _use():
	pass
