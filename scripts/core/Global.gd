extends Node

var save_manager: SaveManager = SaveManager.new("res://save.data")

func _ready() -> void:
	load_game()

func quit_game() -> void:
	print("Quitting game...")
	DisplayServer.dialog_show("Уведомление", "Сохранить игру?", ["Да", "Нет"], Callable(self, "_on_dialog_save_game"))

func save_game() -> void:
	print("Saving game...")
	save_manager.save()

func load_game() -> void:
	print("Loading game...")
	save_manager.load()
	
func pause_game() -> void:
	print("Pausing game...")
	get_tree().paused = true

func unpause_game() -> void:
	print("Unpausing game...")
	get_tree().paused = false

func _on_dialog_save_game(result: int) -> void:
	print("Dialog result: ", result)

	if result == 0:
		save_game()
	
	get_tree().quit()