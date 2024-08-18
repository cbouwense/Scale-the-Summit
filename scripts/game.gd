extends Node2D

@export var player_path: NodePath
@onready var player = get_node(player_path)

@export var card_manager_path: NodePath
@onready var card_manager: CardManager = get_node(card_manager_path)

@export var lava_layer_path: NodePath
@onready var lava_layer = get_node(lava_layer_path)

@export var intro_cam_path: NodePath
@onready var intro_cam: Camera2D
@export var main_cam: Camera2D
@export var intro_path_follow: PathFollow2D
#@onready var intro_path_follow: PathFollow2D

var is_intro_running = true 

func reset_game():
	player.position = g.player_starting_position
	lava_layer.position = g.lava_starting_position
	card_manager.reset()

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta):
	if is_intro_running and intro_path_follow:
		print(intro_path_follow.progress_ratio)
		if intro_path_follow.progress_ratio < 0.99:
			intro_path_follow.progress_ratio += 0.15 * delta
		else:
			main_cam.set_enabled(true)
			main_cam.make_current()
			is_intro_running = false
			card_manager.start_game()
