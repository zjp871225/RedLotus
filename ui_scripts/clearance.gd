extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$score.text = "分数：" + str(Global.score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reset_pressed():
	get_tree().change_scene_to_file("res://ui/start_ui.tscn")
	#初始化状态
	Global.init_status()
	pass # Replace with function body.
