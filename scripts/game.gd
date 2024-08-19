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

var result_scene = preload("res://scenes/result_screen.tscn")
var help_scene = preload("res://scenes/help_screen.tscn")

var is_intro_running = true 

func reset_game():
	player.position = g.player_starting_position
	lava_layer.position = g.lava_starting_position
	card_manager.reset()

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta):
	if intro_path_follow and is_intro_running:
		if intro_path_follow.progress_ratio < 0.99:
			intro_path_follow.progress_ratio += 0.15 * delta
		else:
			main_cam.set_enabled(true)
			main_cam.make_current()
			is_intro_running = false
			card_manager.start_game()

func lose():
	$Layer0.queue_free()
	$Avalanche.queue_free()
	$Wind.queue_free()
	$Pickups.queue_free()
	$Hazards.queue_free()
	var result_instance = result_scene.instantiate()
	result_instance.result = "YOU DIED"
	card_manager.add_child(result_instance)

func win():
	$Layer0.queue_free()
	$Avalanche.queue_free()
	$Wind.queue_free()
	$Pickups.queue_free()
	$Hazards.queue_free()
	var result_instance = result_scene.instantiate()
	result_instance.result = "YOU WIN"
	card_manager.add_child(result_instance)


func _on_help_button_button_down():
	var help_instance = help_scene.instantiate()
	card_manager.add_child(help_instance)


func _on_exit_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
