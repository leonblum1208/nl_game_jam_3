extends Control

@export var blink_interval := 1.0  # seconds
var blink_timer := 0.0
var how_to_start_visible := true

func _ready() -> void:
	$CanvasLayer/MuteIcon.visible = Audio.is_muted()
	Audio.toggle_mute.connect(Callable(func():
		$CanvasLayer/MuteIcon.visible = Audio.is_muted()
		))

func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		how_to_start_visible = !how_to_start_visible
		$"CanvasLayer/How to return".visible = how_to_start_visible
		blink_timer = 0.0
	
	if (Input.is_action_just_pressed("ui_select")):
		Audio.play_level_music()
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
