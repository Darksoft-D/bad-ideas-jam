extends Entity

var float_height := 1.5   # how high it moves
var float_speed := 4.0     # speed of floating
var start_y := 55.0
var time := 0.0

func _process(delta):
	var t = Time.get_ticks_msec() / 1000.0
	position.y = start_y + sin(t * float_speed) * float_height
