extends Node2D

const SPEED = 30

var direction = 1
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if ray_cast_2d.is_colliding():
		rotation += PI
		var collidor = ray_cast_2d.get_collider()
		if collidor.has_method("handle_damage"):
			collidor.handle_damage(10)
	position += SPEED * delta * Vector2.RIGHT.rotated(rotation) 
