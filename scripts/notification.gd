extends Label

var notification = "NO NOTIFICATION"

# Called when the node enters the scene tree for the first time.
func _ready():
	text = notification
	modulate.a = 0
	show()
	set_as_top_level(true)
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.tween_property(self, "position:y", position.y - 100, .5)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate:a", 0, 2)
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 150, 2)
	await tween.finished
	queue_free()
