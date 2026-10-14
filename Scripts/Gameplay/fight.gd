extends Control

#region New Code Region
#endregion
# Element Variables
@onready var happeningText : Label = $HappeningArea/HappeningText
@onready var happeningBackground : TextureRect = $HappeningArea/BackgroundSprite
@onready var playerArea : Control = $PlayerArea
#@onready var playerHealthText : Label = playerArea.attributeLabel("hp")
#@onready var playerpowerPointsText : Label = playerArea.attributeLabel("pp")
@onready var enemyArea : Control = $EnemyArea
@onready var enemyContainer : HBoxContainer = $EnemyArea/EnemyContainer
@onready var background : TextureRect = $EnemyArea/Background

# Class Variables

@export var userActions : actions
@export var effects : statusEffects
@export var createPlayers : setupTeam
@export var createEnemyTeam : setupEnemyTeam
@export var availablePlayers : playerData
@export var availableEnemies : enemyData
@export var organizationTeam : organization
@export var assignTeams : teamAssignments
var damageVisual : damageVisualEffect = damageVisualEffect.new()

# New Variables !!!
var playerTeam : Array[player] = []
var enemyTeam : Array[enemy] = []

@onready var windowContainer : HBoxContainer = $PlayerArea/WindowContainer
@onready var actionMenu : Control = $HappeningArea/ActionMenu
@onready var backgroundMusic : AudioStreamPlayer = $BackgroundMusic
@onready var buttonSoundEffect : AudioStreamPlayer = $ButtonSoundEffect
# New Variables !!!


# Other Variables
var textTimer : float = 1.0
var isPlayerTeamAlive : bool = true
var isEnemyTeamAlive : bool = true
signal enterPressed

func _ready() -> void:
	randomize()
	actionMenu.togglePlayerActions()
	
	backgroundMusic.playMusic("res://Resources/Music/Inova x Paizão.mp3")
	
	Global.fightScript = self
	
	setupButtonSounds(self)
	
	# Creates the player characters. Change the first number to change the amount of players (max of 5 by default), or checkout the playerData.gd file to create new players or modify pre-existing data
	await createPlayers.setup(5, windowContainer, actionMenu, playerArea, playerTeam, availablePlayers.info)
	
	# Creates the enemy characters. Change the first number to change the amount of enemies (max of 3 by default), or checkout the enemyData.gd file to create new enemies or modify pre-existing data
	await createEnemyTeam.setup(3, enemyArea, background, enemyContainer, enemyTeam, availableEnemies.info)
	
	assignTeams.assignRivals(playerTeam, enemyTeam)
	assignTeams.assignTeams(playerTeam, enemyTeam)
	assignTeams.assignAllies(playerTeam, enemyTeam)
	
	for foe in enemyTeam:
		await showHappeningText(["You encounter %s" % [foe.charName]])
	await showHappeningText(["Please choose your move"])
	
	actionMenu.togglePlayerActions()
	turnManager()

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed and !event.is_echo():
		if event.keycode == KEY_ENTER:
			enterPressed.emit()

func showHappeningText(message : Array) -> void:
	for text in message:
		happeningText.text = text
		await enterPressed

func setupButtonSounds(currentNode : Node) -> void:
	if currentNode is Button:
		currentNode.pressed.connect(func(): buttonSoundEffect.play())
	
	for child in currentNode.get_children():
		setupButtonSounds(child)

func enemyMove() -> void:
	for foe in enemyTeam:
		if (foe.alive):
			var enemyAction : int = randi_range(1, 6)
			if (enemyAction > 3):
				foe.action = foe.specialAbility
				foe.specialMoveName = foe.specialMoveList.pick_random()
				foe.target = foe
			else:
				foe.action = "Attack"
				print("ENEMY CHOSE ATTACK!!!!!!!!!!!")
				foe.target = foe.rivalTeam.pick_random()
			
			if (foe.specialMoveName in Global.offensiveSpecialMoves and foe.action != "Attack"):
				while true:
					foe.target = foe.rivalTeam.pick_random()
					if (foe.target.alive):
						break
			elif (foe.specialMoveName in Global.assistanceSpecialMoves and foe.action != "Attack"):
				foe.target = foe

func turnManager() -> void:
	while true:
		var charOrder : Array[Node] = []
		charOrder.append_array(enemyTeam)
		charOrder.append_array(playerTeam)
		
		charOrder.sort_custom(func(a, b): return a.speed > b.speed)
		
		for currentPlayer in playerTeam:
			if (currentPlayer.alive && !currentPlayer.statusEffect.has("charging")):
				actionMenu.currentPlayer = currentPlayer
				Global.trackPlayer(currentPlayer)
				actionMenu.changeColors()
				# ----------------------------------------
				actionMenu.specialButton.text = currentPlayer.specialAbility
				# ----------------------------------------
				# Move sprite up
				currentPlayer.myUI.playerSpriteMove("up")
				# ----------------------------------------
				currentPlayer.action = await actionMenu.playerChosenAction
				# ----------------------------------------
				# Move sprite down
				currentPlayer.myUI.playerSpriteMove("down")
				#-----------------------------------------
				print("FIGHT:: Player %s targeted %s" % [currentPlayer.charName, currentPlayer.target.charName])
				# ----------------------------------------
			elif (!currentPlayer.alive):
				currentPlayer.action = "nothing"
			else:
				currentPlayer.action = "Caipira Powers"
		enemyMove()
		
		actionMenu.togglePlayerActions()
		print("TURN STARTED")
		
		if (Global.enemyOrganizationTeam != null): charOrder.push_front(Global.enemyOrganizationTeam)
		
		if (Global.playerOrganizationTeam != null): charOrder.push_front(Global.playerOrganizationTeam)
		
		await executeTurn(charOrder)
		
		if (isPlayerTeamAlive && isEnemyTeamAlive):
			actionMenu.togglePlayerActions()
			print("TURN ENDED")
		else:
			break

func executeTurn(charOrder : Array[Node]) -> void:
	for userInfo in charOrder:
		print("CURRENTTURN: %s" % [userInfo.name])
		if (userInfo is player and userInfo.alive):
			userInfo.myUI.playerSpriteMove("up")
		
		# Test if there are no null targets (so it doesn't freaking crash):
		if userInfo.target != null:
			pass
		else:
			print("Aviso: ", userInfo.name, " não possui nenhum alvo definido!")
		
		if (userInfo is not organization):
			if (userInfo.statusEffect.has("burn") && userInfo.alive):
				await effects.burn(userInfo)
			print("%s STATUSEFFECTS:: %s" % [userInfo.charName, userInfo.statusEffect])
			if (userInfo.alive):
				if (!userInfo.statusEffect.has("freeze")):
					if (userInfo.statusEffect.has("confusion")):
						print("HAS CONFUSION")
						await effects.confusion(userInfo, playerTeam, enemyTeam)
					
					var canMove = true
					
					if (userInfo.statusEffect.has("paralysis")):
						canMove = await effects.paralysis(userInfo)
					
					if (canMove):
						await moveManager(userInfo, userInfo.target)
				else:
					await effects.freeze(userInfo)
			
			if (userInfo is player && isEnemyTeamAlive):
				userInfo.myUI.playerSpriteMove("down")
			
			if (!isPlayerTeamAlive || !isEnemyTeamAlive):
				break
			
			if (userInfo is enemy && userInfo.alive && userInfo.enemyMoves < 1):
				enemyMove()
				charOrder.push_front(userInfo)
				userInfo.enemyMoves += 1
		elif (userInfo is organization):
			await userActions.caipiraPowersManager(userInfo, userInfo.target)
			var willLeave : int = randi_range(1, 19999999)
			if (willLeave == 1):
				await showHappeningText(["The Organization team got tired from all their hard work and went to lunch."])
				
				if (userInfo.side == "player"):
					Global.playerOrganizationTeam = null
				elif (userInfo.side == "enemy"):
					Global.enemyOrganizationTeam = null
				
	for foe in enemyTeam:
		foe.enemyMoves = 0

func moveManager(userName : Node, targetName : Node):
	print("MOVEMANAGER:: %s targeted %s" % [userName.charName, targetName.charName])
	match userName.action:
		"Attack":
			await userActions.attack(userName, userName.target)
		"Heal":
			userName.target = userName
			await userActions.heal(userName, userName.target)
		"PSI":
			await userActions.psi(userName, userName.target)
		"Dark Arts":
			await userActions.darkArtsManager(userName, userName.target)
		"Dev Tools":
			await userActions.devToolsManager(userName, userName.target)
		"Caipira Powers":
			await userActions.caipiraPowersManager(userName, userName.target)
		"Friendship Magic":
			await userActions.friendshipMagicManager(userName, userName.target, playerTeam)
		"Innovation":
			await userActions.innovationManager(userName, userName.target, playerTeam)

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
			add_child(damageVisual)
			await damageVisual.playerDied(deffender.myUI.background)
		else:
			add_child(damageVisual)
			await damageVisual.enemyDied(deffender.myUI, deffender.myUI.enemySprite)
		
		await showHappeningText([deffender.deathMessage])
	
	isPlayerTeamAlive = playerTeam.any(
		func(playerChecked): return playerChecked.alive == true
	)
	
	isEnemyTeamAlive = enemyTeam.any(
		func(enemyChecked): return enemyChecked.alive == true
	)
	
	print("isPlayerTeamAlive: ", isPlayerTeamAlive)
	
	if (!isPlayerTeamAlive || !isEnemyTeamAlive):
		await endBattle()

func endBattle() -> void:
	if (isPlayerTeamAlive):
		backgroundMusic.switchMusic("res://Resources/Music/Coração verde e amarelo - Dr. Guilherme Berton.mp3")
		
		# Signal that battle ended to trigger color change
		happeningBackground.changeColors("victory")
		
		for member in playerTeam:
			if (member.alive):
				member.myUI.playerSpriteMove("up")
			else:
				member.myUI.playerSpriteMove("down")
		
		await showHappeningText(["You won! Vargem Grande do Sul and the universe are saved from Innovation!"])
	else:
		backgroundMusic.switchMusic("res://Resources/Music/MUSICA PARA MISTERIO - MUSIC FOR MYSTERY - MUSICA PARA RADIO Y TV - Chris Fernández.mp3")
		
		for member in Global.playerTeam:
			member.myUI.playerSpriteMove("down")
		
		# Signal that battle ended to trigger color change
		happeningBackground.changeColors("defeat")
		
		await showHappeningText(["You lost the battle... Innovation will consume and destroy Vargem Grande do Sul and the entire universe... Humanity is doomed..."])
