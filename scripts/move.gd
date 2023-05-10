extends Node2D

var speed = 300
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = speed * direction
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = direction * speed
	global_position += velocity*delta
	pass
