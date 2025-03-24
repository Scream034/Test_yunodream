extends BaseCharacter2D
class_name PlayerCharacter2D

## При столкновении с предметом
signal item_collide(item: BaseItem2D)

## После получения предмета
signal picked_up(item: BaseItem2D)

## После перезагрузки игры (точнее самого объекта игрока)
signal reloaded

@export_category("Node")
@export var camera: Camera2D

@export_category("Movement")
@export var walking_speed: float = 3000

@export_category("Inventory")
var inventory: Inventory = Inventory.new()

var input_direction: Vector2: set = _set_input_direction

## Создает объект игрока из сохранённых данных
static func create_from_save(save_data: SaveData) -> PlayerCharacter2D:
	var player = load("res://scenes/objects/characters/player.tscn").instantiate()
	player.set_save_data(save_data.data)
	return player

func _ready() -> void:
	input_direction = Vector2.ZERO
	current_direction = Direction.LEFT

	item_collide.connect(_on_item_collide)

func _physics_process(delta: float) -> void:
	handler_movement(delta)
	move_and_slide()

## Обрабатывает движение персонажа
func handler_movement(delta: float) -> void:
	# Используем стандарт по движению персонажа
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").round()
	if input_direction.x != 0 and input_direction.y != 0:
		input_direction.x = 0

	velocity = input_direction * walking_speed * delta

## Устанавливает данные из сохранённых данных
func set_save_data(data: Dictionary) -> void:
	position = data["position"]
	current_direction = data["current_direction"]
	camera.position = data["camera_position"]
	inventory = Inventory.from_dictionary(data["inventory"])
	reloaded.emit()

## Возвращает данные для сохранения
func get_save_data() -> Dictionary:
	return {
		"position": position,
		"camera_position": camera.position,
		"current_direction": current_direction,
		"inventory": inventory.as_dictionary()
	}

func _set_input_direction(value: Vector2) -> void:
	input_direction = value

	if value != Vector2.ZERO:
		current_direction = Direction.RIGHT if value.x > 0 else Direction.LEFT if value.x < 0 else Direction.DOWN if value.y > 0 else Direction.UP
	
	super._update_movement_animations()

## При столкновение с предметом, пытается добавить предмет в инвентарь
func _on_item_collide(item: BaseItem2D) -> void:
	inventory.add(item)
	item.picked_up(self)
	picked_up.emit(item)
