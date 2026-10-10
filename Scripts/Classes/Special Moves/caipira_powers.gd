extends Node
class_name caipiraPowers

var animations : PackedScene = preload("res://Prefabs/visual_effects.tscn")

@export var effects : statusEffects

func thunderStorm(user : Node, target : Node):
	const ppCost : int = 12
	
	await owner.showHappeningText(["%s summoned a thunderstorm!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		var finalTarget : Array = []
		finalTarget.append_array(user.rivalTeam)
		await owner.showHappeningText(["All of a sudden, the sky became cloudy and started flashing!"])
		var lightningStrikes : int = randi_range(3, 8)
		
		# Accounting for confusion status effect
		if (user.statusEffect.has("confusion")):
			finalTarget.append_array(user.allyTeam)
		# -----------------------------------------
		
		for i in range(lightningStrikes):
			var willHit : int = randi_range(1, 2)
			var randomTarget : Node = finalTarget.pick_random()
			if (willHit == 1 && randomTarget.alive):
				var vfx = animations.instantiate()
				add_child(vfx)
				
				vfx.startAnimation("Thunderstorm")
				await vfx.tree_exited
				
				await owner.showHappeningText(["%s was struck by lightning!" % [randomTarget.charName]])
				
				var damage : int = randi_range(60, 104)
				var damageMessage : String = " HP of shocking damage to %s!" % [randomTarget.charName]
		
				await damageHandler(user, randomTarget, damage, damageMessage)
				
				var paralysisChance = randi_range(1, 10)
				if (paralysisChance == 1 && !randomTarget.statusEffect.has("paralysis") && randomTarget.alive):
					randomTarget.statusEffect.append("paralysis")
					await owner.showHappeningText(["%s's body became numb!" % [randomTarget.charName], "%s may not be able to move!" % [randomTarget.charName]])
			else:
				await owner.showHappeningText(["The lighting strike didn't hit anyone!"])

func natureBeam(user : Node, target : Node):
	const ppCost : int = 26
	
	if (!user.statusEffect.has("charging")):
		await owner.showHappeningText(["%s started absorbing the surrounding natural power!" % [user.charName]])
	
	if (!user.statusEffect.has("charging") && await ppDepleteHandler(user, ppCost)):
		user.statusEffect.append("charging")
		print("CHARGINGSTATUS:: ", user.statusEffect)
	elif (user.statusEffect.has("charging")):
		var finalTarget : Array = user.rivalTeam
		
		# Accounting for confusion status effect
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript == targetScript):
			finalTarget = user.allyTeam
		# ----------------------------------------
		
		await owner.showHappeningText(["%s fired Nature Beam!" % [user.charName]])
		
		for defender in finalTarget:
			if (defender.alive):
				var damage : int = randi_range(606, 808)
				var damageMessage : String = " HP of nature fury damage to %s!" % [defender.charName]
		
				await damageHandler(user, defender,damage, damageMessage)
				
				user.statusEffect.erase("charging")
				
				var randomStatusEffect : int = randi_range(1, 5)
				if (!defender.alive): randomStatusEffect = 0
				match randomStatusEffect:
					1:
						if (!defender.statusEffect.has("burn")):
							await owner.showHappeningText(["The power of the attack left %s toasting!" % [defender.charName]])
							defender.statusEffect.append("burn")
					2:
						if (!defender.statusEffect.has("freeze")):
							await owner.showHappeningText(["The power of the attack froze %s!" % [defender.charName]])
							defender.statusEffect.append("freeze")

func organizationActivate(user : Node, target : Node):
	const ppCost : int = 20
	
	if (user is not organization):
		await owner.showHappeningText(["%s summoned the hard working Organization team!" % [user.charName]])
		
		if (await ppDepleteHandler(user, ppCost)):
			var isAlreadyActive : bool = false
			
			# Checking if the organization is already active
			if (user is player):
				if (Global.playerOrganizationTeam != null):
					isAlreadyActive = true
			elif (user is enemy):
				if (Global.enemyOrganizationTeam != null):
					isAlreadyActive = true
			
			if (not isAlreadyActive):
				await owner.showHappeningText(["The Organization will protect %s and the teammates until lunch time!" % [user.charName]])
				
				Global.createOrganizationTeam(user)
				
				await organizationAttack(user.rivalTeam)
			else:
				await owner.showHappeningText(["But the Organization is already active!"])
		
	elif (user is organization):
		await organizationAttack(user.rivalTeam)

func organizationAttack(targetTeam : Array):
	await owner.showHappeningText(["The Organization started firing at the enemy team!"])
	# Had to create a user variable so it doesn't enter the
	# shield function as organization and crash,
	#  and the attribution just keeps the variable not-null
	var user : organization = Global.playerOrganizationTeam
	if (user == null): user = Global.enemyOrganizationTeam
	
	var shots : int = randi_range(4, 14)
	
	for i in range(shots):
		var randomTarget = targetTeam.pick_random()
		if (randomTarget.alive):
			var damage : int = randi_range(33, 64)
			var damageMessage : String = " HP of gratification damage to %s!" % [randomTarget.charName]
	
			await damageHandler(user, randomTarget, damage, damageMessage)

func ppDepleteHandler(user : Node, amount : int) -> bool:
	if (user.powerPoints >= amount):
		user.powerPoints -= amount
		if (user is player):
			owner.updatepowerPointsText(user)
		return true
	else:
		await owner.showHappeningText(["Not enough PP!"])
		return false

func damageHandler(attacker : Node, defender : Node, damage : int, message : String) -> void:
	var finalMessage : Array = []
	var shieldInfo : Array = []
	if (defender.statusEffect.has("shield") and attacker is not organization):
		shieldInfo = effects.shield(attacker, defender, damage)
		# shieldInfo positions: [0] damage | [1] reflected damage | [2] reflected message 1 | [3] reflected message 2 | [4] dissapeared message
		damage = shieldInfo[0]
		
	defender.health -= damage
	owner.updateHealthText(defender)
	finalMessage.append(str(damage) + message)
	await owner.showHappeningText(finalMessage)
	await owner.testForDeath(defender)
	
	if (owner.isPlayerTeamAlive and owner.isEnemyTeamAlive and not shieldInfo.is_empty() and attacker.alive):
		var reflectedMessages : Array[String] = [shieldInfo[2], shieldInfo[3]]
		finalMessage = reflectedMessages
		
		attacker.health -= shieldInfo[1]
		
		await owner.showHappeningText([finalMessage[0]])
		owner.updateHealthText(attacker)
		await owner.showHappeningText([finalMessage[1]])
		await owner.testForDeath(attacker)
		if (shieldInfo.size() > 4 and owner.isPlayerTeamAlive and owner.isEnemyTeamAlive):
			await owner.showHappeningText([shieldInfo[4]])
	elif (owner.isPlayerTeamAlive and owner.isEnemyTeamAlive and shieldInfo.size() > 4):
		await owner.showHappeningText([shieldInfo[4]])
