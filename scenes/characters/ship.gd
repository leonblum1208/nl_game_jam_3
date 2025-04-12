extends CharacterBody2D

@onready var ship_0 = $ShipSprite
@export var speed = 100

var is_damage_immune: bool = false

@onready var sprite = $ShipSprite
var boat_images : Array[Texture2D] = []


func _ready():
	for i in 16:
		var tex = load("res://sprites/Ship/ship%d.png" % (i+1))
		boat_images.append(tex)

func _physics_process(_delta):
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = input_direction * speed
	if velocity.length() > 0:
		rotation = velocity.angle() + deg_to_rad(90)
	select_sprite()
	move_and_slide()
	handle_damaging_collisions()

func handle_damaging_collisions():
	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().name == "SlidingWindow":
			handle_damage(20)

func handle_damage(damage):
	if not is_damage_immune:
		GameState.health -= 10
		is_damage_immune = true
		sprite.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.4).timeout
		sprite.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.4).timeout
		sprite.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.4).timeout
		sprite.modulate = Color(1, 1, 1, 1)
		is_damage_immune = false

func select_sprite():
	var angle_deg = int(rad_to_deg(rotation)) % 360
	# Rotate reference so 0° is up instead of right
	var adjusted_angle = (angle_deg) % 360
	# Flip angle to make it counterclockwise
	adjusted_angle = (360 - adjusted_angle) % 360
	var index = int(round(adjusted_angle / 22.5)) % 16
	sprite.texture = boat_images[index]
	# ignore parent rotation
	sprite.global_rotation = 0
