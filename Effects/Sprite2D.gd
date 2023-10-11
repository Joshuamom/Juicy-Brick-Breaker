extends Sprite2D

var c = 0
var tween

var colors = [
	Color8(0,0,0,255)     
	,Color8(33,37,41,255)   #gray 9
	,Color8(52,58,64,255)   #gray 8
	,Color8(73,80,87,255)   #gray 7
	,Color8(52,58,64,255)   #gray 8
	,Color8(33,37,41,255)   #gray 9
]

func _ready():
	update_color()

func update_color():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "color", colors[c], 2.0)
	tween.tween_callback(_tween_completed)

func _tween_completed():
	c = wrapi(c+1, 0, colors.size())
	update_color()


