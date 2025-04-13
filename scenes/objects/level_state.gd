extends Area2D

var current_level: int
var level_start_time: int
var level_end_time: int = 0
var level_death_time: int = 0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	GameState.death.connect(Callable(func():
		level_death_time = Time.get_ticks_msec()
		Engine.time_scale = 0.2
		$greyscreen.visible = true
		))
	$greyscreen.visible = false
	current_level = GameState.levelsCompleted.size() + 1
	level_start_time = Time.get_ticks_msec()

func _on_body_entered(body: Node) -> void:
	if (level_end_time > 0): #level is already over
		return
	elif (body.name == "Ship"):
		Audio.play_sfx(Audio.sfx.YAY)
		Engine.time_scale = 0.2
		level_end_time = Time.get_ticks_msec()
		var seconds_elapsed = (level_end_time - level_start_time) / 1000.
		match current_level:
			1:
				var time_par = 20
				GameState.complete_level(100, GameState.health, time_par - seconds_elapsed)
			2:
				var time_par = 30
				GameState.complete_level(150, GameState.health, time_par - seconds_elapsed)
			3:
				var time_par = 40
				GameState.complete_level(250, GameState.health, time_par - seconds_elapsed)
			_:
				printerr(str(current_level) + " is an invalid level")

func _process(_delta: float) -> void:
	if (level_end_time and level_end_time < Time.get_ticks_msec() - 5_000):
		Engine.time_scale = 1
		if GameState.levelsCompleted.size() == 3:
			get_tree().change_scene_to_file("res://scenes/ui/EndScreen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/ui/BetweenLevelsMenu.tscn")
	if (level_death_time and level_death_time < Time.get_ticks_msec() - 5_000):
		Engine.time_scale = 1
		get_tree().reload_current_scene()
