extends CharacterBody2D

var target = Vector2.ZERO
var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02
var tween
var time_highlight = 0.4
var time_highlight_size = 0.3
var tween2

func _ready():
	width = $CollisionShape2D.get_shape().size.x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, width/2, Global.VP.x - width/2)
	position = target
	for c in $Powerups.get_children():
		c.payload()
	if $paddel/highlight.modulate.a > 0:
		$paddel/highlight.modulate.a -= decay

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	var paddle_sound = get_node_or_null("/root/Game/paddle")
	if paddle_sound != null:
		paddle_sound.play()
	$pump.emitting = true
	var paddle = get_node_or_null("/root/Game/paddle")
	if paddle != null:
		paddle.play()
	$paddel/highlight.modulate.a = 1.0
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	$paddel/highlight.modulate.a = 1.0
	tween.tween_property($paddel/highlight, "modulate:a", 2.0, time_highlight)
	$paddel/highlight.scale = Vector2(1.5, 1.5)
	tween2 = create_tween().set_parallel(true)
	print(tween)
	tween2.set_trans(Tween.TRANS_BOUNCE)
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property($paddel/highlight, "scale", Vector2(1.0,1.0), time_highlight_size).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)



func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
