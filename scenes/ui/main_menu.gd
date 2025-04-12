extends Control

@export var blink_interval := 1.0  # seconds
var blink_timer := 0.0
var is_visible := true

func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		is_visible = !is_visible
		$"CanvasLayer/How to start".visible = is_visible
		blink_timer = 0.0
