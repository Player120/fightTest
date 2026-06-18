extends Node
class_name innovationTechnique

func enroladinho(user : Node, playerTeam : Array[player]):
	if (user.statusEffect.has("confusion")):
		while true:
			user.target = playerTeam.pick_random()
			if (user.target.alive):
				break
	
	await owner.showHappeningText(["%s pulled up a delicious enroladinho and %s ate it!" % [user.charName, user.target.charName], "%s felt stronger!" % [user.target.charName]])
	
	var updatedStats : int = 0 # Unique variable to show how much each stat increased in the happening text
	
	updatedStats = randi_range(150, 360) # For health
	# --------------------------------------------------------
	var newHealth : int = user.target.health + updatedStats
	
	if (newHealth <= user.target.maxHealth):
		user.target.health = newHealth
	else:
		updatedStats = user.target.maxHealth - user.target.health
		user.target.health = user.target.maxHealth
	# --------------------------------------------------------
	owner.updateHealthText(user.target)
	await owner.showHappeningText(["%s recovered %d HP!" % [user.target.charName, updatedStats]])
	
	updatedStats = randi_range(12, 22) # For offense
	user.target.offense += updatedStats
	await owner.showHappeningText(["%s's offense went up by %d!" % [user.target.charName, updatedStats]])
	
	updatedStats = randi_range(5, 12) # For defense
	user.target.defense += updatedStats
	await owner.showHappeningText(["%s's defense went up by %d!" % [user.target.charName, updatedStats]])
	
	updatedStats = randi_range(4, 8) # For speed
	user.target.speed += updatedStats
	await owner.showHappeningText(["%s's speed went up by %d!" % [user.target.charName, updatedStats]])
	
	updatedStats = randi_range(2, 5) # For determination
	user.target.determination += updatedStats
	await owner.showHappeningText(["%s's determination went up by %d!" % [user.target.charName, updatedStats]])

func darkRoom(user : Node, playerTeam : Array[player]):
	await owner.showHappeningText(["All of a sudden, %s teleported everyone to an empty dark room!" % [user.charName], "Then, an awful smell contaminated the area!"])
	
	var updatedStats : int = 0 # Unique variable to show how much each stat increased in the happening text
	
	if (!user.statusEffect.has("confusion")):
		for member in playerTeam:
			if (member.alive):
				updatedStats = randi_range(7, 16) # For offense
				member.offense -= updatedStats
				await owner.showHappeningText(["%s's offense went down by %d!" % [member.charName, updatedStats]])
				
				updatedStats = randi_range(12, 21) # For defense
				member.defense -= updatedStats
				await owner.showHappeningText(["%s's defense went down by %d!" % [member.charName, updatedStats]])
				
				updatedStats = randi_range(50, 110) # For damage
				var damageMessage : String = "%s took %d HP of damage from the horrid smell!" % [member.charName, updatedStats]
				await damageHandler(member, updatedStats, damageMessage)
	else:
		updatedStats = randi_range(7, 16) # For offense
		user.offense -= updatedStats
		await owner.showHappeningText(["%s's offense went down by %d!" % [user.charName, updatedStats]])
		
		updatedStats = randi_range(12, 21) # For defense
		user.defense -= updatedStats
		await owner.showHappeningText(["%s's defense went down by %d!" % [user.charName, updatedStats]])
		
		updatedStats = randi_range(50, 110) # For damage
		var damageMessage : String = "%s took %d HP of damage from the horrid smell!" % [user.charName, updatedStats]
		await damageHandler(user, updatedStats, damageMessage)

func mysqlHack(user : Node):
	if (user.statusEffect.has("confusion")):
		user.target = user
	
	await owner.showHappeningText(["%s showed %s a never-seen-before MySQL hack!" % [user.charName, user.target.charName]])
	
	var damage : int = randi_range(30, 90)
	var damageMessage : String = "%d HP of damage to %s from the overwhelming amount of innovation!" % [damage, user.target.charName]
	await damageHandler(user.target, damage, damageMessage)
	
	var willParalyse = randi_range(1, 3)
	if (user.target.alive && willParalyse == 1 && !user.target.statusEffect.has("paralysis")):
		await owner.showHappeningText(["The shock from the deadly levels of innovation left %s paralysed!" % [user.target.charName]])
		user.target.statusEffect.append("paralysis")

func damageHandler(defender : Node, damage : int, message : String) -> void:
	defender.health -= damage
	owner.updateHealthText(defender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(defender)
