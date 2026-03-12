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

enum type {
	DEFENSE,
	ATTACK,
	SPECIAL,
}

func turn_end(get_target: Entity, get_scene: Node2D):
	if skill:
		skill.turn_end(get_target, get_scene)

func use(get_target: Entity, get_scene: Node2D, get_sender: Entity):
	if skill:
		if damage and skill.damage:
			print("Damage: ", damage, damage_multiplier)
			damage *= damage_multiplier
			skill.damage = damage
		skill.use(get_target, get_scene, get_sender)
		used.emit()
