extends Path2D

signal plane_init
var is_sprint = true
var is_reduce = false
@onready var sprite = $"../body/AnimatedSprite2D"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_sprint:
		if $PathFollow2D.progress < 580:
			$PathFollow2D.progress += 10
		else:
			is_sprint = false
			is_reduce = true
			sprite.play("reduce")
	if is_reduce:
		if $PathFollow2D.progress > 150:
			$PathFollow2D.progress -= 5
		else:
			is_reduce = false
			sprite.play("idle")
			emit_signal("plane_init")
	pass
