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
@onready var notification_scene = preload("res://scenes/notification.tscn")

const avalanche_x_positions = [-24, -8, 8, 24, 42]

var starting_deck = {
	g.CardAction.UP: 4,
	g.CardAction.DOWN: 4,
	g.CardAction.LEFT: 4,
	g.CardAction.RIGHT: 4
}

func _process(delta):
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	selected_card_count = selected_cards.size()

# Called when the node enters the scene tree for the first time.
func start_game() -> void:
	initialize_deck()
	reset()
	enable_actions()
	
func enable_actions():
	hand.visible = true
	play_cards_button.visible = true
	discard_button.visible = true
	end_turn_button.visible = true

func disable_actions():
	hand.visible = false
	play_cards_button.visible = false
	discard_button.visible = false
	end_turn_button.visible = false

func initialize_deck():
	for action in starting_deck:
		for _i in range(starting_deck[action]):
			add_new_card_to_deck(action)

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

func check_for_hand(hand):
	# draw 1 for pair
	# draw 2 for two pair
	# draw 3 for three of a kind
	# draw 4 for four of a kind
	# draw 5 for full house
	var counts = {}
	
	# Count occurrences of each element
	for value in hand:
		var action = value.action
		if counts.has(action):
			counts[action] += 1
		else:
			counts[action] = 1
	
	var has_four_of_a_kind = false
	var has_three_of_a_kind = false
	var has_pair = false
	var pairs = 0
	
	# Check for three of a kind and pair
	for key in counts:
		if counts[key] == 3:
			has_three_of_a_kind = true
		elif counts[key] == 2:
			has_pair = true
			pairs += 1
	
	var draws = 0
	# Determine hand type
	if has_three_of_a_kind and has_pair:
		display_notification("FULL HOUSE!\n+5 Draw")
		draws = 5
		await get_tree().create_timer(0.2).timeout
	elif has_four_of_a_kind:
		display_notification("FOUR OF A KIND!\n+4 Draw")
		draws = 4
		await get_tree().create_timer(0.2).timeout
	elif has_three_of_a_kind:
		display_notification("THREE OF A KIND!\n+3 Draw")
		draws = 3
		await get_tree().create_timer(0.2).timeout
	elif pairs == 2:
		display_notification("TWO PAIR!\n+2 Draw")
		draws = 2
		await get_tree().create_timer(0.2).timeout
	elif pairs == 1:
		display_notification("ONE PAIR!\n+1 Draw")
		draws = 1
		await get_tree().create_timer(0.2).timeout
	else:
		for i in range(1 * pairs):
			draws += 1
			display_notification("PAIR!\n+1 Draw")
			await get_tree().create_timer(0.2).timeout
		
	return draws

func play_cards():
	play_cards_button.set_disabled(true)
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	selected_cards.sort_custom(func(a: Card, b: Card): return a.order_in_selection < b.order_in_selection)
	for card in selected_cards:
		card.is_selected = false
		card.make_player_do_something.emit(card.action)
		card.reparent(discard) # Move from hand to the Discard
		await get_tree().create_timer(.2).timeout # Sleep
	var draws = await check_for_hand(selected_cards)
	for i in range(draws):
		draw_card()
		await get_tree().create_timer(.2).timeout # Sleep
	play_cards_button.set_disabled(false)

func discard_cards() -> void:
	var selected_cards = hand.get_children().filter(func(c: Card): return c.is_selected)
	if selected_cards.is_empty():
		return
	discard_button.set_disabled(true)
	for card in selected_cards:
		# Move from hand to the Discard
		card.is_selected = false
		card.order_in_selection = 0
		card.set_disabled(false)
		card.reparent(discard)
		draw_card()
		
		await get_tree().create_timer(.2).timeout # Sleep

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
	
	# Make enemies attack : ^ )
	for enemy: Enemy in $"../Enemies".get_children():
		enemy.attack()
	await get_tree().create_timer(.5).timeout # Sleep
	
	# Move the lava up (0 tiles on level 1, 1 on level 2, etc)
	lava_layer.position.y -= (16 * (g.level - 1))
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
	new_card.action = action
	new_card.initialize(player, discard, self)
	deck.add_child(new_card)

func display_notification(text: String, display_seconds: int = 2):
	if $Notifications.get_child_count() > 0:
		var current_notification = $Notifications.get_child(0)
		await current_notification.tree_exited
	var new_notification = notification_scene.instantiate()
	new_notification.notification = text
	new_notification.display_seconds = display_seconds
	$Notifications.add_child(new_notification)
	
