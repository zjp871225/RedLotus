extends "res://scripts/move.gd"

#造成伤害
var damage = 1
var health_damage = 5
@onready var animate_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animate_sprite.play("default")
	speed = 260
	velocity = speed * direction
#	print('子弹创建',velocity) 
	pass # Replace with function body.

func add():
	# 子弹的加血功能
	Global.hp += health_damage

func sub():
	# 子弹的减血功能
	Global.hp -= damage


func _on_visible_on_screen_notifier_2d_screen_exited():
#	print('子弹飞出')
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
#		area.get_parent().hp -= damage
		queue_free()
	elif area.is_in_group("boss"):
		queue_free()
	pass # Replace with function body.
