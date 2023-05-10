extends HBoxContainer

var hps = []
var hp_image = preload("res://png/ui/hp3.png")
# Called when the node enters the scene tree for the first time.
func _ready():
#	print(sub_hp(2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_hp(hp:int):
	for i in range(hp):
		var _hp = TextureRect.new()
		_hp.texture = hp_image
		add_child(_hp)
		hps.append(_hp)
	Global.hp = len(hps)

func sub_hp(hp:int)->int:
	# 扣除hp返回剩余hp值，返回值>=0
	var cur_hp = get_child_count()
	while cur_hp > 0:
		if hp > 0:
			var _hp = hps.pop_back()
			remove_child(_hp)
		else:
			break
		hp -= 1
		cur_hp -= 1
	Global.hp = cur_hp
	return cur_hp
