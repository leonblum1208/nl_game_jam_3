extends CharacterBody2D

@onready var ship_0 = $ShipSprite
@export var base_speed:float = 100
var taken_damage_speed: float
@export var speed:float = 100:
	set(value):
		speed = value
		taken_damage_speed = value / 3
@onready var path_follow:PathFollowRiver = $"../Path2D/PathFollow2D"
@onready var sliding_camera:Camera2D = $"../Path2D/PathFollow2D/SlidingWindow"

var is_damage_immune: bool = false
var is_dead: bool = false

@onready var sprite = $ShipSprite
var boat_images : Array[Texture2D] = []


func _ready():
	for i in 16:
		var tex = load("res://sprites/Ship/ship%d.png" % (i+1))
		boat_images.append(tex)
	speed += 30 * GameState.upgrades.get("Speed")
	GameState.death.connect(Callable(func():
		print("Ship is dead")
		Audio.play_sfx(Audio.sfx.DEATH)
		speed = 0
		is_dead = true
		))

func _physics_process(_delta):
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_damage_immune:
		velocity = input_direction * taken_damage_speed
	else:
		velocity = input_direction * speed
	if velocity.length() > 0:
		rotation = velocity.angle() + deg_to_rad(90)
	
	select_sprite()
	move_and_slide()
	handle_damaging_collisions()
	influence_camera_speed()

func influence_camera_speed():
	var diff_vec = global_position - sliding_camera.global_position
	#var camera_direction = Vector2.RIGHT.rotated(sliding_camera.global_rotation)
	#var angle_diff_to_camera = diff_vec.angle_to(camera_direction)
	#var rel_distance_vec = diff_vec/cos(angle_diff_to_camera)
	#var dist_length = rel_distance_vec.length()
	var dist_length = -diff_vec.y
	var max_speed_up = speed/base_speed * 3
	var speed_up = min(max_speed_up, max(0.75, (dist_length / 100 * speed/base_speed) + 1))

	#if abs(angle_diff_to_camera) <= PI/2:
		#speed_up = min((dist_length / 200) + 1, 2)
	#else:
		#speed_up = max(1-(dist_length/400), 0.5)
	path_follow.speed = path_follow.base_speed * speed_up

func handle_damaging_collisions():
	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		collision.get_normal()
		if collision.get_collider().name == "SlidingWindow":
			handle_damage(20)
		else:
			handle_damage(10)

func handle_damage(damage):
	if not is_damage_immune and not is_dead:
		Audio.play_sfx(Audio.sfx.COLLISION)
		GameState.health -= damage
		is_damage_immune = true
		sprite.modulate = Color(1, 0, 0)
		await get_tree().create_timer(400).timeout
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
