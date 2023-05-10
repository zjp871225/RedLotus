extends "res://scripts/move.gd"

#造成伤害
var damage = 50
@onready var animate_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animate_sprite.play("default")
	velocity = speed * direction
#	print('子弹创建',velocity)
	pass # Replace with function body.

func add(hp:int)->int:
	# 子弹的加血功能
	return hp + damage

func sub(hp:int)->int:
	# 子弹的减血功能
	return hp - damage

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("boss"):
#		area.get_parent().hp -= damage
		queue_free()
	pass # Replace with function body.
