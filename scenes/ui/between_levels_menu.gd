extends Control

@export var blink_interval := 1.0  # seconds
var blink_timer := 0.0
var continue_visible := true

func _ready() -> void:
	Audio.play_menu_music()
	$Summary.visible = true
	$Upgrades.visible = false
	GameState.game_state_update.connect(Callable(self, "_on_game_state_update"))
	$Upgrades/HP.pressed.connect(Callable(func():
		GameState.buy_upgrade("HP")
	))
	$Upgrades/Money.pressed.connect(Callable(func():
		GameState.buy_upgrade("Money")
	))
	$Upgrades/Speed.pressed.connect(Callable(func():
		GameState.buy_upgrade("Speed")
	))
	$Upgrades/Continue.pressed.connect(Callable(func():
		get_tree().change_scene_to_file("res://scenes/levels/Level.tscn")
	))

	_on_game_state_update()

func _on_game_state_update() -> void:
	$Upgrades/MoneyText.text = "Money: %d" % [GameState.money]
	render_upgrades()
	
func render_upgrades() -> void:
	for upgrade_name in GameState.upgrades.keys():
		var button: Button = get_node("Upgrades/"+upgrade_name)
		button.text = "%s\n\nCost: %d" % [upgrade_name, GameState.get_upgrade_price(upgrade_name)]
		button.get_child(0).text = str(GameState.upgrades.get(upgrade_name))

func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		continue_visible = !continue_visible
		$"Summary/Continue".visible = continue_visible
		blink_timer = 0.0
		
	if ($Summary.visible):
		if (Input.is_action_just_pressed("ui_select")):
			$Summary.visible = false
			$Upgrades.visible = true
	else:
		if (Input.is_action_just_pressed("ui_select")):
			GameState.print_game_state()
	
	
