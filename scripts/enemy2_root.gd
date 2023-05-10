extends Node2D

var direction=Vector2.DOWN
var screenSize
signal update_score(score:int)
# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_tree_exiting():
	if $Timer.is_inside_tree():
		$Timer.start() # Replace with function body.

func _on_timer_timeout():
	queue_free() # Replace with function body.

func _update_score(score:int):
	emit_signal("update_score",score)
