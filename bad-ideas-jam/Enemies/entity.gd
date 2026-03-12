extends Node2D
class_name Entity

@export var max_health: int = 1
@export var skills: Array[Skill]

@onready var total_health_bags_label: Label = $HBoxContainer/TotalHealthBagsLabel

signal died
signal attacked

var player: Player
var health: int
var next_skill: Skill
var is_dead = false
var scene: Node2D

func _ready() -> void:
	health = max_health
	total_health_bags_label.text = str(max_health)

func update_health():
	total_health_bags_label.text = str(health)

func take_damage(damage: int, _attacker: Entity = null):
	health -= damage
	if health <= 0:
		is_dead = true
		health = 0
		died.emit()
	update_health()

func before_attack(get_scene: Node2D):
	next_skill = skills.pick_random()
	scene = get_scene

func attack():
	if !is_dead:
		next_skill.use(player, scene, self)
	attacked.emit()
