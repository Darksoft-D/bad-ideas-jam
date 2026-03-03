extends Node2D
class_name Entity

@export var max_health: int = 1

@onready var hp_bar: ProgressBar = $HPBar

signal died

var health: int

func _ready() -> void:
	health = max_health
	hp_bar.max_value = max_health
	hp_bar.value = health

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		health = 0
		died.emit()
	hp_bar.value = health
