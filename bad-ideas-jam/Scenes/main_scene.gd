extends Node2D

@export var enemies: Array[PackedScene]

@onready var loot_manager: LootManager = $LootManager
@onready var enemy_pos: Node2D = $EnemyPos
@onready var player: Player = $Player
@onready var gold_amount_label: Label = $CanvasLayer/HBoxContainer/GoldAmountLabel
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var combat_layer: CanvasLayer = $CombatLayer
@onready var chest: Chest = $Visuals/Chest
@onready var enemy_attack_pos: Node2D = $EnemyAttackPos
@onready var turn_label: Label = $CombatLayer/TurnLabel
@onready var turns_num_label: Label = $CombatLayer/VBoxContainer/TurnsNumLabel
@onready var camera: Camera2D = $Camera2D
@onready var player_health_container: HBoxContainer = $CombatLayer/PlayerHealthContainer
@onready var enemy_health_container: HBoxContainer = $CombatLayer/EnemyHealthContainer
@onready var health_label_player: Label = $CombatLayer/PlayerHealthContainer/TotalHealthBagsLabel
@onready var health_label_enemy: Label = $CombatLayer/EnemyHealthContainer/TotalHealthBagsLabel

var enemy: Entity
var enemies_defeated: int = 0
var is_player_turn = false
var is_enemy_moving = false
var gold_amount: int = 0

func _ready() -> void:
	var canvas_pos = player.get_global_transform_with_canvas().origin
	player_health_container.position = canvas_pos + Vector2(-30, -80)
	var canvas_pos2 = enemy_pos.get_global_transform_with_canvas().origin
	enemy_health_container.position = canvas_pos2 + Vector2(-30, -80)
	player.health_bags.append(loot_manager.bag.slots[0].item_ui)
	enemy_health_container.hide()
	loot_manager.looting_finished.connect(Callable(self, "spawn_enemy"))
	loot()
	gold_amount = Global.gold_amount
	gold_amount_label.text = str(Global.gold_amount)
	Global.gold_changed.connect(func():
		gold_amount_label.text = str(Global.gold_amount)
		gold_amount = Global.gold_amount)
	player.died.connect(Callable(self, "on_player_died"))
	if !Global.bring_items.is_empty():
		print("Bring items", Global.bring_items)
		loot_manager.bag.items_export = []
		loot_manager.bag.items_export = Global.bring_items
		loot_manager.bag.update_slots()
	for slot in loot_manager.bag.slots:
		slot.gain.connect(Callable(self, "on_gain"))
	player.took_damage.connect(Callable(self, "update_health"))

func _process(delta: float) -> void:
	if is_enemy_moving:
		var canvas_pos = enemy_pos.get_global_transform_with_canvas().origin
		enemy_health_container.global_position = canvas_pos + Vector2(-30, -80)

func update_health():
	health_label_player.text = str(player.get_total_health())

func update_enemy_health():
	if enemy:
		health_label_enemy.text = str(enemy.health)

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
	update_health()
	await show_turn("Player Turn")
	is_player_turn = true
	loot_manager.player_turn = true
	loot_manager.item_used = false
	loot_manager.turns = loot_manager.max_turns
	turns_num_label.text = str(loot_manager.turns) + "/" + str(loot_manager.max_turns)
	enemy.before_attack(self)

func enemy_turn():
	print("Enemy Turn")
	update_enemy_health()
	loot_manager.player_turn = false
	is_player_turn = false
	await show_turn("Enemy Turn")
	await attack_anim()
	enemy.attack()
	await return_anim()

func insert_item(item_scene: PackedScene):
	var empty_slot = loot_manager.bag.get_empty_slot()
	if empty_slot:
		print(item_scene)
		empty_slot.update(item_scene)

func spawn_enemy():
	enemy = enemies.pick_random().instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	enemy.player = player
	enemy.died.connect(Callable(self, "on_enemy_died"))
	enemy.attacked.connect(Callable(self, "player_turn"))
	enemy.took_damage.connect(Callable(self, "update_enemy_health"))
	enemy_health_container.show()
	update_enemy_health()
	player_turn()

func on_enemy_died():
	enemy.attacked.disconnect(player_turn)
	enemy.died.disconnect(on_enemy_died)
	enemy.queue_free()
	enemies_defeated += 1
	loot_manager.generate_loot()
	for slot in loot_manager.bag.slots:
		if slot.item_ui and slot.item_ui.item.temporary:
			slot.unassign_item()
	enemy_health_container.hide()

func on_player_died():
	combat_layer.hide()
	loot_manager.loot_container.hide()
	loot_manager.bag.hide()
	game_over_screen.show()

func attack_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "global_position", enemy_attack_pos.global_position, 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(enemy_health_container, "global_position", 
	enemy_attack_pos.get_global_transform_with_canvas().origin + Vector2(-30, -80), 0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	tween.kill()

func return_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "global_position", enemy_pos.global_position, 0.2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(enemy_health_container, "global_position", 
	enemy_pos.get_global_transform_with_canvas().origin + Vector2(-30, -80), 0.2).set_ease(Tween.EASE_IN)
	await tween.finished
	tween.kill()
	is_enemy_moving = false

func show_turn(text: String):
	turn_label.text = text
	turn_label.scale = Vector2.ZERO
	turn_label.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(turn_label, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(turn_label, "scale", Vector2(1.2,1.2), 0.2)
	tween.tween_property(turn_label, "scale", Vector2.ONE, 0.1)
	tween.tween_interval(1.0)
	tween.tween_property(turn_label, "modulate:a", 0.0, 0.3)
	await tween.finished

func _on_end_turn_button_pressed() -> void:
	if !is_player_turn:
		return
	for slot in loot_manager.bag.slots:
		if slot.item_ui:
			slot.item_ui.item.turn_end(player, self)
	if loot_manager.player_turn:
		enemy_turn()

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Shop/shop.tscn")
