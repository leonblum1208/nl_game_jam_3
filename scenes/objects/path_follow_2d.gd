extends PathFollow2D

var speed = 50

func _process(delta):
	progress += speed * delta
