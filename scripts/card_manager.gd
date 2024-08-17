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
@onready var lava_layer = get_node(lava_layer_path)

@onready var card_scene = preload("res://scenes/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_deck()
	reset()

func initialize_deck():
	for card in deck.get_children():
		card.initialize(player, self)

func add_card_to_selected(card):
	print("poopae")
	if g.selected_cards.has(card):
		g.selected_cards.erase(card)
	else:
		g.selected_cards.push_back(card)

func shuffle_cards():
	var cards_in_deck = deck.get_children()
	cards_in_deck.shuffle()
	for i in range(cards_in_deck.size()):
		deck.move_child(cards_in_deck[i],i)
		
func draw_card():
	if deck.get_child_count() > 0: # If the deck has cards available
		deck.get_child(0).reparent(hand) # then move the next card from the deck to the hand
	else: # Deck is empty
		# Put all the discard cards into the deck again
		for child in discard.get_children():
			child.reparent(deck)
		
		shuffle_cards()
		
		# At this point we now have cards in the deck, so call draw_card recursively to continue
		draw_card()

func play_cards():
	for card in g.selected_cards:
		card.make_player_do_something.emit(card.action)
		
		# Move from hand to the Discard
		card.reparent(discard)
		card.set_pressed(false)
		
		# Sleep
		await get_tree().create_timer(.2).timeout
	
	g.selected_cards.clear()

func discard_cards() -> void:
	var selected_len = g.selected_cards.size()
	for card in g.selected_cards:
		# Move from hand to the Discard
		card.reparent(discard)
		card.set_pressed(false)
		
		# Sleep
		await get_tree().create_timer(.2).timeout
		
	# Draw new cards from the deck
	for i in range(selected_len):
		# TODO: what if there are no more cards to draw?
		draw_card()
		
		# Sleep
		await get_tree().create_timer(.2).timeout
		
	g.selected_cards.clear()
	
	discard_button.set_disabled(true)

func end_turn() -> void:
	# Disable the action buttons while things are happening
	play_cards_button.set_disabled(true)
	discard_button.set_disabled(true)
	end_turn_button.set_disabled(true)
	
	# Move the lava up one tile
	lava_layer.position.y -= 16
	
	# Discard all cards from hand
	for card in hand.get_children():
		card.reparent(discard)
		card.set_pressed(false)
		
		# Sleep
		await get_tree().create_timer(.2).timeout
	
	draw_full_hand()

	# Re-enable buttons
	play_cards_button.set_disabled(false)
	discard_button.set_disabled(false)
	end_turn_button.set_disabled(false)

func draw_full_hand():
	# Draw cards from deck until full
	while hand.get_children().size() < 5:
		draw_card()
		
		# Sleep
		await get_tree().create_timer(.2).timeout

func reset() -> void:
	# Get all of the cards from the hand and put them back into the deck
	for card in hand.get_children():
		card.reparent(deck)
	for card in discard.get_children():
		card.reparent(deck)
	
	shuffle_cards()
	draw_full_hand()

func add_new_card_to_deck(action: g.CardAction):
	var new_card: Card = card_scene.instantiate()
	new_card.initialize(player, self)
	new_card.action = action
	
	deck.add_child(new_card)
