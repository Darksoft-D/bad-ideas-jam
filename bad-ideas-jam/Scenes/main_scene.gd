extends Node2D

@export var enemies: Array[PackedScene]

@onready var loot_manager: LootManager = $LootManager
@onready var enemy_pos: Node2D = $EnemyPos

var enemy: Entity
var enemies_defeated: int = 0

func _ready() -> void:
	loot_manager.looting_finished.connect(Callable(self, "spawn_enemy"))
	loot_manager.generate_loot()

func spawn_enemy():
	enemy = enemies.pick_random().instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	enemy.died.connect(Callable(self, "on_enemy_died"))

func on_enemy_died():
	enemy.queue_free()
	enemies_defeated += 1
	loot_manager.generate_loot()
