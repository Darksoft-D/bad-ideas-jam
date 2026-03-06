extends Node2D

@export var enemies: Array[PackedScene]

@onready var loot_manager: LootManager = $LootManager
@onready var enemy_pos: Node2D = $EnemyPos
@onready var player: Player = $Player
@onready var gold_amount_label: Label = $CanvasLayer/HBoxContainer/GoldAmountLabel
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var combat_layer: CanvasLayer = $CombatLayer
@onready var chest: Chest = $Visuals/Chest

var enemy: Entity
var enemies_defeated: int = 0

func _ready() -> void:
	loot_manager.looting_finished.connect(Callable(self, "spawn_enemy"))
	loot()
	Global.gold_changed.connect(func():
		gold_amount_label.text = str(Global.gold_amount))
	player.died.connect(Callable(self, "on_player_died"))
	if !Global.bring_items.is_empty():
		print("Bring items", Global.bring_items)
		loot_manager.bag.items_export = []
		loot_manager.bag.items_export = Global.bring_items
		loot_manager.bag.update_slots()
	for slot in loot_manager.bag.slots:
		slot.gain.connect(Callable(self, "on_gain"))

func on_gain(item_ui: ItemUI):
	if item_ui.item is Block:
		player.blocks.append(item_ui.item)

func loot():
	combat_layer.hide()
	chest.show()
	chest.disabled = false
	chest.animated_sprite_2d.play("default")

func player_turn():
	print("Player turn")
	loot_manager.player_turn = true
	loot_manager.item_used = false
	enemy.before_attack(self)

func enemy_turn():
	print("Enemy Turn")
	loot_manager.player_turn = false
	enemy.attack()

func insert_item(item_scene: PackedScene):
	var empty_slot = loot_manager.bag.get_empty_slot()
	if empty_slot:
		empty_slot.update(item_scene)

func spawn_enemy():
	enemy = enemies.pick_random().instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	enemy.player = player
	enemy.died.connect(Callable(self, "on_enemy_died"))
	enemy.attacked.connect(Callable(self, "player_turn"))
	player_turn()

func on_enemy_died():
	enemy.attacked.disconnect(player_turn)
	enemy.died.disconnect(on_enemy_died)
	enemy.queue_free()
	enemies_defeated += 1
	loot_manager.generate_loot()

func on_player_died():
	combat_layer.hide()
	loot_manager.loot_container.hide()
	loot_manager.bag.hide()
	game_over_screen.show()
	
func _on_end_turn_button_pressed() -> void:
	if loot_manager.player_turn:
		enemy_turn()

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Shop/shop.tscn")
