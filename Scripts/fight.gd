extends Control

# Element Variables
@onready var playerHealthText : Label = $PlayerArea/playerHpNumber
@onready var bossHealthText : Label = $HappeningArea/bossHpNumber
@onready var happeningText : Label = $HappeningArea/HappeningText
@onready var attackButton : Button = $PlayerArea/Attack

# Class Variables
@export var playerStatus : player
@export var bossStatus : boss

# Other Variables
var textTimer : float = 2.0

func _ready() -> void:
	randomize()
	player.new()
	boss.new()

func _on_attack_pressed() -> void:
	if (playerStatus.alive):
		playerAttack()

func playerAttack() -> void:
	attackButton.disabled = true
	attack(playerStatus.offense, bossStatus.health, "Big Gus")

func bossAttack() -> void:
	await showHappeningText(["Big Gus is attacking!"])
	attack(bossStatus.offense, playerStatus.health, "Player")

func showHappeningText(messages : Array) -> void:
	for text in messages:
		happeningText.text = text
		await get_tree().create_timer(textTimer).timeout

func attack(attackerOffense, targetHealth, targetName) -> void:
	var damage : int = randi_range(attackerOffense - 5, attackerOffense + 5)
	targetHealth -= damage
	updateHealth(targetHealth, targetName)
	await showHappeningText(["%d HP of damage to %s!" % [damage, targetName]])
	testForDeath(targetHealth, targetName)

func updateHealth(health, target) -> void:
	if (health < 0):
		health = 0
		
	if (target == "Player"):
		playerStatus.health = health
		playerHealthText.text = str(playerStatus.health)
	else:
		bossStatus.health = health
		bossHealthText.text = str(bossStatus.health)

func testForDeath(health : int, name : String) -> void:
	if (name == "Player"):
		if (health <= 0):
			playerStatus.alive = false
			showHappeningText(["You were hurt and beaten...", "You lost the battle..."])
		else:
			attackButton.disabled = false
	else:
		if (health <= 0):
			bossStatus.alive = false
			showHappeningText(["Big Gus was defeated!", "You won!"])
		else:
			bossAttack()
