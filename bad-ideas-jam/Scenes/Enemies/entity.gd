extends Node2D
class_name Entity

@export var max_health: int = 1
@export var skills: Array[Skill]

signal died
signal attacked
signal took_damage

var player: Player
var health: int
var next_skill: Skill
var is_dead = false
var scene: Node2D

func _ready() -> void:
	health = max_health

func take_damage(damage: int, _attacker: Entity = null):
	health -= damage
	if health <= 0:
		is_dead = true
		health = 0
		died.emit()
	took_damage.emit()

func before_attack(get_scene: Node2D):
	next_skill = skills.pick_random()
	scene = get_scene

func attack():
	if !is_dead:
		next_skill.use(player, scene, self)
	attacked.emit()
