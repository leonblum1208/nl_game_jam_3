extends CanvasLayer

var skull_icon = load("res://scenes/ui/skull-icon.png")

func _ready() -> void:
	$HealthBar.max_value = GameState.health
	$HealthBar.value = GameState.health
	$HealthLabel.text = str(int(GameState.health))
	GameState.game_state_update.connect(Callable(func():
		$HealthBar.value = GameState.health
		$HealthLabel.text = str(int(GameState.health))
		))
	GameState.death.connect(Callable(func():
		$HealthBarIcon.texture = skull_icon
		))
