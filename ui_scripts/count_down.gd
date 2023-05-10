extends Label

var msg = ["  3", "  2", "  1", "GO!"]
var index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if index < msg.size():
		text = msg[index]
	index += 1
	if index > msg.size():
		text = ''
		$Timer.stop()
		get_tree().paused = false
	pass # Replace with function body.
