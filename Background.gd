extends ColorRect

var c = 0
var tween

var colors = [
	Color8(0,0,0,255)     
	,Color8(95,61,196,100)   #gray 9
	,Color8(103,65,217,100)   #gray 8
	,Color8(112,72,232,100)   #gray 7
	,Color8(103,65,217,100)   #gray 8
	,Color8(95,61,196,100)   #gray 9
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
