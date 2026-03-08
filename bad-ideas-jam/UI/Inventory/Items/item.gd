extends Resource
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
@export var skill: Skill
@export var cost: int = 0
@export var disabled: bool = false
@export var damage: int
@export var item_type: type
signal used

var damage_multiplier: int = 1

enum type {
	HEALTH,
	ATTACK,
}

func use(get_target: Entity, get_scene: Node2D):
	if skill:
		if damage and skill.damage:
			print("Damage: ", damage, damage_multiplier)
			damage *= damage_multiplier
			skill.damage = damage
		skill.use(get_target, get_scene)
		used.emit()
