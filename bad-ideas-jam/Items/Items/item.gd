extends Resource
class_name InvItem

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var effect: Effect
@export var cost: int = 0
@export var damage: int
@export var item_type: type
@export var disabled: bool = false
@export var free: bool = false
@export var temporary: bool = false

signal used

var damage_multiplier: int = 1
var effects: Array[Effect]
var double = false
var is_applied = false
var target: Entity
var scene: Node2D
var sender: Entity

enum type {
	DEFENSE,
	ATTACK,
	SPECIAL,
}

func get_description(desc: String) -> String:
	var values = {
		"{damage}": "[color=red]%d Damage[/color]" % damage,
		"{strength}": "[color=orange] Strength [/color]",
		
	}
	for key in values:
		desc = desc.replace(key, values[key])
	return desc

func assign_effect(get_effect: Effect):
	var assigned_effect = get_effect
	effects.append(assigned_effect)
	assigned_effect.apply(self)

func condition(get_scene: Node2D) -> bool:
	scene = get_scene
	return _condition()

func apply(get_target: Entity, get_scene: Node2D):
	if is_applied:
		return
	is_applied = true
	target = get_target
	scene = get_scene
	_apply()

func unapply(get_target: Entity, get_scene: Node2D):
	if !is_applied:
		return
	is_applied = false
	target = get_target
	scene = get_scene
	_unapply()

func turn_end(get_target: Entity, get_scene: Node2D):
	target = get_target
	scene = get_scene
	_turn_end()

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	target = get_target
	scene = get_scene
	sender = get_sender
	_use()
	used.emit()

func _condition() -> bool:
	return true

func _apply():
	pass

func _unapply():
	pass

func _turn_end():
	pass

func _use():
	pass
