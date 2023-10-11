extends StaticBody2D

var decay = 0.01

func _ready():
	pass

func _physics_process(_delta):
	if $ColorRect.color.s > 0:
		$ColorRect.color.s -= decay
	if $ColorRect.color.v < 1:
		$ColorRect.color.v += decay
		

func hit(_ball):
	var wall_sound = get_node_or_null("/root/Game/wall")
	if wall_sound != null:
		wall_sound.play()
	$ColorRect.color = Color8(151,117,250)
	var camera = get_node_or_null("/root/Game/Camera")
	if camera != null:
		camera.add_trauma(2.0)
