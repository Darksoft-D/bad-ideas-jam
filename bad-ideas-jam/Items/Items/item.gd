extends Resource
class_name InvItem

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var texture_scale: Vector2 = Vector2(1, 1)
@export var skill: Skill
@export var cost: int = 0
@export var damage: int
@export var item_type: type
@export var disabled: bool = false
@export var free: bool = false
@export var strength_slot: bool = false
@export var temporary: bool = false

signal used

var damage_multiplier: int = 1
var effects: Array[Effect]
var double = false

enum type {
	DEFENSE,
	ATTACK,
	SPECIAL,
}

func assign_effect(get_effect: Effect):
	var effect = get_effect
	effects.append(effect)
	effect.apply(self)

func turn_end(get_target: Entity, get_scene: Node2D):
	if skill:
		skill.turn_end(get_target, get_scene)

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	if skill:
		var use_skill = skill.duplicate()
		if damage and use_skill.damage:
			print("Damage: ", damage, damage_multiplier)
			damage *= damage_multiplier
			use_skill.damage = damage
		use_skill.use(get_target, get_scene, get_sender)
		if double:
			use_skill.use(get_target, get_scene, get_sender)
		used.emit()
