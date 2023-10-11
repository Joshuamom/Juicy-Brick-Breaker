extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var time_appear = 0.5
var time_fall = 0.8
var time_rotate = 1.0
var time_a = 0.8
var time_s = 1.2
var time_v = 1.5


var tween
var distort_effect = 0.0002
var h_rotate = 1.0

var powerup_prob = 0.1

var sway_amplitude = 3
var sway_index = Vector2.ZERO
var sway_period = Vector2.ZERO
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO

var color_index = 0
var color_distance = 0
var color_completed = true

var colors = [
	Color8(167, 0, 165)
	,Color8(156,54,181)
	,Color8(232,89,12)
	,Color8(245,159,0) #orange
	,Color8(148,216,45)
	,Color8(255,212,59)#yellow
	,Color8(233,236,239) #white
	,Color8(52,58,64) #black
]
var color_initial_position = Vector2.ZERO
var color_randomizer = Vector2.ZERO

var color_rotate = 0
var color_rotate_index = 0




func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	if score >= 100: color_index = 0
	elif score >= 90: color_index = 1
	elif score >= 80: color_index = 2
	elif score >= 70: color_index = 3
	elif score >= 60: color_index = 4
	elif score >= 50: color_index = 5
	elif score >= 40: color_index = 6
	else: color_index = 7
	$ColorRect.color = colors[color_index]
	sway_initial_position = $ColorRect.position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)

func _physics_process(_delta):
	if dying and not $Confetti.emitting and not tween:
		queue_free()
	elif not get_tree().paused:
		color_distance = Global.color_position.distance_to(global_position) / 100
		if Global.color_rotate >= 0:
			$ColorRect.color = colors[(int(floor(color_distance + Global.color_rotate)))% len(colors)]
			color_completed = true
		elif not color_completed:
			$ColorRect.color = colors[color_index]
			color_completed = true
	var pos_x = (sin(Global.sway_index)*(sway_amplitude + sway_randomizer.x))
	var pos_y = (sin(Global.sway_index)*(sway_amplitude + sway_randomizer.y))
	$ColorRect.position = Vector2(sway_initial_position.x + pos_x, sway_initial_position.y + pos_y)


func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/brick")
	if brick_sound != null:
		brick_sound.play()
	Global.color_rotate = Global.color_rotate_amount
	Global.color_position = _ball.global_position
	die()
	var camera = get_node_or_null("/root/Game/Camera")
	if camera != null:
		camera.add_trauma(2.0)

func die():
	dying = true
	collision_layer = 0
	collision_mask = 0
	$Confetti.emitting = true
	#$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2(position.x, 1000), time_fall).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", -PI + randf()*2*PI, time_rotate).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($ColorRect, "color:a", 0, time_a)
	tween.tween_property($ColorRect, "color:s", 0, time_s)
	tween.tween_property($ColorRect, "color:v", 0, time_v)
	
func comet():
	h_rotate = wrapf(h_rotate+0.01, 0, 1)
	var comet_container = get_node_or_null("/root/Game/comet_container")
	if comet_container != null:
		var sprite = $Images/Sprite.duplicate()
		sprite.global_position = global_position
		sprite.modulate.s = 0.6
		sprite.modulate.h = h_rotate
		comet_container.add_child(sprite)

