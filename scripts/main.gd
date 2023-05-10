extends Node2D

@onready var path = $Path2D/PathFollow2D
@onready var path2 = $Path2D2/PathFollow2D
@onready var path3 = $Path2D3/PathFollow2D
@onready var enemy_timer = $Timer
@onready var enemy2_timer = $Timer2
@onready var boss_timer = $boss_timer
@onready var hp = $"play_ui/hp"
@onready var control_game = $control_game
@onready var player = $plane
var enemy1=preload("res://scenes/enemy1.tscn")
var enemy2=preload("res://scenes/enemy2.tscn")
var boss1 = preload("res://scenes/boss1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	seed(123)
	hp.add_hp(Global.hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
#	path.progress_ratio = randf()
#	Global.create_instance(self, enemy1, path.global_position, 0)
	enemy_by_formation()
	pass # Replace with function body.


func enemy_by_formation():
	path.progress_ratio = randf()
	for i in range(5):
		# 需要一个时间间隔
		await get_tree().create_timer(0.3).timeout
		var enemy = Global.create_instance(self, enemy1, path.global_position,Vector2.DOWN, 0)
		enemy.connect("update_score", control_game._update_score)

func enemy2_by_formation():
	path2.progress_ratio = randf()
	for i in range(2):
		# 需要一个时间间隔
		await get_tree().create_timer(0.5).timeout
		var enemy = Global.create_instance(self, enemy2, path2.global_position,Vector2.DOWN, 0)
		enemy.connect("update_score", control_game._update_score)


func _on_boss_timer_timeout():
	enemy_timer.stop()
	enemy2_timer.start()
	path.progress_ratio = 0.5
	var boss = Global.create_instance(self, boss1, path.global_position,Vector2.DOWN, 0)
	boss.connect("update_score", control_game._update_score)
	boss.connect("boss_hp_change", control_game._on_boss_hp_change)
	boss.connect("boss_dead", control_game._on_boss_dead)
	pass # Replace with function body.


func _on_timer_2_timeout():
	enemy2_by_formation()
	pass # Replace with function body.


func _on_guide_timer_timeout():
	$guide.visible = false
	pass # Replace with function body.
