extends Node
class_name innovationTechnique

func enroladinho(user : Node):
	if (user.target.alive):
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
	else:
		await owner.showHappeningText(["%s pulled up a delicious Enroladinho and tried to give it to %s!" % [user.charName, user.target.charName], "But %s was already dead!" % [user.target.charName]])

func darkRoom(user : Node):
	var finalTarget = user.rivalTeam
	await owner.showHappeningText(["All of a sudden, %s teleported everyone to an empty dark room!" % [user.charName], "Then, an awful smell contaminated the area!"])
	
	var updatedStats : int = 0 # Unique variable to show how much each stat increased in the happening text
	
	# Accounting for confusion status effect
	var userScript = user.get_script()
	var targetScript = user.target.get_script()
	
	if (userScript == targetScript):
		finalTarget = user.allyTeam
	# ----------------------------------------
	
	for member in finalTarget:
		if (member.alive):
			updatedStats = randi_range(7, 16) # For offense
			member.offense -= updatedStats
			await owner.showHappeningText(["%s's offense went down by %d!" % [member.charName, updatedStats]])
			
			updatedStats = randi_range(12, 21) # For defense
			member.defense -= updatedStats
			await owner.showHappeningText(["%s's defense went down by %d!" % [member.charName, updatedStats]])
			
			updatedStats = randi_range(50, 110) # For damage
			var damageMessage : String = " HP of damage from the horrid smell!" % [member.charName, updatedStats]
			await Global.damageHandler(user, member, updatedStats, damageMessage, true, "%s took " % [member.charName])

func mysqlHack(user : Node):
	if (user.target.alive):
		await owner.showHappeningText(["%s showed %s a never-before-seen MySQL hack!" % [user.charName, user.target.charName]])
		
		var damage : int = randi_range(30, 90)
		var damageMessage : String = " HP of damage from the overwhelming amount of innovation!" % [damage, user.target.charName]
		await Global.damageHandler(user, user.target, damage, damageMessage, true, "%s took " % [user.target.charName])
		
		var willParalyse = randi_range(1, 3)
		if (user.target.alive && willParalyse == 1 && !user.target.statusEffect.has("paralysis")):
			await owner.showHappeningText(["The shock from the deadly levels of innovation left %s paralysed!" % [user.target.charName]])
			user.target.statusEffect.append("paralysis")
			user.speed = floor(user.speed / 2)
	else:
		await owner.showHappeningText(["%s tried to show %s a never-before-seen MySQL hack!" % [user.charName, user.target.charName], "But %s was already dead!" % [user.target.charName]])

func innovationSingularity(user : Node):
	await owner.showHappeningText(["%s achieved the Ultra Innovation Singularity!" % [user.charName]])
	
	await owner.showHappeningText(["You cannot comprehend the Innovation of %s's move!" % [user.charName]])
	
	var randomSpecialClass : String = ""
	var randomArray : Array = []
	var randomSpecialMove : String = ""
	
	while true:
		randomSpecialClass = Global.specialMoveslist.keys().pick_random()
		randomArray = Global.specialMoveslist[randomSpecialClass]
		randomSpecialMove = randomArray.pick_random()
		if (randomSpecialClass != "Innovation" and randomSpecialMove != "Nature Beam"):
			break
			
	if (randomSpecialMove in Global.offensiveSpecialMoves):
		while true:
			user.target = user.rivalTeam.pick_random()
			if (user.target.alive):
				break
	elif (randomSpecialMove in Global.assistanceSpecialMoves):
		user.target = user
	
	user.action = randomSpecialClass
	user.specialMoveName = randomSpecialMove
	await owner.moveManager(user, user.target)
