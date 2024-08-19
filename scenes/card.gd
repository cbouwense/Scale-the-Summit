class_name Card extends TextureButton

signal make_player_do_something

@export var action: g.CardAction
@export var is_selected: bool
@export var order_in_selection: int
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

func _process(delta):
	if order_in_selection > 0:
		$Order.text = str(order_in_selection)
	else:
		$Order.text = ""

func _on_pressed() -> void:
	if is_selected: # Deselecting
		var cards_with_higher_order_nums = card_manager.hand.get_children().filter(func(c: Card): return c.order_in_selection > order_in_selection)
		for card in cards_with_higher_order_nums:
			card.order_in_selection -= 1	
		order_in_selection = 0
	else: # Selecting
		order_in_selection = card_manager.selected_card_count + 1
	
	is_selected = !is_selected
