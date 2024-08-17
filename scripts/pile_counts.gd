extends Panel

@export var pile_path: NodePath
@onready var pile = get_node(pile_path)

@export var up_amount_path: NodePath
@onready var up_amount = get_node(up_amount_path)

@export var down_amount_path: NodePath
@onready var down_amount = get_node(down_amount_path)

@export var left_amount_path: NodePath
@onready var left_amount = get_node(left_amount_path)

@export var right_amount_path: NodePath
@onready var right_amount = get_node(right_amount_path)

func _process(delta: float) -> void:
	var up_card_count = pile.get_children().filter(func(c: Card): return c.action == g.CardAction.UP).size()
	var down_card_count = pile.get_children().filter(func(c: Card): return c.action == g.CardAction.DOWN).size()
	var left_card_count = pile.get_children().filter(func(c: Card): return c.action == g.CardAction.LEFT).size()
	var right_card_count = pile.get_children().filter(func(c: Card): return c.action == g.CardAction.RIGHT).size()

	up_amount.text = str(up_card_count)
	down_amount.text = str(down_card_count)
	left_amount.text = str(left_card_count)
	right_amount.text = str(right_card_count)
