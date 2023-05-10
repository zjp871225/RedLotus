extends Node

# 玩家血量
var hp:int=8
# 玩家能量 最大值
@onready var power_max:int= 500
# 玩家能量 初始值
var power:int=0
# 是否爆气状态
var is_fury:bool = false
# 玩家分数
var score:int=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_status():
	hp = 8
	score = 0
	is_fury = false
	power = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_instance(_addto:Node2D, _node:PackedScene, 
	_global_position:Vector2,_direction:Vector2, _degree=0):
	#实例化场景节点
	#_addto：添加的父节点
	#_node:添加场景
	#_global_position:添加位置
	#_degree:角度
	var node = _node.instantiate()
#	node.global_position = _global_position
	node.direction = _direction
	# 弧度转换为角度
	var r = deg_to_rad(_degree)
	node.direction = node.direction.rotated(r)
#	print(node.global_position)
	_addto.add_child(node)
	node.global_position = _global_position
	return node
