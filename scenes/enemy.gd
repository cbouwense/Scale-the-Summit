class_name Enemy extends Area2D

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

@export var raycast_path: NodePath
@onready var raycast: RayCast2D = get_node(raycast_path)

@export var raycast2_path: NodePath
@onready var raycast2: RayCast2D = get_node(raycast2_path)

@export var raycast3_path: NodePath
@onready var raycast3: RayCast2D = get_node(raycast3_path)

@export var raycast4_path: NodePath
@onready var raycast4: RayCast2D = get_node(raycast4_path)

func attack():
	$Hitbox.visible = true
	$Hitbox2.visible = true
	$Hitbox3.visible = true
	$Hitbox4.visible = true
			
	await get_tree().create_timer(.5).timeout # Sleep
	if raycast.is_colliding():
		player.do_something(g.CardAction.DOWN)
	if raycast2.is_colliding():
		player.do_something(g.CardAction.DOWN)
	if raycast3.is_colliding():
		player.do_something(g.CardAction.DOWN)
	if raycast4.is_colliding():
		player.do_something(g.CardAction.DOWN)
	await get_tree().create_timer(.5).timeout # Sleep

	$Hitbox.visible = false
	$Hitbox2.visible = false
	$Hitbox3.visible = false
	$Hitbox4.visible = false
