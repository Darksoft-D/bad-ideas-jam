extends Skill

@export var min_damage: int
@export var max_damage: int

func _use():
	damage = randi_range(min_damage, max_damage)
	target.take_damage(damage)
