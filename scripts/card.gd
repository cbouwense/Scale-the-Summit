class_name Card extends Button

signal make_player_do_something
signal card_selected

@export var action: g.CardAction #= g.CardAction.RIGHT

#var player_path: NodePath
var player: Player# = get_node(player_path)

#var card_manager_path: NodePath
var card_manager: CardManager#= get_node(card_manager_path)

func initialize(_player: Player, _card_manager: CardManager):
	player = _player
	card_manager = _card_manager
	# Connect the signal to a method on the player
	connect("make_player_do_something", player.do_something)
	connect("card_selected", card_manager.add_card_to_selected)
	
	match action:
		g.CardAction.UP:
			text = "^"
		g.CardAction.DOWN:
			text = "v"
		g.CardAction.LEFT:
			text = "<"
		g.CardAction.RIGHT:
			text = ">"


func _on_button_down() -> void:
	# Have it be selected for either "Play" or "Discard"
	card_selected.emit(self)
