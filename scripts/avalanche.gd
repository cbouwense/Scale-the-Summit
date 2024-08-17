class_name Avalanche extends Area2D

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

@export var raycast_path: NodePath
@onready var raycast: RayCast2D = get_node(raycast_path)

func dump():
	if raycast.is_colliding():
		player.do_something(g.CardAction.DOWN)
