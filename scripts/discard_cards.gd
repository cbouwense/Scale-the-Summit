extends Button

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

func _on_button_up() -> void:
	if g.selected_cards.is_empty():
		return
	card_manager.discard_cards()
