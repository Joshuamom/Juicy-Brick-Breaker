extends Node2D

func start_fever():
	fever()
	$Timer.start()
	var fever_indicator = get_node_or_null("/root/Game/UI/HUD/Fever")
	if fever_indicator != null:
		fever_indicator.use_parent_material = false
	var background = get_node_or_null("/root/Game/Background")
	if background != null:
		background.use_parent_material = false

func end_fever():
	pass

func _on_Timer_timeout():
	if Global.feverish:
		fever()
		$Timer.start()
	else:
		var fever_indicator = get_node_or_null("/root/Game/UI/HUD/Fever")
		if fever_indicator != null:
			fever_indicator.use_parent_material = true
		var background = get_node_or_null("/root/Game/Background")
		if background != null:
			background.use_parent_material = true
			

func fever():
	var ball_container = get_node_or_null("/root/Game/Ball_Container")
	if ball_container != null:
		ball_container.make_ball_fever()
	var camera = get_node_or_null("/root/Game/Camera3D")
	if camera != null:
		camera.add_trauma(3.0)

