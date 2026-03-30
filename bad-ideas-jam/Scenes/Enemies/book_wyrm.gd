extends Entity

@onready var attack_up_texture: TextureRect = $AttackUpTexture
@onready var defense_up_texture: TextureRect = $DefenseUpTexture
@onready var attack_up_container: PanelContainer = $AttackUpTexture/AttackUpContainer
@onready var defense_up_container: PanelContainer = $DefenseUpTexture/DefenseUpContainer

var is_attack_up = false
var is_defense_up = false

func _process(delta: float) -> void:
	if is_attack_up:
		attack_up_container.global_position = get_global_mouse_position() + Vector2(10, 10)
	if is_defense_up:
		defense_up_container.global_position = get_global_mouse_position() + Vector2(10, 10)

func attack():
	if next_skill is AttackUp:
		defense_up_texture.hide()
		attack_up_texture.show()
	elif next_skill is DefenseUp:
		defense_up_texture.show()
		attack_up_texture.hide()
	else:
		defense_up_texture.hide()
		attack_up_texture.hide()
	if !is_dead:
		next_skill.damage_multiplier = damage_multiplier
		next_skill.use(player, scene, self)
		if apply_debuff and !debuffs.is_empty():
			debuffs.pick_random().use(player, scene, self)
			apply_debuff = false
	attacked.emit()

func _on_attack_up_texture_mouse_entered() -> void:
	attack_up_container.show()
	is_attack_up = true

func _on_attack_up_texture_mouse_exited() -> void:
	attack_up_container.hide()
	is_attack_up = false

func _on_defense_up_texture_mouse_entered() -> void:
	defense_up_container.show()
	is_defense_up = true

func _on_defense_up_texture_mouse_exited() -> void:
	defense_up_container.hide()
	is_defense_up = false
