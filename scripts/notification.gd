extends Label

var notification = "NO NOTIFICATION"

var display_seconds = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	text = notification
	modulate.a = 0
	show()
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.tween_property(self, "position:y", position.y - 100, .5)
	tween.set_parallel(false).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0, display_seconds)
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 150, display_seconds)
	await tween.finished
	queue_free()
