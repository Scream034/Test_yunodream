extends Control
class_name PlayerMenuGUI

@export var start_button: BaseButton
@export var save_button: BaseButton
@export var load_button: BaseButton
@export var exit_button: BaseButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		toggle_menu()

## Переключает видимость меню
func toggle_menu() -> void:
	if visible:
		hide_menu()
	else:
		show_menu()

## Показывает меню
func show_menu() -> void:
	visible = true
	Global.pause_game()

## Скрывает меню
func hide_menu() -> void:
	visible = false
	Global.unpause_game()

func _on_start_button_pressed() -> void:
	hide_menu()

func _on_save_button_pressed() -> void:
	hide_menu()
	Global.save_game()

func _on_load_button_pressed() -> void:
	hide_menu()
	Global.load_game()

func _on_exit_button_pressed() -> void:
	Global.quit_game()
