extends Control

var help_scene = preload("res://scenes/help_screen.tscn")

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_button_down():
	get_tree().quit()


func _on_help_button_button_down():
	var help_instance = help_scene.instantiate()
	add_child(help_instance)
