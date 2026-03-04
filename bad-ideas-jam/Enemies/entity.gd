extends Node2D
class_name Entity

@export var max_health: int = 1
@export var skills: Array[Skill]

@onready var hp_bar: ProgressBar = $HPBar

signal died
signal attacked

var player: Player
var health: int
var next_skill: Skill
var is_dead = false
var scene: Node2D

func _ready() -> void:
	health = max_health
	hp_bar.max_value = max_health
	hp_bar.value = health

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		is_dead = true
		health = 0
		died.emit()
	hp_bar.value = health

func before_attack(get_scene: Node2D):
	next_skill = skills.pick_random()
	scene = get_scene

func attack():
	if !is_dead:
		next_skill.use(player, scene)
	attacked.emit()
