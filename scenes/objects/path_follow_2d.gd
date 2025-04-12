extends PathFollow2D
class_name PathFollowRiver

@export var base_speed:float = 50.
var speed:float = 50.0

func _process(delta):
	progress += speed * delta
