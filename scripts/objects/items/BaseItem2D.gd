extends Node2D
class_name BaseItem2D
## Имя класса
static var NAME = StringName("BaseItem2D")

@export_category("Node")
@export var area: Area2D

@export var item_id: String
@export var item_count: int = 1

## Создает объект предмета из сохранённых данных
static func create_from_save(save_data: SaveData) -> BaseItem2D:
	var item: BaseItem2D = load("res://scenes/objects/items/%s.tscn" % save_data.data["item_id"]).instantiate()
	item.set_save_data(save_data.data)
	return item

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func picked_up(_player: Node2D) -> void:
	queue_free()

# Возвращает словарь с данными об объекте
func as_dictionary() -> Dictionary:
	return {
		"item_id": item_id,
		"item_count": item_count
	}

func get_save_data() -> Dictionary:
	var data = as_dictionary()
	data["position"] = position
	return data

func set_save_data(data: Dictionary) -> void:
	position = data["position"]
	item_id = data["item_id"]
	item_count = data["item_count"]

func _on_body_entered(body: Node2D) -> void:
	if body.has_signal("item_collide"):
		body.item_collide.emit(self)
