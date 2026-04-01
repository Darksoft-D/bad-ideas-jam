extends Resource
class_name Relic

@export var name: String
@export var description: String
@export var texture: Texture2D
@export var cost: int

var scene: Stage
var relic_base: RelicUI

func assign(get_scene: Stage):
	scene = get_scene
	_assign()

func apply():
	_apply()

func combat_start():
	_combat_start()

func _combat_start():
	pass

func _apply():
	pass

func _assign():
	pass
