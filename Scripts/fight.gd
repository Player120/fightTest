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
	togglePlayerActions()
	await showHappeningText(["You encounter %s" % [bossStatus.charName], "Please choose your move"])
	togglePlayerActions()

func showHappeningText(messages : Array) -> void:
	for text in messages:
		happeningText.text = text
		await get_tree().create_timer(textTimer).timeout

func _on_attack_pressed() -> void:
	if (playerStatus.alive):
		playerAttack()

func _on_heal_pressed() -> void:
	if (playerStatus.alive):
		playerHeal()

func playerAttack() -> void:
	togglePlayerActions()
	playerStatus.action = "attack"
	attack(playerStatus.offense, bossStatus.health, bossStatus.charName)

func playerHeal() -> void:
	togglePlayerActions()
	playerStatus.action = "heal"
	heal(playerStatus.health, playerStatus.charName)

func bossAttack() -> void:
	await showHappeningText(["%s is attacking!" % [bossStatus.charName]])
	attack(bossStatus.offense, playerStatus.health, playerStatus.charName)

func attack(attackerOffense, targetHealth, targetName) -> void:
	var criticalChance : int = randi_range(1, 3)
	var criticalMessage : String = ""
	var criticalHit : bool = true if criticalChance == 1 else false
	
	var damage : int = randi_range(attackerOffense - 5, attackerOffense + 5)
	if (criticalHit):
		var criticalDamage : float = damage * 2.5
		ceil(criticalDamage)
		damage = criticalDamage
		criticalMessage = "A critical hit! "
	
	targetHealth -= damage
	
	updateHealth(targetHealth, targetName)
	await showHappeningText(["%s%d HP of damage to %s!" % [criticalMessage, damage, targetName]])
	
	testForDeath(targetHealth, targetName)

func heal(userHealth, userName) -> void:
	var healValue = randi_range(20, 64)
	userHealth += healValue
	
	updateHealth(userHealth, userName)
	await showHappeningText(["%s is healing!" % [userName], "%s recovered %d HP!" % [userName, healValue]])
	bossAttack()

func updateHealth(health, target) -> void:
	if (health < 0):
		health = 0
		
	if (target == playerStatus.charName):
		playerStatus.health = health
		playerHealthText.text = str(playerStatus.health)
	else:
		bossStatus.health = health
		bossHealthText.text = str(bossStatus.health)

func testForDeath(health : int, name : String) -> void:
	if (name == playerStatus.charName):
		if (health <= 0):
			playerStatus.alive = false
			showHappeningText(["You were hurt and beaten...", "You lost the battle..."])
		else:
			showHappeningText(["Please choose your move"])
			togglePlayerActions()
	else:
		if (health <= 0):
			bossStatus.alive = false
			showHappeningText(["Big Gus was defeated!", "You won!"])
		else:
			bossAttack()

func togglePlayerActions() -> void:
	var playerArea : Control = $PlayerArea
	var actionButtons : Array = playerArea.find_children("*", "BaseButton", true, false)
	
	for button in actionButtons:
		button.disabled = !button.disabled
