class_name CardManager extends Node

@export var player_path: NodePath
@onready var player = get_node(player_path)

@export var hand_path: NodePath
@onready var hand = get_node(hand_path)

@export var deck_path: NodePath
@onready var deck = get_node(deck_path)

@export var discard_path: NodePath
@onready var discard = get_node(discard_path)

@export var discard_button_path: NodePath
@onready var discard_button: Button = get_node(discard_button_path)

@export var play_cards_button_path: NodePath
@onready var play_cards_button: Button = get_node(play_cards_button_path)

@export var end_turn_button_path: NodePath
@onready var end_turn_button: Button = get_node(end_turn_button_path)

@export var lava_layer_path: NodePath
@onready var lava_layer: TileMapLayer = get_node(lava_layer_path)

@export var avalanche_path: NodePath
@onready var avalanche: Avalanche = get_node(avalanche_path)

@export var wind_path: NodePath
@onready var wind: Wind = get_node(wind_path)

@export var selected_card_count: int = 0

@onready var card_scene = preload("res://scenes/card.tscn")

const avalanche_x_positions = [-24, -8, 8, 24, 42]

func _process(delta):
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	selected_card_count = selected_cards.size()

# Called when the node enters the scene tree for the first time.
func start_game() -> void:
	initialize_deck()
	reset()
	discard_button.visible = true
	end_turn_button.visible = true

func initialize_deck():
	for card in deck.get_children():
		card.initialize(player, discard, self)

func shuffle_cards():
	var cards_in_deck = deck.get_children()
	cards_in_deck.shuffle()
	for i in range(cards_in_deck.size()):
		deck.move_child(cards_in_deck[i],i)
		
func draw_card(index = null):
	print("draw_card", index)
	if deck.get_child_count() > 0: # If the deck has cards available
		var top_card: Card = deck.get_child(0) # then move the next card from the deck to the hand
		top_card.order_in_selection = 0
		top_card.button_pressed = false
		top_card.reparent(hand)
		if index:
			hand.move_child(top_card, index)
			
			
	else: # Deck is empty
		# Put all the discard cards into the deck again
		for child in discard.get_children():
			child.reparent(deck)
		
		shuffle_cards()
		
		# At this point we now have cards in the deck, so call draw_card recursively to continue
		draw_card()

func play_cards():
	play_cards_button.set_disabled(true)
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	selected_cards.sort_custom(func(a: Card, b: Card): return a.order_in_selection < b.order_in_selection)
	for card in selected_cards:
		card.is_selected = false
		card.make_player_do_something.emit(card.action)
		card.reparent(discard) # Move from hand to the Discard
		await get_tree().create_timer(.2).timeout # Sleep
	play_cards_button.set_disabled(false)

func discard_cards() -> void:
	discard_button.set_disabled(true)
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	for card in selected_cards:
		# Move from hand to the Discard
		card.is_selected = false
		card.order_in_selection = 0
		card.reparent(discard)
		draw_card()
		
		# Sleep
		await get_tree().create_timer(.2).timeout

func end_turn() -> void:
	# Disable the action buttons while things are happening
	play_cards_button.set_disabled(true)
	discard_button.set_disabled(true)
	end_turn_button.set_disabled(true)
	
	# Discard all cards from hand
	for card in hand.get_children():
		card.is_selected = false
		card.order_in_selection = 0
	
	# Dump the avalanche
	await avalanche.dump()
	await get_tree().create_timer(.5).timeout # Sleep
	
	# Move avalanche to a random spot
	var x_diff
	if g.level == 1:
		x_diff = randi_range(-3, 3)
	elif g.level == 2:
		x_diff = randi_range(-3, 3)
	elif g.level == 3:
		x_diff = randi_range(-1, 1)
	elif g.level == 4:
		x_diff = randi_range(-1, 1)
	avalanche.position.x = (16 * x_diff) + 8
	await get_tree().create_timer(.5).timeout # Sleep
	
	# Gust the wind
	await wind.gust()
	await get_tree().create_timer(.5).timeout # Sleep
		
	# Move wind to a random spot
	var y_diff
	if g.level == 1:
		y_diff = randi_range(-3, 3)
	elif g.level == 2:
		y_diff = randi_range(0, 2)
	elif g.level == 3:
		y_diff = randi_range(-1, 1)
	elif g.level == 4:
		y_diff = randi_range(0, 1)
	wind.position.y = player.position.y - (16 * y_diff) - 8
	await get_tree().create_timer(1).timeout # Sleep
	
	# Move the lava up one tile
	lava_layer.position.y -= 16
	await get_tree().create_timer(.5).timeout # Sleep
	
	draw_full_hand()

	# Replenish discards
	g.discards_left_this_turn = 3

	# Re-enable buttons
	play_cards_button.set_disabled(false)
	discard_button.set_disabled(false)
	end_turn_button.set_disabled(false)

func draw_full_hand():
	# Draw cards from deck until full
	while hand.get_children().size() < 5:
		draw_card()
		
		await get_tree().create_timer(.2).timeout # Sleep

func reset() -> void:
	# Get all of the cards from the hand and put them back into the deck
	for card in hand.get_children():
		card.reparent(deck)
	for card in discard.get_children():
		card.reparent(deck)
	
	g.selected_cards.clear()
	shuffle_cards()
	draw_full_hand()

func add_new_card_to_deck(action: g.CardAction):
	var new_card: Card = card_scene.instantiate()
	new_card.initialize(player, discard, self)
	new_card.action = action
	deck.add_child(new_card)
