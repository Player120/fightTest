extends Node
class_name actions

@export var psiActions : psiMoves
@export var darkArtsActions : darkArts
@export var developmentTools : devTools
@export var caipiraAbilities : caipiraPowers
@export var friendshipMagicPowers : friendshipMagic
@export var innovationTactics : innovationTechnique
@export var effects : statusEffects

func attack(attacker : Node, defender : Node) -> void:
	await owner.showHappeningText(["%s is attacking!" % [attacker.charName]])
	
	if (defender.alive):
		var dodgeChance : int = randi_range(1, 100)
		
		if (dodgeChance > defender.speed or defender.statusEffect.has("paralysis") or defender.statusEffect.has("freeze")):
			const constantScale : float = 100.0
			var defenseMultiplier : float = constantScale / (constantScale + defender.defense)
			
			var damage : int = randi_range(attacker.offense - 5, attacker.offense + 10)
			if (damage <= 0):
				damage = 1
			damage = ceil(damage * defenseMultiplier)
			print("DAMAGE:: ", damage)
			
			var criticalChance : int = randi_range(1, 100)
			var criticalMessage : String = ""
			print("ATTACK:: Critical chance: %d" % [criticalChance])
			if (criticalChance <= attacker.determination):
				var criticalDamage = damage * 2.5
				print("ATTACK:: Critical Hit!!")
				damage = ceil(criticalDamage)
				criticalMessage = "A critical hit! "
			
			var damageMessage : String = " HP of damage to %s!" % [defender.charName]
			
			await Global.damageHandler(attacker, defender, damage, damageMessage, true, criticalMessage)
		else:
			await owner.showHappeningText(["%s dodged with style!" % [defender.charName]])
	else:
		await owner.showHappeningText(["%s is already dead idiot!" % [defender.charName]])

func heal(healer : Node, target : Node) -> void:
	await owner.showHappeningText(["%s is healing!" % [healer.charName]])
	var healValue : int = ceil(randi_range(50, 94) + (target.health * 0.1))
	var newHealth : int = target.health + healValue
	
	if (newHealth <= target.maxHealth):
		target.health = newHealth
	else:
		healValue = target.maxHealth - target.health
		target.health = target.maxHealth
	
	owner.updateHealthText(target)
	await owner.showHappeningText(["%s recovered %d HP!" % [target.charName, healValue]])

func psi(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s tried %s!" % [user.charName, user.specialMoveName]])
	match user.specialMoveName:
		"PK Starstorm":
			await psiActions.pkStarstorm(user, target)
		"PK Fire":
			await psiActions.pkFire(user, target)
		"PK Freeze":
			await psiActions.pkFreeze(user, target)
		_:
			await owner.showHappeningText(["Something went wrong: Invalid move in function psi() in actions.gd. Please restart the application."])

func darkArtsManager(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s used the dreaded %s dark art!" % [user.charName, user.specialMoveName]])
	match user.specialMoveName:
		"Anti-Innovation":
			await darkArtsActions.antiInnovation(user, target)
		"Globalization":
			await darkArtsActions.globalization(user, target)
		"Logarithms":
			await darkArtsActions.logarithms(user, target)

func devToolsManager(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s booted up the Dev Tools!" % [user.charName]])
	match user.specialMoveName:
		"Flippy Board":
			await developmentTools.flippyBoard(user, user.target)
		"VS Code":
			await developmentTools.vsCode(user, user.target)
		"Discord Call":
			await developmentTools.discordCall(user, user.target)

func caipiraPowersManager(user : Node, target : Node):
	match user.specialMoveName:
		"Thunderstorm":
			await caipiraAbilities.thunderStorm(user, target)
		"Nature Beam":
			await caipiraAbilities.natureBeam(user, target)
		"Organization":
			await caipiraAbilities.organizationActivate(user, target)

func friendshipMagicManager(user : Node, target : Node, playerTeam : Array[player]):
	match user.specialMoveName:
		"Friendship Star":
			await friendshipMagicPowers.friendshipStar(user, target)
		"Power Shield":
			await friendshipMagicPowers.powerShield(user, target)
		"Rainbow Comet":
			await friendshipMagicPowers.rainbowComet(user, target)
	# TODO: Add the friendship magic moves, including their entries in the manager, the script class, and the move's functions in there

func innovationManager(user : Node, target : Node, playerTeam : Array[player]):
	match user.specialMoveName:
		"Enroladinho":
			await innovationTactics.enroladinho(user)
		"Dark Room":
			await innovationTactics.darkRoom(user)
		"MySQL Hack":
			await innovationTactics.mysqlHack(user)
		"Innovation Singularity":
			await innovationTactics.innovationSingularity(user)
