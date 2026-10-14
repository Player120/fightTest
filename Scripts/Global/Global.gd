extends Node

var isSelectingEnemy : bool = false
var currentPlayer : player
var playerTeam : Array[player] = []
var enemyTeam : Array[enemy] = []
var defaultPlayerNames : Array[String] = [
	"Rafa", "Otávio", "Gabriel",
	"Breno", "Neto"
]
var customPlayerNames : Array[String] = []
var playerOrganizationTeam : organization = null
var enemyOrganizationTeam : organization = null
var fightScript : Control
var effects : statusEffects = statusEffects.new()

signal enemyChosen
signal hoveringEnemy(enemyName : String)

const specialMoveslist : Dictionary = {
	"PSI": ["PK Starstorm", "PK Fire", "PK Freeze"],
	"Dark Arts": ["Anti-Innovation", "Globalization", "Logarithms"],
	"Dev Tools": ["Flippy Board", "VS Code", "Discord Call"],
	"Caipira Powers": ["Thunderstorm", "Nature Beam", "Organization"],
	"Friendship Magic": ["Friendship Star", "Power Shield", "Rainbow Comet"],
	"Innovation": ["Enroladinho", "Dark Room", "MySQL Hack", "Innovation Singularity"]
}
const offensiveSpecialMoves : Array[String] = [
	"PK Starstorm", "PK Fire", "PK Freeze", # PSI
	"Anti-Innovation", "Globalization", "Logarithms", # Dark Arts
	"Thunderstorm", "Nature Beam", "Organization", # Caipira Powers
	"Friendship Star", # Friendship Power
	"Dark Room", "MySQL Hack", "Innovation Singularity" # Innovation
]
const assistanceSpecialMoves : Array[String] = [
	"Flippy Board", "VS Code", "Discord Call", # Dev Tools
	"Power Shield", "Rainbow Comet", # Friendship Magic
	"Enroladinho" # Innovation
]


func trackPlayer(current : player) -> void:
	currentPlayer = current
	print("GLOBAL:: Current tracked Player is %s (Node Name: %s)" % [currentPlayer.charName, currentPlayer])

func setTarget(target) -> void:
	currentPlayer.target = target
	print("GLOBAL:: Player %s selected the enemy %s as a target" % [currentPlayer.charName, currentPlayer.target.charName])
	enemyChosen.emit()

func enableEnemySelection() -> void:
	isSelectingEnemy = true
	print("GLOBAL:: Enemy selection is ENABLED")

func disableEnemySelection() -> void:
	isSelectingEnemy = false
	print("GLOBAL:: Enemy selection is DISABLED")

func createOrganizationTeam(user : Node) -> void:
	var newOrganization = organization.new()
	if (user is player):
		newOrganization.side = "player"
		newOrganization.rivalTeam = enemyTeam
		playerOrganizationTeam = newOrganization
	elif (user is enemy):
		newOrganization.side = "enemy"
		newOrganization.rivalTeam = playerTeam
		enemyOrganizationTeam = newOrganization

func damageHandler(attacker : Node, defender : Node, damage : int, message : String, canBeReflected : bool = true, additionalMessage : String = "") -> void:
	var finalMessage : Array = []
	var shieldInfo : Array = []
	var damageVisual : damageVisualEffect = damageVisualEffect.new()
	
	if (defender.statusEffect.has("shield") and canBeReflected):
		shieldInfo = effects.shield(attacker, defender, damage)
		# shieldInfo positions: [0] damage | [1] reflected damage | [2] reflected message 1 | [3] reflected message 2 | [4] dissapeared message
		damage = shieldInfo[0]
		
	defender.health -= damage
	fightScript.updateHealthText(defender)
	finalMessage.append(additionalMessage + str(damage) + message)
	
	if (defender is player):
		add_child(damageVisual)
		await damageVisual.playerTookDamage(fightScript, damage)
	elif (defender is enemy):
		add_child(damageVisual)
		await damageVisual.enemyTookDamage(defender.myUI.enemySprite)
		
	await fightScript.showHappeningText(finalMessage)
	await fightScript.testForDeath(defender)
	
	if (fightScript.isPlayerTeamAlive and fightScript.isEnemyTeamAlive and not shieldInfo.is_empty() and attacker.alive):
		var reflectedMessages : Array[String] = [shieldInfo[2], shieldInfo[3]]
		finalMessage = reflectedMessages
		
		attacker.health -= shieldInfo[1]
		
		await fightScript.showHappeningText([finalMessage[0]])
		
		if (defender is enemy):
			add_child(damageVisual)
			await damageVisual.playerTookDamage(fightScript, damage)
		elif (defender is player):
			add_child(damageVisual)
			await damageVisual.enemyTookDamage(attacker.myUI.enemySprite)
		
		fightScript.updateHealthText(attacker)
		await fightScript.showHappeningText([finalMessage[1]])
		await fightScript.testForDeath(attacker)
		if (shieldInfo.size() > 4 and fightScript.isPlayerTeamAlive and fightScript.isEnemyTeamAlive):
			await fightScript.showHappeningText([shieldInfo[4]])
