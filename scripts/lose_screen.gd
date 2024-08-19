extends Control

@onready var died_label = $VBoxContainer/DiedLabel
@onready var play_again_button = $VBoxContainer/PlayAgainButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	died_label.modulate.a = 0
	died_label.show()
	var tween = get_tree().create_tween()
	tween.tween_property(died_label, "modulate:a", 1, 3)
	await tween.finished
	play_again_button.show()
	main_menu_button.show()
	
	
func _on_play_again_button_button_down():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
