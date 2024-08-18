class_name Avalanche extends Area2D

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

@export var raycast_path: NodePath
@onready var raycast: RayCast2D = get_node(raycast_path)

func dump():
	for child in get_children():
		if child is AnimatedSprite2D:
			child.sprite_frames.set_animation_speed('default', 45)
			
	await get_tree().create_timer(.5).timeout # Sleep
	if raycast.is_colliding():
		player.do_something(g.CardAction.DOWN)
	await get_tree().create_timer(.5).timeout # Sleep
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.sprite_frames.set_animation_speed('default', 5)
