extends Control
#test
func _on_Play_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_Quit_pressed():
	get_tree().quit()
