extends Resource
class_name InvItem

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var effect: Effect
@export var start_effect: Effect
@export var cost: int = 0
@export var damage: int
@export var item_type: type
@export var item_rarity: rarity
@export var disabled: bool = false
@export var free: bool = false
@export var temporary: bool = false

signal used

var damage_multiplier: float = 1
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

enum rarity {
	Common,
	Uncommon,
	Rare,
	Legendary
}

func get_type_text() -> String:
	var desc = ""
	match item_type:
		type.ATTACK: desc += "[color=red]%s[/color]"
		type.DEFENSE: desc += "[color=#5FA8FF]%s[/color]"
		type.SPECIAL: desc += "[color=green]%s[/color]"
	desc += ", "
	match item_rarity:
		rarity.Common: desc += "[color=white]%s[/color]"
		rarity.Uncommon: desc += "[color=lightgreen]%s[/color]"
		rarity.Rare: desc += "[color=red]%s[/color]"
		rarity.Legendary: desc += "[color=orange]%s[/color]"
	desc = desc % [type.find_key(item_type), rarity.find_key(item_rarity)]
	return desc

func get_description(desc: String) -> String:
	var values = {
		"{damage}": "[color=red]%d Damage[/color]" % damage,
		"{damage_up}": "[color=green]%d[/color] [color=red]Damage[/color]" % (damage*damage_multiplier),
		"{damage_down}": "[color=darkred]%d[/color] [color=red]Damage[/color]" % (damage*damage_multiplier),
		"{strength}": "[color=orange]Strength[/color]",
		"{double}": "[color=orange]Double[/color]",
		"{free}": "[color=orange]Free[/color]",
		"{attack}": "[color=lightgreen]Attack[/color]",
		"{health_bag}": "[color=green]Health Bag[/color]",
		"{gold}": "[color=yellow]Gold[/color]",
	}
	if damage_multiplier > 1:
		desc = desc.replace("{damage}", "{damage_up}")
	elif damage_multiplier < 1:
		desc = desc.replace("{damage}", "{damage_down}")
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
	damage *= damage_multiplier
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
