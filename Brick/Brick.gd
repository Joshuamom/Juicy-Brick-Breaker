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

var color_index = 0
var color_distance = 0
var color_rotate = 0
var color_rotate_index = 0
var color_completed = true
var sway_index = Vector2.ZERO
var sway_period = Vector2.ZERO



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	if score >= 100:
		$ColorRect.color = Color8(224,49,49)
	elif score >= 90:
		$ColorRect.color = Color8(255,146,43)
	elif score >= 80:
		$ColorRect.color = Color8(255,212,59)
	elif score >= 70:
		$ColorRect.color = Color8(148,216,45)
	elif score >= 60:
		$ColorRect.color = Color8(34,139,230)
	elif score >= 50:
		$ColorRect.color = Color8(132,94,247)
	elif score >= 40:
		$ColorRect.color = Color8(190,75,219)
	else:
		$ColorRect.color = Color8(134,142,150)

func _physics_process(_delta):
	if color_rotate >= 0:
		color_rotate -= color_rotate_index
		color_rotate_index *= 1.05
	else:
		color_rotate_index = 0.1
		sway_index += sway_period
	if dying and not $Confetti.emitting and not tween:
		queue_free()


func hit(_ball):
	die()

func die():
	var brick_sound = get_node_or_null("/root/Game/brick")
	if brick_sound != null:
		brick_sound.play()
	dying = true
	collision_layer = 0
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
	tween.tween_property(self, "position", Vector2(position.x, 1000), time_fall).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
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

