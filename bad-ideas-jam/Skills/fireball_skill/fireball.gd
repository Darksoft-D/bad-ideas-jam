extends Skill

@export var damage: int = 4

func _use():
	target.take_damage(damage)
