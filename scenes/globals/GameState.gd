extends Node

var levelsCompleted = []
var money = 700
var upgrades: Dictionary[String, int] = {
	"Speed": 0,
	"Money": 0,
	"HP": 0,
}

signal game_state_update

func print_game_state() -> void:
	print("GAME STATE:")
	print("money: %d, levels completed: %d, upgrades: %s" % [money, levelsCompleted.size(), upgrades])
	print("")


func complete_level(moneyEarned: int, hp: int, seconds_under_par: int) -> void:
	levelsCompleted.append(CompletedLevel.new(moneyEarned, hp * 50, seconds_under_par * 10))
	money += moneyEarned
	emit_signal("game_state_update")

func buy_upgrade(upgrade_name: String):
	if (money > upgrades.get(upgrade_name)):
		money -= 100
		upgrades.set(upgrade_name, upgrades.get(upgrade_name) + 1)
		emit_signal("game_state_update")

func get_upgrade_price(upgrade_name: String) -> int:
	return 100 + 100 * upgrades.get(upgrade_name)

class CompletedLevel:
	var money_earned: int
	var hp_bonus: int
	var time_bonus: int

	# Constructor to initialize the properties
	func _init(money_earned: int, hp_bonus: int, time_bonus: int) -> void:
		self.money_earned = money_earned
		self.hp_bonus = hp_bonus
		self.time_bonus = time_bonus
