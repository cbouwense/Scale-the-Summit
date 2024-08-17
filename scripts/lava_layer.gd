extends TileMapLayer

@export var player_path: NodePath
@onready var player = get_node(player_path)

@export var game_path: NodePath
@onready var game = get_node(game_path)

func _process(delta: float) -> void:
	if position.y < player.position.y:
		print("lose")
		#game.reset_game()
