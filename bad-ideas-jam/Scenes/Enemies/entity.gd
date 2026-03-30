extends Node2D
class_name Entity

@export var max_health: int = 1
@export var attack_skills: Array[Skill]
@export var debuffs: Array[Skill]

signal died
signal attacked
signal took_damage

const DAMAGE_LABEL = preload("uid://bofywx1j6fpv0")

var player: Player
var health: int
var damage_multiplier: float = 1
var next_skill: Skill
var is_dead = false
var apply_debuff = false
var block = false
var scene: Node2D
var id = 0

func _ready() -> void:
	health = max_health

func take_damage(damage: int, _attacker: Entity = null):
	if block:
		var damage_label = DAMAGE_LABEL.instantiate()
		damage_label.scale *= 0.3
		add_child(damage_label)
		damage_label.global_position = Vector2(global_position.x, global_position.y - 50)
		damage_label.text = str("Block")
		damage_label.add_theme_color_override("font_color", Color.WHITE)
		block = false
		return
	SoundManager.hit.play()
	health -= damage
	if health <= 0:
		is_dead = true
		health = 0
		died.emit()
	took_damage.emit()

func before_attack(get_scene: Node2D):
	next_skill = attack_skills.pick_random().duplicate()
	id = randi_range(0, 1)
	if id == 0:
		apply_debuff = true
	scene = get_scene

func attack():
	if !is_dead:
		next_skill.damage_multiplier = damage_multiplier
		next_skill.use(player, scene, self)
		if apply_debuff and !debuffs.is_empty():
			debuffs.pick_random().use(player, scene, self)
			apply_debuff = false
	attacked.emit()
