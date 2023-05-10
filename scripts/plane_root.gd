extends Node2D

signal sub_hp(hp:int)
signal add_hp(hp:int)
signal player_dead
signal power_sub(val:int)
var speed=6
var velocity = Vector2.ZERO
var is_plane_init = true
@onready var sprite = $body/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("sprint")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hp_sub(hp:int):
	emit_signal("sub_hp", hp)

func hp_add(hp:int):
	emit_signal("add_hp",hp)

func _player_dead():
	emit_signal("player_dead")


func _on_path_2d_plane_init():
	is_plane_init = false
	pass # Replace with function body.


func _on_fury_timer_timeout():
	if Global.power <= 0:
		$fury_timer.stop()
		Global.power = 0
		Global.is_fury = false
		for bullet in $bullets.get_children():
			bullet.queue_free()
	else:
		emit_signal("power_sub", Global.power_max/10)
	pass # Replace with function body.
