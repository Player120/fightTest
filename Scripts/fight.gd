extends Control

# Element Variables
@onready var playerHealthText : Label = $PlayerArea/playerHpNumber
@onready var bossHealthText : Label = $HappeningArea/bossHpNumber
@onready var attackButton : Button = $PlayerArea/Attack

# Class Variables
var playerStatus : player
var bossStatus : boss

func _ready() -> void:
	randomize()
	playerStatus = player.new()
	bossStatus = boss.new()

func updatePlayerHealthText() -> void:
	playerHealthText.text = str(playerStatus.getPlayerHealth())

func updateBossHealthText() -> void:
	bossHealthText.text = str(bossStatus.getBossHealth())

func _on_attack_pressed() -> void:
	attackButton.disabled = true
	bossStatus.bossTakeDamage(playerStatus.getPlayerOffense())
	updateBossHealthText()

func bossAttack() -> void:
	bossStatus.boss
