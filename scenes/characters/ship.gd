extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	#TODO move animations out of input maybe
	if (input_direction.y > 0):
		$Sprite2D.texture = ResourceLoader.load("res://sprites/ship_down.png")
	elif (input_direction.y < 0):
		$Sprite2D.texture = ResourceLoader.load("res://sprites/ship_up.png")
	elif (input_direction.x > 0):
		$Sprite2D.texture = ResourceLoader.load("res://sprites/ship_side.png")
		$Sprite2D.scale.x = -1
	elif (input_direction.x < 0):
		$Sprite2D.texture = ResourceLoader.load("res://sprites/ship_side.png")
		$Sprite2D.scale.x = 1

func _physics_process(delta):
	get_input()
	move_and_slide()
