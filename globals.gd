extends Node

class_name g

enum CardAction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const player_starting_position = Vector2(8, 0)
const lava_starting_position = Vector2(0, 32)

static var discards_left_this_turn = 3
@export var _discards_left_this_turn = discards_left_this_turn

static var selected_cards = []
@export var _selected_cards = selected_cards
