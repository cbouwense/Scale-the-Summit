class_name Card extends TextureButton

signal make_player_do_something

@export var action: g.CardAction
var player: Player
var discard: Container
var card_manager: CardManager

func initialize(_player: Player, _discard: Container, _card_manager: CardManager):
	player = _player
	discard = _discard
	card_manager = _card_manager
	
	connect("make_player_do_something", player.do_something)
	
	match action:
		g.CardAction.UP:
			$Label.text = "^"
		g.CardAction.DOWN:
			$Label.text = "v"
		g.CardAction.LEFT:
			$Label.text = "<"
		g.CardAction.RIGHT:
			$Label.text = ">"

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			make_player_do_something.emit(action)
			reparent(discard)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if g.discards_left_this_turn > 0:
				g.discards_left_this_turn -= 1
				reparent(discard)
				await get_tree().create_timer(.2).timeout # Sleep
				card_manager.draw_card()
