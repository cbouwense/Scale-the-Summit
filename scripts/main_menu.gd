extends Control

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_button_down():
	get_tree().quit()
