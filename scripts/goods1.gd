extends Node2D

var direction = Vector2.ZERO
@onready var animate_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animate_sprite.play("default")
	pass # Replace with function body.

func add()->int:
	# 加血
	return 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
	pass # Replace with function body.

