extends Control

@onready var boss_status = $"boss_status"
@onready var boss_hp = $"boss_status/Control/boss_hp"
@onready var player_power=$Control/power
# Called when the node enters the scene tree for the first time.
func _ready():
	player_power.max_value = Global.power_max
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hp_sub(hp:int):
	$hp.sub_hp(hp)
	
func hp_add(hp:int):
	$hp.add_hp(hp)

func boss_warning():
	$warning.visible = true
	$AnimationPlayer.play("warning")
	await $AnimationPlayer.animation_finished
	$warning.visible = false
	
func update_score():
	$score.text = "score: " + str(Global.score)
	
	
func boss_status_show():
	boss_status.visible = true

func boss_hp_change(ratio):
	boss_hp.value = boss_hp.max_value * ratio

func boss_dead():
	boss_status.visible = false
	boss_hp.value = 10000

func power_add(val:int):
	if Global.power < player_power.max_value:
		var res = Global.power + val
		player_power.value = res if res <= player_power.max_value else player_power.max_value
		Global.power = player_power.value
	if Global.power == player_power.max_value:
		$max.visible = true
	else:
		$max.visible = false

func power_sub(val:int):
	if Global.power > 0:
		var res = Global.power - val
		player_power.value = res if res >=0 else 0
		Global.power = player_power.value	
	if Global.power < player_power.max_value:
		$max.visible = false
