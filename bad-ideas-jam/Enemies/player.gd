extends Entity
class_name Player

var health_bags: Array[HealthBag]
var blocks: Array[Block]
var min_bag: HealthBag
var min_block: Block

func take_damage(damage: int):
	print(health_bags)
	print(blocks)
	if blocks.size() > 0:
		block_damage(damage)
		return
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

func block_damage(damage):
	print("block")
	min_block = blocks[0]
	if blocks.size() > 1:
		for i in range(blocks.size()):
			if blocks[i].value < min_block.value:
				min_block = blocks[i]
	min_block.send_damage.connect(Callable(self, "on_block_damage_receive"))
	min_block.take_damage(damage)

func on_block_damage_receive(damage: int):
	blocks.erase(min_block)
	take_damage(damage)
	min_block.destroyed.emit()

func on_health_bag_destroyed():
	health_bags.erase(min_bag)
	min_bag.destroyed.disconnect(on_health_bag_destroyed)
	if health_bags.size() <= 0:
		died.emit()
		queue_free()
