extends Node

var save_manager: SaveManager = SaveManager.new("res://save.data")

func change_level(level_name: String) -> void:
	get_tree().change_scene_to_file(level_name)

func quit_game() -> void:
	get_tree().quit()

func save_game() -> void:
	save_manager.save()

func load_game() -> void:
	save_manager.load()

func pause_game() -> void:
	get_tree().paused = true

func unpause_game() -> void:
	get_tree().paused = false
