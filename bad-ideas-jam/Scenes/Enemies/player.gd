extends Entity
class_name Player

@onready var bag_sprite: Sprite2D = $BagSprite

var health_bags: Array[HealthBag]
var min_bag: HealthBag
var resistance: float = 1.0
var reflect = false
var sender
var total_health = 0

var float_height := 1.0   # how high it moves
var float_speed := 5.0     # speed of floating
var start_y := 0.0
var time := 0.0

func _ready():
	start_y = bag_sprite.position.y

func _process(delta):
	var t = Time.get_ticks_msec() / 1000.0
	bag_sprite.position.y = start_y + sin(t * float_speed) * float_height

func get_total_health() -> int:
	total_health = 0
	for bag in health_bags:
		if bag:
			total_health += bag.value
	return total_health

func take_damage(damage: int, attacker: Entity = null):
	sender = attacker
	if sender and reflect:
		print("Reflect")
		sender.take_damage(damage, self)
		reflect = false
		return
	damage *= resistance
	if health_bags.is_empty():
		died.emit()
		return
	min_bag = health_bags[0]
	if health_bags.size() > 1:
		for i in range(health_bags.size()):
			if health_bags[i].value < min_bag.value:
				min_bag = health_bags[i]
	print(min_bag)
	min_bag.destroyed.connect(Callable(self, "on_health_bag_destroyed"))
	min_bag.take_damage(damage)
	var damage_label = DAMAGE_LABEL.instantiate()
	damage_label.scale *= 0.3
	add_child(damage_label)
	damage_label.global_position = Vector2(global_position.x, global_position.y - 50)
	damage_label.text = str(damage)
	took_damage.emit()

func on_health_bag_destroyed():
	health_bags.erase(min_bag)
	min_bag.destroyed.disconnect(on_health_bag_destroyed)
	if health_bags.size() <= 0:
		died.emit()
		queue_free()

func get_max_bag() -> InvItem:
	var max_bag = health_bags[0]
	if health_bags.size() > 1:
		for i in range(health_bags.size()):
			if health_bags[i].value > max_bag.value:
				max_bag = health_bags[i]
	return max_bag
