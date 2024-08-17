class_name Player extends Node2D

func _ready():
	position = g.player_starting_position

func do_something(action: g.CardAction):
	match action:
		g.CardAction.UP:
			position.y -= 16
		g.CardAction.DOWN:
			if position.y < -1:
				position.y += 16
		g.CardAction.LEFT:
			if position.x >= -8:
				position.x -= 16
		g.CardAction.RIGHT:
			if position.x <= 24:
				position.x += 16

	# Did we reach the goal
	if position.y <= -140:
		position = g.player_starting_position
