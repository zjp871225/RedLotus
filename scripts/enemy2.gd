extends Node2D

@onready var clear_timer=$"../Timer"
@onready var goods_timer=$"../goods_timer"
@onready var enemy_sprite=$AnimatedSprite2D
@onready var path = get_parent().get_node("Path2D/PathFollow2D")
@onready var enemy = get_parent()
var speed
var velocity
var direction
var max_x:int
var min_x:int 
var max_y:int
var min_y:int 
var shooting = true
var is_dead = false
var bullets
var screenSize
var bullet_enemy=preload("res://scenes/bullet_enemy2.tscn")
var goods_add_blood = preload("res://scenes/goods1.tscn")
# 生命值
@export var hp = 100

var cur_node
# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化
	# 设置飞机动画状态
	# 获取游戏窗口大小，用于设置边界
#	print('敌机位置：',global_position)
	screenSize = get_viewport_rect().size
	speed=300
	velocity = Vector2.ZERO
	direction = Vector2.DOWN
	enemy_sprite.play("idle")
	bullets = get_parent().get_node("bullets")
	velocity = speed * direction
	create_normal_bullet()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	position += velocity*delta
#	path.progress_ratio += 0.3 * delta
	if not is_dead:
		path.progress += 4
		shoot()
	
func shoot():
	var count = bullets.get_child_count()
	if count == 0 and position.y > 0:
		create_circle_bullet()	
		
	
func create_normal_bullet():
	var node = bullet_enemy.instantiate()
	cur_node = node
	#node.position = Vector2(position.x-20, position.y)
	# 这里不能直接使用fire.position因为这是相对于父节点body的相对坐标
	# 需要使用全局坐标来添加
#	node.global_position = $fire.global_position
	node.speed = 500
	node.direction = Vector2.DOWN
#	print('子弹位置：',node.global_position)
	bullets.add_child(node)
	node.global_position = $fire.global_position

func create_double_bullet():
	for i in [-10, 10]:
		var bullet_position = Vector2($fire.global_position.x+i, $fire.global_position.y+10)
		Global.create_instance(bullets, bullet_enemy, bullet_position,Vector2.DOWN, 180)

func create_sector_bullet():
	#扇形子弹,角度
	var bullet_positon = $fire.global_position
	bullet_positon.y += 10
	for degree in [-30,-15,0,15,30]:
		Global.create_instance(bullets, bullet_enemy, 
			bullet_positon,Vector2.DOWN, degree)

func create_circle_bullet():
	#扇形子弹,角度
	var bullet_positon = $fire.global_position
	bullet_positon.y += 10
	for degree in [-300, -270 -240, -210, -180, -150, -120, -90, -60, -30, 0,
					30, 60, 90, 120, 150, 180, 210, 240, 270, 300]:
		Global.create_instance(bullets, bullet_enemy, 
			bullet_positon,Vector2.DOWN, degree)


func _on_area_entered(area):
	if area.is_in_group("bullet"):
		Global.score += 30
		enemy._update_score(30)
		if hp > 0:
			hp -= area.get_parent().damage
		if hp <= 0:
			$CollisionShape2D.set_deferred("disabled", true)
			is_dead = true
			enemy_sprite.play("dead")
			await enemy_sprite.animation_finished
			# 掉落物品
			Global.create_instance(self, goods_add_blood, global_position,Vector2.ZERO, 0)
			goods_timer.start()
#			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
#	print('敌机飞出')
	if not clear_timer.is_stopped():
		clear_timer.stop()
	get_parent().queue_free() # Replace with function body.


func _on_goods_timer_timeout():
	if not clear_timer.is_stopped():
		clear_timer.stop()
	get_parent().queue_free()
	pass # Replace with function body.
