extends Node
class_name friendshipMagic


func friendshipStar(user : Node, target : Node, playerTeam : Array[player]):
	const ppCost : int = 19
	await owner.showHappeningText(["%s raised a magic wand and concentrated all of the party members' energy!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		await owner.showHappeningText(["%s launched a colorful and bright star towards %s from the magic wand!" % [user.charName, target.charName]])
		
		var aliveQuantity : int = 0
		for member in playerTeam:
			if member.alive:
				aliveQuantity += 1
		
		var damage : int = randi_range(30, 80) * aliveQuantity
		
		var damageMessage : String = "%d HP of friendship power damage to %s!" % [damage, target.charName]
		
		await damageHandler(target, damage, damageMessage)

func powerShield(user : Node, playerTeam : Array[player]):
	const ppCost : int = 18
	
	await owner.showHappeningText(["%s raised a magic wand releasing a dark blue flash!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		await owner.showHappeningText(["A dark blue light enveloped all of the party members' bodies!"])
		
		for member in playerTeam:
			if (member.alive):
				if (member.shieldHealth == 0 && !member.statusEffect.has("shield")):
					member.statusEffect.append("shield")
					member.shieldHealth = 3
					await owner.showHappeningText(["%s's body was protected by the power shield!" % [member.charName]])
				else:
					member.shieldHealth = 3
					await owner.showHappeningText(["%s's power shield became stronger!" % [member.charName]])

func rainbowComet(user : Node, target, playerTeam : Array[player]):
	const ppCost : int = 26
	await owner.showHappeningText(["%s looked down, then closed both hands together and chanted a magic spell!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		await owner.showHappeningText(["Suddenly, a rainbow comet shooted from the sky and floated above the party!", "Everyone felt more united and powerful!"])
		
		for member in playerTeam:
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
		
		await owner.showHappeningText(["All of a sudden, the rainbow comet targeted fell on top of %s!" % [target.charName]])
		var damage : int = randi_range(87, 107)
		var damageMessage : String = "%d HP of colorful damage to %s!" % [damage, target.charName]
		
		await damageHandler(target, damage, damageMessage)

func ppDepleteHandler(user : Node, amount : int) -> bool:
	if (user.powerPoints >= amount):
		user.powerPoints -= amount
		owner.updatepowerPointsText(user)
		return true
	else:
		await owner.showHappeningText(["Not enough PP!"])
		return false

func damageHandler(defender : Node, damage : int, message : String) -> void:
	defender.health -= damage
	owner.updateHealthText(defender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(defender)
