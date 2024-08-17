extends Node

class_name g

enum CardAction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const player_starting_position = Vector2(8, -31)
const lava_starting_position = Vector2(0, -8)

static var selected_cards = []
@export var _selected_cards = selected_cards
