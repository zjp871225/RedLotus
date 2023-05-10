extends Node2D

var screenSize
var direction=Vector2.DOWN
@export var hp = 10000.0
var hp_max = hp
signal update_score(score:int)
signal boss_hp_change(hp_ratio:float)
signal boss_dead
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

func _boss_hp_sub():
	var ratio = hp / hp_max
	if ratio < 0:
		ratio = 0
	emit_signal("boss_hp_change", ratio)

func _boss_hp_add():
	print(hp)
	print(hp_max)
	var ratio = hp / hp_max
	print(ratio)
	if ratio > 1:
		ratio = 1
	emit_signal("boss_hp_change", ratio)

func _boss_dead():
	emit_signal("boss_dead")
