extends Button

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

func _on_button_up() -> void:
	card_manager.play_cards()
