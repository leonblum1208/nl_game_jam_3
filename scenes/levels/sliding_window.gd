extends Camera2D
@onready var body:StaticBody2D = $SlidingWindow

func _physics_process(_delta: float) -> void:
	body.global_rotation = 3*PI/2
