extends Area2D

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

func _on_area_entered(area: Area2D) -> void:
	print("poopini")
	card_manager.add_new_card_to_deck(g.CardAction.UP)
	queue_free()
