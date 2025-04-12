extends Control

@export var blink_interval := 1.0  # seconds
var blink_timer := 0.0
var continue_visible := true

func _ready() -> void:
	Audio.play_menu_music()
	$Summary.visible = true
	render_summary()
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

func render_summary() -> void:
	var random_number_from_1_to_3 = randi() % 3 + 1
	match random_number_from_1_to_3:
		1:
			$Summary/Title.text = "Yay! ^_^"
		2:
			$Summary/Title.text = "Yeeeey :D"
		3:
			$Summary/Title.text = "Yaaay! \\o\\ /o/"
	var last_level_completed = GameState.get_last_completed_level()
	if (last_level_completed == null):
		printerr("last_level_completed is null, can't show summary")
		return
	var txt = "Cargo sold: %d" % [last_level_completed.cargo_money]
	txt += "\nHealth bonus: %d" % [last_level_completed.hp_bonus]
	txt += "\nTime bonus: %d" % [last_level_completed.time_bonus]
	if last_level_completed.upgrade_multiplier > 1:
		txt += "\nMultiplier: x%d" % [last_level_completed.upgrade_multiplier]
	txt += "\n\nTotal money earned: %d" % [last_level_completed.total_money]
	$Summary/MoneySummary.text = txt


func render_upgrades() -> void:
	for upgrade_name in GameState.upgrades.keys():
		var button: Button = get_node("Upgrades/"+upgrade_name)
		button.text = "%s\n\nCost: %d" % [upgrade_name, GameState.get_upgrade_price(upgrade_name)]
		button.get_child(0).text = str(GameState.upgrades.get(upgrade_name))
		button.disabled = GameState.money < GameState.get_upgrade_price(upgrade_name)

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
	
	
