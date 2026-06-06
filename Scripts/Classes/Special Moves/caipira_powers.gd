extends Node
class_name caipiraPowers

func thunderStorm(user : Node, target : Node):
	const ppCost : int = 14
	
	await owner.showHappeningText(["%s summoned a thunderstorm!" % [user.charName]])
	
	if (await ppDepleteHandler(user, ppCost)):
		await owner.showHappeningText(["All of a sudden, the sky became cloudy and started flashing!"])
		var lightningStrikes : int = randi_range(1, 7)
		
		for i in range(lightningStrikes):
			var willHit : int = randi_range(1, 2)
			if (willHit == 1):
				await owner.showHappeningText(["%s was struck by lightning!" % [target.charName]])
				var damage : int = randi_range(30, 104)
				await damageHandler(target, damage, "%d HP of shocking damage to %s!" % [damage, target.charName])
				
				var paralysisChance = randi_range(1, 10)
				if (paralysisChance == 1 && !target.statusEffect.has("paralysis")):
					target.statusEffect.append("paralysis")
					await owner.showHappeningText(["%s's body became numb!" % [target.charName], "%s may not be able to move!" % [target.charName]])
			else:
				await owner.showHappeningText(["The lighting strike didn't hit anyone!"])

func natureBeam(user : Node, target : Node):
	const ppCost : int = 27
	
	if (!user.statusEffect.has("charging")):
		await owner.showHappeningText(["%s started absorbing the surrounding natural power!" % [user.charName]])
	
	if (!user.statusEffect.has("charging") && await ppDepleteHandler(user, ppCost)):
		user.statusEffect.append("charging")
		print("CHARGINGSTATUS:: ", user.statusEffect)
	elif (user.statusEffect.has("charging")):
		var damage : int = randi_range(303, 505)
		
		await owner.showHappeningText(["%s fired Nature Beam!" % [user.charName]])
		
		await damageHandler(user.target, damage, "%d HP of nature fury damage to %s!" % [damage, target.charName])
		
		user.statusEffect.erase("charging")
		
		var randomStatusEffect : int = randi_range(1, 5)
		match randomStatusEffect:
			1:
				if (!target.statusEffect.has("burn")):
					await owner.showHappeningText(["The power of the attack left %s toasting!" % [target.charName]])
					target.statusEffect.append("burn")
			2:
				if (!target.statusEffect.has("freeze")):
					await owner.showHappeningText(["The power of the attack froze %s!" % [target.charName]])
					target.statusEffect.append("freeze")

func organizationActivate(user : Node, target : Node):
	const ppCost : int = 20
	
	if (!owner.organizationActive && !(user.name == "npc")):
		await owner.showHappeningText(["%s summoned the Organization team!" % [user.charName]])
		
		if (await ppDepleteHandler(user, ppCost)):
			await owner.showHappeningText(["The Organization will protect %s until lunch time!" % [user.charName]])
			owner.organizationActive = true
			
			await organizationAttack(target)
		
	elif (user.name == "npc"):
		await organizationAttack(target)
	else:
		await owner.showHappeningText(["%s summoned the Organization team!" % [user.charName]])
		
		await owner.showHappeningText(["The Organization is already active!"])

func organizationAttack(target : Node):
	await owner.showHappeningText(["The Organization started firing at %s!" % [target.charName]])
	
	var shots : int = randi_range(1, 10)
	
	for i in range(shots):
		var damage : int = randi_range(12, 34)
		await damageHandler(target, damage, "%d HP of gratification damage to %s!" % [damage, target.charName])
		
		if (!target.alive):
			break

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
