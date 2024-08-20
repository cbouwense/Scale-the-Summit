class_name Player extends Node2D

@onready var ray_cast_2d_up: RayCast2D = $Area2D/CollisionShape2D/RayCast2DUp
@onready var ray_cast_2d_down: RayCast2D = $Area2D/CollisionShape2D/RayCast2DDown
@onready var ray_cast_2d_left: RayCast2D = $Area2D/CollisionShape2D/RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $Area2D/CollisionShape2D/RayCast2DRight

var game_is_won = false

func _ready():
	position = g.player_starting_position

func _process(delta):
	if not $"..".is_intro_running:
		var new_level: int
		var text: String
		if position.y > -80:
			new_level = 1
			text = "Build combos to scale the summit.\nThe blizzard rumbles beneath you..."
		elif position.y > -240:
			new_level = 2
			text = "Reached level 2!\nThe blizzard approaches..."
		elif position.y > -416:
			new_level = 3
			text = "Reached level 3!\nThe blizzard doubles it pace..."
		elif position.y > -576:
			new_level = 4
			text = "Reached level 4!\nGood luck..."
		else:
			if !game_is_won:
				game_is_won = true
				$"..".win()
		
		if g.level < new_level:
			await $"../CardManager".display_notification(text, 5)
		g.level = new_level

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

func play_animation():
	$AnimatedSprite2D.play("default")

func stop_animation():
	$AnimatedSprite2D.stop()
