class_name Player extends Node2D

@onready var ray_cast_2d_up: RayCast2D = $Area2D/CollisionShape2D/RayCast2DUp
@onready var ray_cast_2d_down: RayCast2D = $Area2D/CollisionShape2D/RayCast2DDown
@onready var ray_cast_2d_left: RayCast2D = $Area2D/CollisionShape2D/RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $Area2D/CollisionShape2D/RayCast2DRight


func _ready():
	position = g.player_starting_position

func do_something(action: g.CardAction):
	match action:
		g.CardAction.UP:
			if !ray_cast_2d_up.is_colliding():
				position.y -= 16
		g.CardAction.DOWN:
			if !ray_cast_2d_down.is_colliding():
				position.y += 16
		g.CardAction.LEFT:
			if !ray_cast_2d_left.is_colliding():
				position.x -= 16
		g.CardAction.RIGHT:
			if !ray_cast_2d_right.is_colliding():
				position.x += 16

	# Did we reach the top?
	if position.y <= -592:
		print("win")
