extends AnimatableBody2D

const SPEED = 5

var timer = 0
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += 1
	if timer > (1000/SPEED):
		direction = direction * (-1)
		timer = 0
	position.x += SPEED * direction * delta
