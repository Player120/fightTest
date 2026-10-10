extends Node
class_name friendshipMagic

var animations = preload("res://Prefabs/visual_effects.tscn")
@export var effects : statusEffects

func friendshipStar(user : Node, target : Node):
	const ppCost : int = 23
	await owner.showHappeningText(["%s raised a magic wand and concentrated all of the party members' energy!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		var finalTarget = user.rivalTeam
		# Accounting for confusion status effect
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript == targetScript):
			finalTarget = user.allyTeam
		# ---------------------------------------
		
		await owner.showHappeningText(["%s launched a colorful and bright star towards the enemy!" % [user.charName]])
		
		var vfx = animations.instantiate()
		add_child(vfx)
		
		vfx.startAnimation("Friendship Star")
		await vfx.tree_exited
		
		var aliveQuantity : int = 0
		for member in user.allyTeam:
			if member.alive:
				aliveQuantity += 1
		
		for defender in finalTarget:
			if (defender.alive):
				var damage : int = ceil(randi_range(60, 120) * aliveQuantity * 1.5)
				
				var damageMessage : String = " HP of friendship damage to %s!" % [defender.charName]
		
				await damageHandler(user, defender, damage, damageMessage)

func powerShield(user : Node, target : Node):
	const ppCost : int = 18
	
	await owner.showHappeningText(["%s raised a magic wand releasing a dark blue flash!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		var finalTarget = user.allyTeam
		
		var vfx = animations.instantiate()
		add_child(vfx)
		
		vfx.startAnimation("Power Shield")
		await vfx.tree_exited
		
		# Accounting for confusion status effect
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript != targetScript):
			finalTarget = user.rivalTeam
		# ---------------------------------------
		
		await owner.showHappeningText(["A dark blue light enveloped all of the party members' bodies!"])
		
		for member in finalTarget:
			if (member.alive):
				if (member.shieldHealth == 0 && !member.statusEffect.has("shield")):
					member.statusEffect.append("shield")
					member.shieldHealth = 3
					await owner.showHappeningText(["%s's body was protected by the power shield!" % [member.charName]])
				else:
					member.shieldHealth += 2
					if (member.shieldHealth > 6):
						member.shieldHealth = 6
						
					await owner.showHappeningText(["%s's power shield became stronger!" % [member.charName]])

func rainbowComet(user : Node, target):
	const ppCost : int = 28
	await owner.showHappeningText(["%s looked down, then closed both hands together and chanted a magic spell!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		var buffedTeam : Array = user.allyTeam
		var damagedTeam : Array = user.rivalTeam
		await owner.showHappeningText(["Suddenly, a rainbow comet shooted from the sky and floated above the party!", "Everyone felt more united and powerful!"])
		
		var vfx = animations.instantiate()
		add_child(vfx)
		
		vfx.startAnimation("Rainbow Comet")
		await vfx.tree_exited
		
		# Accounting for confusion status effect
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript != targetScript):
			buffedTeam = user.rivalTeam
			damagedTeam = user.allyTeam
		# ---------------------------------------
		
		for member in buffedTeam:
			if (member.alive):
				var updatedStat : int = 0 # Created so I can show by how much the stat upped in the happening text (without creating a bazillion variables)
				
				updatedStat = randi_range(9, 18) # For offense
				member.offense += updatedStat
				await owner.showHappeningText(["%s's offense went up by %d!" % [member.charName, updatedStat]])
				
				updatedStat = randi_range(12, 22) # For defense
				member.defense += updatedStat
				await owner.showHappeningText(["%s's defense went up by %d!" % [member.charName, updatedStat]])
				
				updatedStat = randi_range(10, 30) # For speed
				member.speed += updatedStat
				await owner.showHappeningText(["%s's speed went up by %d!" % [member.charName, updatedStat]])
				
				updatedStat = randi_range(4, 18) # For determination
				member.determination += updatedStat
				await owner.showHappeningText(["%s's determination went up by %d!" % [member.charName, updatedStat]])
				
				updatedStat = randi_range(4, 7)
				if (member.maxPowerPoints > 0):
					var newPowerPoints : int = member.powerPoints + updatedStat
					
					if (newPowerPoints <= member.maxPowerPoints):
						member.powerPoints = newPowerPoints
					else:
						updatedStat = member.maxPowerPoints - member.powerPoints
						member.powerPoints = member.maxPowerPoints
					
					if (member is player):
						owner.updatepowerPointsText(member)
				else:
					updatedStat = 0
				await owner.showHappeningText(["%s recovered %d PP!" % [member.charName, updatedStat]])
		
		var randomTarget : Node
		
		while true:
			randomTarget = damagedTeam.pick_random()
			if (randomTarget.alive): break
		
		await owner.showHappeningText(["All of a sudden, the rainbow comet targeted and fell on top of %s!" % [randomTarget.charName]])
		var damage : int = randi_range(287, 417)
		var damageMessage : String = " HP of colorful damage to %s!" % [randomTarget.charName]
		
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
