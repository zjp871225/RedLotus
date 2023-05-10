extends Node2D

@onready var clear_timer=$"../Timer"
@onready var shoot_timer=$"../shoot_timer"
@onready var enemy_sprite=$AnimatedSprite2D
@onready var fire=$fire
@onready var path = get_parent().get_node("Path2D/PathFollow2D")
@onready var boss = get_parent()
var speed
var velocity
var direction
var max_x:int
var min_x:int 
var max_y:int
var min_y:int 
var shooting = false
var bullets
var screenSize
var bullet_enemy=preload("res://scenes/bullet_enemy.tscn")
# 生命值


var cur_node
# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化
	# 设置飞机动画状态
	# 获取游戏窗口大小，用于设置边界x
	print('BOSS位置：',global_position)
	print('fire位置：',fire.global_position)
	screenSize = get_viewport_rect().size
	speed=300
	velocity = Vector2.ZERO
	direction = Vector2.DOWN
	enemy_sprite.play("idle")
	bullets = get_parent().get_node("bullets")
	velocity = speed * direction
	create_sector_bullet()
	shoot_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	position += velocity*delta
#	path.progress_ratio += 0.3 * delta
	path.progress += 4
	if not shooting:
		shoot()
		shooting = true
		
	
func shoot():
	create_sector_bullet()
		
	
func create_normal_bullet():
	var node = bullet_enemy.instantiate()
	cur_node = node
	#node.position = Vector2(position.x-20, position.y)
	# 这里不能直接使用fire.position因为这是相对于父节点body的相对坐标
	# 需要使用全局坐标来添加
	node.global_position = fire.global_position
	node.speed = 500
	node.direction = Vector2.DOWN
#	print('子弹位置：',node.global_position)
	bullets.add_child(node)

func create_double_bullet():
	for i in [-10, 10]:
		var bullet_position = Vector2(fire.global_position.x+i, fire.global_position.y+10)
		Global.create_instance(bullets, bullet_enemy, bullet_position,Vector2.DOWN, 0)

func create_sector_bullet():
	#扇形子弹,角度
	var bullet_positon = fire.global_position
	for degree in [-30,-15,0,15,30]:
		Global.create_instance(bullets, bullet_enemy, 
			bullet_positon,Vector2.DOWN, degree)


func _on_area_entered(area):
	if area.is_in_group("bullet"):
		Global.score += 1000
		boss._update_score(100)
		if get_parent().hp > 0:
			get_parent().hp -= area.get_parent().damage
			get_parent()._boss_hp_sub()
			enemy_sprite.play("damage")
			await enemy_sprite.animation_finished
			enemy_sprite.play("idle")
		if get_parent().hp <= 0:
			get_parent()._boss_hp_sub()
			$CollisionPolygon2D.set_deferred("disabled", true)
			enemy_sprite.play("dead")
			await enemy_sprite.animation_finished
			get_parent()._boss_dead()
			queue_free()
	elif area.is_in_group("enemy_health_bullet"):
		if get_parent().hp > 0:
			get_parent().hp += area.get_parent().health_damage
			get_parent()._boss_hp_add()
			

func _on_visible_on_screen_notifier_2d_screen_exited():
	print('敌机飞出')
	if not clear_timer.is_stopped():
		clear_timer.stop()
	get_parent().queue_free() # Replace with function body.


func _on_shoot_timer_timeout():
	if shooting:
		shooting = !shooting
	pass # Replace with function body.
