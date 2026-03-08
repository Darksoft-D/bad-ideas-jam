extends Resource
class_name Skill

@export var skill_name: String
@export var description: String
@export var damage: int

var target: Entity
var scene

func use(get_target: Entity, get_scene: Node2D):
	target = get_target
	scene = get_scene
	_use()

func turn_end(get_target: Entity, get_scene: Node2D):
	target = get_target
	scene = get_scene
	_turn_end()

func _use():
	pass

func _turn_end():
	pass
