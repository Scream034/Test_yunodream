extends CharacterBody2D
class_name BaseCharacter2D
## Имя класса
static var NAME = StringName("BaseCharacter2D")

enum Direction {LEFT, RIGHT, UP, DOWN}

@export_category("Node")
@export var animation: AnimationPlayer

var current_direction: Direction

## Обновляет анимации движения
func _update_movement_animations() -> void:
	match current_direction:
		Direction.LEFT:
			if velocity == Vector2.ZERO:
				_play_animation("idle_left")
			else:
				_play_animation("move_left")
		
		Direction.RIGHT:
			if velocity == Vector2.ZERO:
				_play_animation("idle_right")
			else:
				_play_animation("move_right")
		
		Direction.UP:
			if velocity == Vector2.ZERO:
				_play_animation("idle_up")
			else:
				_play_animation("move_up")
		
		Direction.DOWN:
			if velocity == Vector2.ZERO:
				_play_animation("idle_down")
			else:
				_play_animation("move_down")

func _play_animation(animation_name: String) -> void:
	animation.play(animation_name)
	await animation.animation_finished