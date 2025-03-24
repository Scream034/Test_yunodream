extends Object
class_name Inventory

var items: Dictionary = {}

static func from_dictionary(data: Dictionary) -> Inventory:
	var inventory = Inventory.new()
	inventory.items = data
	return inventory

func add(item: BaseItem2D) -> void:
	if item.item_id in items:
		items[item.item_id].item_count += item.item_count
	else:
		items[item.item_id] = item.as_dictionary()

func remove(item: BaseItem2D) -> void:
	if item.item_id in items:
		items[item.item_id].item_count -= item.count
	else:
		items[item.item_id] = item.as_dictionary()

	if items[item.item_id].item_count <= 0:
		items.erase(item.item_id)

func get_item_count(id: String) -> int:
	return items[id].item_count if id in items else 0

func get_item(id: String) -> BaseItem2D:
	return items[id]

func as_dictionary() -> Dictionary:
	return items
