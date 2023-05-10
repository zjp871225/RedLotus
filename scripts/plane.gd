extends Node2D

@onready var plane_sprite=$AnimatedSprite2D
@onready var fire=$fire1
@onready var plane=get_parent()
@onready var fury_timer = $"../fury_timer"
var max_x:int
var min_x:int 
var max_y:int
var min_y:int 
var shooting = true
var bullets
var bullet=preload("res://scenes/bullet.tscn")
var bullet_fury=preload("res://scenes/bullet_fury.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	# 初始化
	# 设置飞机动画状态
	# 获取游戏窗口大小，用于设置边界
#	plane_sprite.play("sprint")
	bullets = get_parent().get_node("bullets")
	var window_size = get_window().size
	min_x = 25
	max_x = window_size.x - 25
	min_y = 30
	max_y = window_size.y - 30
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pressed_key = key_input()
	shoot()
	key_check_release(pressed_key)

func clear_bullets():
	for bullet in bullets.get_children():
		bullet.queue_free()

func key_input():
	# 保存按下按钮并返回
	var pressed = ""
	plane.velocity = Vector2.ZERO
	if Global.hp > 0:
		if Input.is_action_pressed("ui_right"):
			plane.velocity.x += 1
			pressed = "ui_right"
			if Global.is_fury:
				plane_sprite.play("fury_right")
			else:
				plane_sprite.play("right")
		if Input.is_action_pressed("ui_left"):
			plane.velocity.x -= 1
			pressed = "ui_left"
			if Global.is_fury:
				plane_sprite.play("fury_left")
			else:
				plane_sprite.play("left")
		if Input.is_action_pressed("ui_up"):
			plane.velocity.y -= 1
			pressed = "ui_up"
			if Global.is_fury:
				plane_sprite.play("fury_idle")
			else:
				plane_sprite.play("idle")
		if Input.is_action_pressed("ui_down"):
			plane.velocity.y += 1
			pressed = "ui_down"
			if Global.is_fury:
				plane_sprite.play("fury_idle")
			else:
				plane_sprite.play("idle")
		if Input.is_action_just_pressed("fury") and \
			Global.power == Global.power_max and \
			not Global.is_fury:
			clear_bullets()
			Global.is_fury = true
			plane_sprite.play("fury_idle")
			fury_timer.start()
		# 创建虚构边界
		position.x = clamp(position.x, min_x, max_x)
		position.y = clamp(position.y, min_y, max_y)
		position += plane.velocity.normalized() * plane.speed
		return pressed
	
func key_check_release(press_key):
	if Global.hp > 0 and not plane.is_plane_init:
		if press_key:
			if Input.is_action_just_released(press_key):
				if Global.is_fury:
					plane_sprite.play("fury_idle")
				else:
					plane_sprite.play("idle")
		else:
			if Global.is_fury:
				plane_sprite.play("fury_idle")
			else:
				plane_sprite.play("idle")


func shoot():
	if Global.hp>0:
		if Global.is_fury:
			if Input.is_action_pressed("ui_select"):
				var count = bullets.get_child_count()
				print('count:',count)
				if count == 0:
					create_fury_bullet()
		else:
			if Input.is_action_pressed("ui_select") and shooting:
		#		create_normal_bullet()	
		#		create_double_bullet()
				create_sector_bullet()
				shooting = false
				$Timer.start()
		

func _on_timer_timeout():
	shooting = not shooting
	if shooting:
		$Timer.stop()
	pass # Replace with function body.
	

func create_fury_bullet():
	var node = bullet_fury.instantiate()
	Global.create_instance(bullets, bullet_fury, 
			fire.global_position,Vector2.ZERO, 0)
	return node

func create_normal_bullet():
	var node = bullet.instantiate()
	#node.position = Vector2(position.x-20, position.y)
	# 这里不能直接使用fire.position因为这是相对于父节点body的相对坐标
	# 需要使用全局坐标来添加
	node.direction = Vector2.UP
	node.position = fire.global_position
	bullets.add_child(node)

func create_double_bullet():
	for i in [-10, 10]:
		var bullet_position = Vector2(fire.global_position.x+i, fire.global_position.y)
		Global.create_instance(bullets, bullet, bullet_position,Vector2.UP, 0)

func create_sector_bullet():
	#扇形子弹,角度
	for degree in [-30,-15,0,15,30]:
		Global.create_instance(bullets, bullet, 
			fire.global_position,Vector2.UP, degree)


	
func _on_area_entered(area):
	if area.is_in_group("enemy_bullet") or area.is_in_group("enemy_health_bullet"):
		if Global.hp > 0:
#			hp -= area.get_parent().damage
			area.get_parent().sub()
			plane.hp_sub(area.get_parent().damage)
		if Global.hp == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			plane_sprite.play("dead")
			#等待发送信号后，执行后面语句，协程方式处理
			await plane_sprite.animation_finished
			get_parent()._player_dead()
			get_parent().queue_free()
	elif area.is_in_group("goods_add_blood"):
		print('吃血了',Global.hp)
		if Global.hp > 0 and Global.hp<=5:
			plane.hp_add(area.get_parent().add())
		pass

#func _on_animated_sprite_2d_animation_finished():
#	if plane_sprite.animation == 'dead':
#		get_parent().queue_free() # Replace with function body.



