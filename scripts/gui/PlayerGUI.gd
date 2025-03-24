extends CanvasLayer
class_name PlayerGUI

## Предмет который нужно отслеживать у игрока
const TARGET_ITEM_ID: String = "coin"

@export_category("Node")
@export var player: PlayerCharacter2D
@export var coins_label: Label

func _ready() -> void:
	player.picked_up.connect(_on_player_picked_up)
	player.reloaded.connect(_on_player_reloaded)

func _on_player_picked_up(item: BaseItem2D) -> void:
	if item.item_id == TARGET_ITEM_ID:
		coins_label.text = str(int(coins_label.text) + item.item_count)

func _on_player_reloaded() -> void:
	coins_label.text = str(player.inventory.get_item_count(TARGET_ITEM_ID))
