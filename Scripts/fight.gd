extends Control

#region New Code Region
#endregion
# Element Variables
@onready var happeningText : Label = $HappeningArea/HappeningText
@onready var playerArea: Control = $PlayerArea
#@onready var playerHealthText : Label = playerArea.attributeLabel("hp")
#@onready var playerpowerPointsText : Label = playerArea.attributeLabel("pp")
@onready var bossHealthText : Label = $EnemyArea/EnemySprite/bossHpNumber

# Class Variables

@export var bossStatus : boss
@export var userActions : actions
@export var effects : statusEffects
@export var createPlayers : setupTeam
@export var availablePlayers : playerData

# New Variables !!!
var playerTeam : Array[player] = []

@onready var windowContainer = $PlayerArea/WindowContainer
@onready var actionMenu = $HappeningArea/ActionMenu
# New Variables !!!


# Other Variables
var textTimer : float = 1.5
var isSomeoneAlive = true

func _ready() -> void:
	randomize()
	actionMenu.togglePlayerActions()
	await createPlayers.setup(3, windowContainer, actionMenu, playerArea, playerTeam, availablePlayers.info)
	
	bossStatus.healthLabel = bossHealthText

	await showHappeningText(["You encounter %s" % [bossStatus.charName], "Please choose your move"])
	actionMenu.togglePlayerActions()
	turnManager()



func showHappeningText(message) -> void:
	for text in message:
		happeningText.text = text
		await get_tree().create_timer(textTimer).timeout

func bossMove() -> void:
	var bossAction : int = randi_range(1, 2)
	if (bossStatus.health > bossStatus.maxHealth * 0.35 || bossAction == 1):
		bossStatus.action = "attack"
		bossStatus.target = playerTeam.pick_random()
	else:
		bossStatus.action = "heal"
		bossStatus.target = bossStatus

func turnManager() -> void:
	while true:
		var charOrder : Array[Node] = []
		charOrder.append(bossStatus)
		charOrder.append_array(playerTeam)
		
		charOrder.sort_custom(func(a, b): return a.speed > b.speed)
		
		for currentPlayer in charOrder:
			if (currentPlayer is player):
				if (currentPlayer.alive):
					actionMenu.currentPlayer = currentPlayer
					# ----------------------------------------
					actionMenu.specialButton.text = currentPlayer.specialAbility
					# ----------------------------------------
					currentPlayer.action = await actionMenu.playerChosenAction
					# ----------------------------------------
					currentPlayer.myUI.visible = false
					# ----------------------------------------
					currentPlayer.target = bossStatus
				else:
					currentPlayer.action = "dead"
			else:
				bossMove()
		
		actionMenu.togglePlayerActions()
		print("TURN STARTED")
		
		await executeTurn(charOrder)
			
		if (isSomeoneAlive && bossStatus.alive):
			actionMenu.togglePlayerActions()
			print("TURN ENDED")
		else:
			break

func executeTurn(charOrder : Array[Node]) -> void:
	for userInfo in charOrder:
		print("CURRENTTURN: %s" % [userInfo.name])
		if (userInfo is player):
			userInfo.myUI.visible = true
		
		# Test if there are no null targets (so it doesn't fucking crash):
		if userInfo.target != null:
			pass
		else:
			print("Aviso: ", userInfo.name, " não possui nenhum alvo definido!")
		
		if (userInfo.statusEffect.has("burn") && userInfo.alive):
			await effects.burn(userInfo)
		print("%s STATUSEFFECTS:: %s" % [userInfo.charName, userInfo.statusEffect])
		if (userInfo.alive):
			if (!userInfo.statusEffect.has("freeze")):
				if (userInfo.statusEffect.has("confusion")):
					print("HAS CONFUSION")
					await effects.confusion(userInfo)
				
				await moveManager(userInfo, userInfo.target)
			else:
				await effects.freeze(userInfo)
			
		if (!isSomeoneAlive || !bossStatus.alive):
			break

func moveManager(userName : Node, targetName : Node):
	print("MOVEMANAGER:: %s targeted %s" % [userName.charName, targetName.charName])
	if (targetName.alive):
		match userName.action:
			"attack":
				if userName is player:
					userName.target = bossStatus
				await userActions.attack(userName, userName.target)
			"heal":
				userName.target = userName
				await userActions.heal(userName, userName.target)
			"psi":
				if userName is player:
					userName.target = bossStatus
				await userActions.psi(userName, userName.target)
			"dark arts":
				if userName is player:
					userName.target = bossStatus
				await userActions.darkArtsManager(userName, userName.target)
			_:
				pass
	elif (userName is boss):
		await showHappeningText(["%s is already dead idiot!" % [targetName.charName]])

func updateHealthText(target : Node) -> void:
	if (target.health < 0):
		target.health = 0
	target.healthLabel.text = str(target.health)

func updatepowerPointsText(target : Node) -> void:
	target.powerPointsLabel.text = str(target.powerPoints)

func testForDeath(deffender : Node) -> void:
	if (deffender.health <= 0):
		deffender.alive = false
		print("TESTFORDEATH:: %s died!" % [deffender.charName])
		await showHappeningText([deffender.deathMessage])
	
	isSomeoneAlive = playerTeam.any(
		func(playerChecked): return playerChecked.alive == true
	)
	print("ISSOMEONEALIVE: ", isSomeoneAlive)
	
	if (!isSomeoneAlive || !bossStatus.alive):
		await endBattle()

func endBattle() -> void:
	if (isSomeoneAlive):
		await showHappeningText(["You won!"])
	else:
		await showHappeningText(["You lost the battle..."])
