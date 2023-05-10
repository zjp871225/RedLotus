extends Node2D

@onready var play_ui = $"../play_ui"
@onready var game_over_scene = preload("res://ui/game_over.tscn")
@onready var mission_completed = preload("res://ui/clearance.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_plane_add_hp(hp):
	play_ui.hp_add(hp)
	pass # Replace with function body.

func _on_plane_sub_hp(hp):
	play_ui.hp_sub(hp)
	pass # Replace with function body.

func _on_boss_hp_change(ratio):
	play_ui.boss_hp_change(ratio)
	
func _on_boss_dead():
	$"../Timer2".stop()
	play_ui.boss_dead()
	get_tree().change_scene_to_packed(mission_completed)

func _on_boss_warning_timeout():
	play_ui.boss_warning()
	pass # Replace with function body.

func _update_score(score):
	play_ui.update_score()
	if not Global.is_fury:
		# 不在爆气状态可以增加能量
		play_ui.power_add(score)
	pass


func _on_boss_timer_timeout():
	play_ui.boss_status_show()
	pass # Replace with function body.


func _on_plane_player_dead():
	#切换到game over场景
	get_tree().change_scene_to_packed(game_over_scene)
	pass # Replace with function body.


func _on_plane_power_sub(val):
	play_ui.power_sub(val)
	pass # Replace with function body.
