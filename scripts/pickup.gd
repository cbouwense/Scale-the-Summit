extends Area2D

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

func _on_area_entered(area: Area2D) -> void:
	card_manager.add_new_card_to_deck(g.CardAction.UP)
	await get_tree().create_timer(.1).timeout # Sleep
	card_manager.display_notification("+1 UP CARD")
	queue_free()
