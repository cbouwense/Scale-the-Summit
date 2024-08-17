extends Node2D

@export var player_path: NodePath
@onready var player = get_node(player_path)

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

@export var lava_layer_path: NodePath
@onready var lava_layer = get_node(lava_layer_path)

func reset_game():
	player.position = g.player_starting_position
	lava_layer.position = g.lava_starting_position
	card_manager.reset()
