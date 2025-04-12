extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	#TODO consider moving sprite stuff out of get_input
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

func _physics_process(_delta):
	get_input()
	move_and_slide()
