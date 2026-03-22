extends Resource
class_name Relic

@export var name: String
@export var description: String
@export var texture: Texture2D

var scene: Stage

func assign(get_scene: Stage):
	scene = get_scene
	_assign()

func apply():
	_apply()

func _apply():
	pass

func _assign():
	pass
