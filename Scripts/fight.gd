extends Control

#region New Code Region
#endregion
# Element Variables
@onready var happeningText : Label = $HappeningArea/HappeningText
@onready var playerArea: Control = $PlayerArea
#@onready var playerHealthText : Label = playerArea.attributeLabel("hp")
#@onready var playerPsychicPointsText : Label = playerArea.attributeLabel("pp")
@onready var bossHealthText : Label = $EnemyArea/EnemySprite/bossHpNumber

# Class Variables

@export var bossStatus : boss
@export var userActions : actions
@export var effects : statusEffects

# New Variables !!!
var playerClass = preload("res://Scripts/Classes/player.gd")
var playerWindowScene = preload("res://Prefabs/player_window.tscn")
var playerTeam : Array[player] = []

@onready var windowContainer = $PlayerArea/WindowContainer
@onready var actionMenu = $HappeningArea/ActionMenu
# New Variables !!!


# Other Variables
var textTimer : float = 1.0
var isSomeoneAlive = true

func _ready() -> void:
	randomize()
	actionMenu.togglePlayerActions()
	setupTeam(3)
	
	bossStatus.healthLabel = bossHealthText

	await showHappeningText(["You encounter %s" % [bossStatus.charName], "Please choose your move"])
	actionMenu.togglePlayerActions()
	turnManager()

func setupTeam(quantity : int) -> void:
	for i in range(quantity):
		# Setup player attributes
		var newPlayer : Node = playerClass.new()
		newPlayer.name = "Player_" + str(i + 1)
		newPlayer.charName = "Player_" + str(i + 1) + "p"
		newPlayer.position = i + 1
		newPlayer.health = 100
		newPlayer.maxHealth = newPlayer.health
		newPlayer.psychicPoints = 30
		newPlayer.maxPsychicPoints = 30
		newPlayer.offense = 25
		newPlayer.speed = 12
		newPlayer.specialAbility = "Dark Arts"
		newPlayer.deathMessage = "%s was hurt and beaten..." % [newPlayer.charName]
		
		# Creates UI window with name and HP/PP values
		var newWindow : Control = playerWindowScene.instantiate()
		windowContainer.add_child(newWindow)
		
		# Linking one with the other
		# Passing the referenced data to the window to update health/name
		newWindow.initializeWithPlayer(newPlayer)
		
		# Storing the window, hp label and pp label inside of the own player if it is needed
		newPlayer.myUI = newWindow
		newPlayer.healthLabel = newWindow.hpNumber
		newPlayer.psychicPointsLabel = newWindow.ppNumber
		
		# Adding the node logic in the tree (as child of fight area)
		add_child(newPlayer)
		
		# Stores the player in the turn array
		playerTeam.append(newPlayer)
		
		# Attributes the hp and pp values to the labels for the first time
		playerArea.updateValues("health", newPlayer.health, newPlayer.myUI)
		playerArea.updateValues("psychicPoints", newPlayer.psychicPoints, newPlayer.myUI)
		print("Player '%s' created" % [newPlayer])

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
		
		if (userInfo.alive):
			if (!userInfo.statusEffect.has("freeze")):
				await moveManager(userInfo, userInfo.target)
			else:
				await effects.freeze(userInfo)

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

func updatePsychicPointsText(target : Node) -> void:
	target.psychicPointsLabel.text = str(target.psychicPoints)

func testForDeath(deffender : Node) -> void:
	if (deffender.health <= 0):
		deffender.alive = false
		print("TESTFORDEATH:: %s died!" % [deffender.charName])
		await showHappeningText([deffender.deathMessage])
	
	isSomeoneAlive = playerTeam.any(
		func(playerChecked): return playerChecked.alive == true
	)
	
	if (!isSomeoneAlive || !bossStatus.alive):
		endBattle()

func endBattle() -> void:
	if (isSomeoneAlive):
		await showHappeningText(["You won!"])
	else:
		await showHappeningText(["You lost the battle..."])
