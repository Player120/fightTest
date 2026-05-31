extends Control

#region New Code Region
#endregion
# Element Variables
@onready var happeningText : Label = $HappeningArea/HappeningText
@onready var playerArea: Control = $PlayerArea
@onready var actionMenu : Control = $HappeningArea/ActionMenu
@onready var playerHealthText : Label = playerArea.attributeLabel("hp")
@onready var playerPsychicPointsText : Label = playerArea.attributeLabel("pp")
@onready var bossHealthText : Label = $EnemyArea/EnemySprite/bossHpNumber

# Class Variables
@export var playerStatus : player
@export var bossStatus : boss
@export var userActions : actions
@export var effects : statusEffects

# Other Variables
var textTimer : float = 1.0
var isPlayerActionable = false

func _ready() -> void:
	randomize()
	actionMenu.togglePlayerActions()
	
	playerStatus.healthLabel = playerHealthText
	playerStatus.psychicPointsLabel = playerPsychicPointsText
	bossStatus.healthLabel = bossHealthText
	
	await showHappeningText(["You encounter %s" % [bossStatus.charName], "Please choose your move"])
	actionMenu.togglePlayerActions()

func showHappeningText(message) -> void:
	for text in message:
		happeningText.text = text
		await get_tree().create_timer(textTimer).timeout

func bossMove() -> void:
	var bossAction : int = randi_range(1, 2)
	print("BOSSMOVE:: Boss Action: %d" % [bossAction])
	if (bossStatus.health > bossStatus.maxHealth * 0.35 || bossAction == 1):
		bossStatus.action = "attack"
		bossStatus.target = playerStatus
	else:
		bossStatus.action = "heal"
		bossStatus.target = bossStatus
		
	turnManager()

func turnManager() -> void:
	actionMenu.togglePlayerActions()
	var charData = [
		playerStatus,
		bossStatus
	]
	charData.sort_custom(func(a, b): return a.speed > b.speed)
	
	for userInfo in charData:
		print("TURNMANAGER:: %s user targeted %s" % [userInfo.charName, userInfo.target])
		
		if (userInfo.statusEffect.has("burn")):
			await effects.burn(userInfo)
		
		if (userInfo.alive):
			if (!userInfo.statusEffect.has("freeze")):
				await moveManager(userInfo, userInfo.target)
			else:
				await effects.freeze(userInfo)
		
		if (!userInfo.alive || !userInfo.target.alive):
			var whoDied : String = ""
			match false:
				userInfo.alive:
					whoDied += userInfo.charName + ", "
				userInfo.target.alive:
					whoDied += userInfo.target.charName + ","
			print("TURNMANAGER:: %s has died. The battle should have ended." % [whoDied])
			break
	
	if (playerStatus.alive && bossStatus.alive):
		showHappeningText(["Please choose your move"])
		actionMenu.togglePlayerActions()

func moveManager(userName : Node, targetName : Node):
	print("MOVEMANAGER:: %s did the action %s to %s" % [userName.charName, userName.action, targetName])
	match userName.action:
		"attack":
			await userActions.attack(userName, userName.target)
			print("MATCH (moveManager):: Target health AFTER attack: %d" % [userName.target.health])
		"heal":
			await userActions.heal(userName, userName.target)
			print("MATCH (moveManager):: Target health AFTER heal: %d" % [userName.target.health])
		"psi":
			await userActions.psi(userName, userName.target)
		_:
			await showHappeningText(["Something went wrong. Please reset the application."])

func updateHealthText(target : Node) -> void:
	print("UPDATEHEALTHTEXT:: Target Health: %s" % [target.healthLabel])
	if (target.health < 0):
		target.health = 0
	target.healthLabel.text = str(target.health)

func updatePsychicPointsText(target : Node) -> void:
	target.psychicPointsLabel.text = str(target.psychicPoints)

func testForDeath(deffender : Node) -> void:
	if (deffender.health <= 0):
		deffender.alive = false
		print("TESTFORDEATH:: %s died!" % [deffender.charName])
		await get_tree().create_timer(textTimer).timeout
		showHappeningText(deffender.deathMessage)
