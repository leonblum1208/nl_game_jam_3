extends Control

@export var blink_interval := 1.0  # seconds
var blink_timer := 0.0
var how_to_start_visible := true

func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		how_to_start_visible = !how_to_start_visible
		$"CanvasLayer/How to start".visible = how_to_start_visible
		blink_timer = 0.0
