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
var isSomeoneAlive : bool = true
var organizationActive : bool = false

func _ready() -> void:
	randomize()
	actionMenu.togglePlayerActions()
	await createPlayers.setup(5, windowContainer, actionMenu, playerArea, playerTeam, availablePlayers.info)
	
	bossStatus.healthLabel = bossHealthText

	await showHappeningText(["You encounter %s" % [bossStatus.charName], "Please choose your move"])
	actionMenu.togglePlayerActions()
	turnManager()

func showHappeningText(message) -> void:
	for text in message:
		happeningText.text = text
		await get_tree().create_timer(textTimer).timeout

func bossMove() -> void:
	var bossAction : int = randi_range(1, 6)
	while true:
		bossStatus.target = playerTeam.pick_random()
		if (bossStatus.target.canBeTargeted):
			break
	
	if (bossAction > 3):
		bossStatus.action = "attack"
	
	match bossAction:
		1:
			bossStatus.action = "innovation"
			bossStatus.target = bossStatus
			bossStatus.specialMoveName = "Enroladinho"
		2:
			bossStatus.action = "innovation"
			bossStatus.specialMoveName = "Dark Room"
		3:
			bossStatus.action = "innovation"
			bossStatus.specialMoveName = "MySQL Hack"

func turnManager() -> void:
	while true:
		var charOrder : Array[Node] = []
		charOrder.append(bossStatus)
		charOrder.append_array(playerTeam)
		
		charOrder.sort_custom(func(a, b): return a.speed > b.speed)
		
		for currentPlayer in playerTeam:
			if (currentPlayer is player):
				if (currentPlayer.alive && !currentPlayer.statusEffect.has("charging")):
					actionMenu.currentPlayer = currentPlayer
					# ----------------------------------------
					actionMenu.specialButton.text = currentPlayer.specialAbility
					# ----------------------------------------
					currentPlayer.myUI.backgroundColor.color = Color.CHARTREUSE
					# ----------------------------------------
					currentPlayer.action = await actionMenu.playerChosenAction
					# ----------------------------------------
					currentPlayer.myUI.backgroundColor.color = Color("428e96")
					# ----------------------------------------
					currentPlayer.target = bossStatus
				elif (!currentPlayer.alive):
					currentPlayer.action = "nothing"
				else:
					currentPlayer.action = "caipira powers"
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
	var npc : player
	if (organizationActive):
		npc = player.new()
		npc.name = "npc"
		npc.charName = "Organization"
		npc.action = "caipira powers"
		npc.specialMoveName = "Organization"
		npc.canBeTargeted = false
		npc.target = bossStatus
		charOrder.push_front(npc)
		print(charOrder)
	
	for userInfo in charOrder:
		print("CURRENTTURN: %s" % [userInfo.name])
		if (userInfo is player && userInfo.alive && !(userInfo.name == "npc")):
			userInfo.myUI.backgroundColor.color = Color.CHARTREUSE
		
		# Test if there are no null targets (so it doesn't fucking crash):
		if userInfo.target != null:
			pass
		else:
			print("Aviso: ", userInfo.name, " não possui nenhum alvo definido!")
		
		if (!(userInfo.name == "npc")):
			if (userInfo.statusEffect.has("burn") && userInfo.alive):
				await effects.burn(userInfo)
			print("%s STATUSEFFECTS:: %s" % [userInfo.charName, userInfo.statusEffect])
			if (userInfo.alive):
				if (!userInfo.statusEffect.has("freeze")):
					if (userInfo.statusEffect.has("confusion")):
						print("HAS CONFUSION")
						await effects.confusion(userInfo)
					
					var canMove = true
					
					if (userInfo.statusEffect.has("paralysis")):
						canMove = await effects.paralysis(userInfo)
					
					if (canMove):
						await moveManager(userInfo, userInfo.target)
				else:
					await effects.freeze(userInfo)
			
			if (userInfo is player && userInfo.alive):
				userInfo.myUI.backgroundColor.color = Color("428e96")
				
			if (!isSomeoneAlive || !bossStatus.alive):
				break
		else:
			match userInfo.charName:
				"Organization":
					await userActions.caipiraPowersManager(userInfo, userInfo.target)
					var willLeave : int = randi_range(1, 4)
					if (willLeave == 1):
						await showHappeningText(["The Organization team got tired from all their hard work and went to lunch."])
						organizationActive = false
	
	charOrder.erase(npc)

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
			"dev tools":
				if userName is player:
					var possibleTargets : Array = [playerTeam, userName]
					await userActions.devToolsManager(userName, possibleTargets)
			"caipira powers":
				if userName is player:
					await userActions.caipiraPowersManager(userName, userName.target)
			"friendship magic":
				if userName is player:
					await userActions.friendshipMagicManager(userName, userName.target, playerTeam)
			"innovation":
				if userName is boss:
					await userActions.innovationManager(userName, userName.target, playerTeam)
			_:
				pass
	elif (userName is boss):
		await showHappeningText(["%s is attacking!" % [userName.charName], "%s is already dead idiot!" % [targetName.charName]])

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
		
		if (deffender is player):
			deffender.myUI.backgroundColor.color = Color.RED
		
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
