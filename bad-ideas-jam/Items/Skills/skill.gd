extends Resource
class_name Skill

@export var skill_name: String
@export var description: String
@export var damage: int
@export var effect: Effect

var target: Entity
var sender: Entity
var scene

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	target = get_target
	scene = get_scene
	sender = get_sender
	_use()

func turn_end(get_target: Entity, get_scene: Node2D):
	target = get_target
	scene = get_scene
	_turn_end()

func condition(get_scene: Node2D) -> bool:
	return true

func _use():
	pass

func _turn_end():
	pass
