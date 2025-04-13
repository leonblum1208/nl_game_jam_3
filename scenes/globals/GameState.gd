extends Node

var levelsCompleted: Array
var money: int
var health:float = 50:
	set(value):
		health = value
		print("Boats health is: %d" % [health])
		if (health <= 0):
			emit_signal("death")
		emit_signal("game_state_update")
var upgrades: Dictionary[String, int]

signal death
signal game_state_update

func _ready() -> void:
	full_reset()

# should be done only when all levels are over
func full_reset() -> void:
	levelsCompleted = []
	money = 0
	health = 50
	upgrades = {
		"Speed": 0,
		"Money": 0,
		"HP": 0,
	}

func print_game_state() -> void: #debugging
	print("GAME STATE:")
	print("Current health: %d" % [health])
	print("money: %d, levels completed: %d, upgrades: %s" % [money, levelsCompleted.size(), upgrades])
	print("")

func start_level():
	health = 50 + 30 * upgrades.get("HP")

func complete_level(moneyEarned: int, hp: int, seconds_under_par: int) -> void:
	var level = CompletedLevel.new(moneyEarned, hp, seconds_under_par, upgrades.get("Money"))
	levelsCompleted.append(level)
	money += level.total_money
	emit_signal("game_state_update")

func buy_upgrade(upgrade_name: String):
	if (money >= get_upgrade_price(upgrade_name)):
		money -= get_upgrade_price(upgrade_name)
		upgrades.set(upgrade_name, upgrades.get(upgrade_name) + 1)
		Audio.play_sfx(Audio.sfx.MONEY)
		emit_signal("game_state_update")

func get_upgrade_price(upgrade_name: String) -> int:
	return 100 + 100 * upgrades.get(upgrade_name)

func get_last_completed_level() -> CompletedLevel:
	if (levelsCompleted.size() == 0):
		return null
	return levelsCompleted.get(levelsCompleted.size() - 1)

class CompletedLevel:
	var cargo_money: int
	var hp_bonus: int
	var time_bonus: int
	var upgrade_multiplier: int
	var total_money: int

	# Constructor to initialize the properties
	func _init(_cargo_money: int, hp: int, seconds_under_par: int, upgrade_level: int) -> void:
		self.cargo_money = _cargo_money
		self.hp_bonus = hp
		self.time_bonus = seconds_under_par * 5
		self.upgrade_multiplier = upgrade_level + 1
		print(self.cargo_money)
		self.total_money = (self.cargo_money + self.hp_bonus + self.time_bonus) * self.upgrade_multiplier
