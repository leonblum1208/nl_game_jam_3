extends Node2D

func _ready() -> void:
	var level = load("res://scenes/objects/river_land_%d.tscn" % GameState.levelsCompleted.size())
	Audio.play_level_music()
	GameState.start_level()
	
	if level:
		add_child(level.instantiate())
	else:
		printerr("could not load level %d" % GameState.levelsCompleted.size())
