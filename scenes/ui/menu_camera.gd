extends Camera2D

@export var SPEED = 40;

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if (position.y < -7_000): #hard restart every 7000/SPEED sec
		position.y = 0
