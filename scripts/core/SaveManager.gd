extends Object
class_name SaveManager

## Динамичное сохранение и загрузка игровых данных
## Может сохранять и загружать из любых состояний игры
## Есть более простой способ это загружать состояние игры после, например, нажатия "Играть". Но этот способ более гибкий, да и подходит под контекст

## Для того чтобы сохранить какой-то узел:
## 1. Добавить в глобальную группу "to_save" (GROUP_NAME)
## 2. Добавить метод `get_save_data() -> Dictionary`. Должен возвращать словарь с данными об объекте
## 3. (Опционально) Добавить метод `set_save_data(data: Dictionary)`. Позволяет более гибко управлять применением данных со сохранения
## 4. Добавить статический метод `create_from_save(save_data: SaveData) -> Node`. Используется для создания объекта из сохранённых данных

const GROUP_NAME = StringName("to_save")

var _file_path: String

func _init(file_path: String) -> void:
	_file_path = file_path

## Сохраняет текущее состояние игры
func save() -> void:
	var file := FileAccess.open(_file_path, FileAccess.WRITE)
	var data := {}

	# Сохранение узлов
	for node in Global.get_tree().get_nodes_in_group(GROUP_NAME):
		if node.has_method("get_save_data"):
			data[node.name] = SaveData.new(node.NAME, node.get_save_data(), node.get_path()).as_dictionary()
		else:
			push_error("Node %s doesn't have get_save_data() method" % node.name)
	
	file.store_var(data, true)

	file.close()

## Загружает сохранённые данные (восстанавливает состояние игры)
func load() -> void:
	if !FileAccess.file_exists(_file_path): # Проверяем, существует ли файл сохранения
		print("Save file not found: " + _file_path)
		return

	var file := FileAccess.open(_file_path, FileAccess.READ)
	var data = file.get_var(true)
	file.close()
	if data == null:
		return
	
	var scene_tree = Global.get_tree()

	for node in scene_tree.get_nodes_in_group(GROUP_NAME):
		node.queue_free()
	
	await scene_tree.process_frame

	for node_name in data.keys():
		var save_data: SaveData = SaveData.from_dictionary(data[node_name])

		var parent_path = save_data.path.slice(0, save_data.path.get_name_count() - 1)
		var parent_node = scene_tree.root.get_node_or_null(parent_path)
		if parent_node == null:
			push_error("Parent node %s not found" % save_data.path)
			continue

		var target_node = _create_node(save_data)
		parent_node.add_child(target_node)
		
		if target_node.has_method("set_save_data"):
			target_node.set_save_data(save_data.data)
		else:
			for key in save_data.data.keys():
				target_node.set(key, save_data.data[key])

## Создает узел из сохраненных данных
func _create_node(save_data: SaveData):
	var node: Node

	# Ищет через match возможные типы узлов
	# Но! Есть более элегантный способ, через простой массив, который создадим при запуске игры. Опять же данный способ подойдёт в большинтсве случаев
	match save_data.type:
		BaseItem2D.NAME:
			node = BaseItem2D.create_from_save(save_data)
		
		BaseCharacter2D.NAME:
			node = PlayerCharacter2D.create_from_save(save_data)
		
		_:
			push_error("Unknown type: " + save_data.type)
	
	node.add_to_group(GROUP_NAME) # Для системы сохранения)
	node.name = save_data.path.get_name(save_data.path.get_name_count() - 1)
	return node
