extends Node
class_name devTools

func flippyBoard(user : Node, target : Node):
	if (user.target.alive):
		var offenseBuff = randi_range(9, 33)
		user.target.offense += offenseBuff
		await owner.showHappeningText(["%s played some Flippy Board!" % [user.target.charName], "%s felt extremely motivated!" % [user.target.charName], "%s's offense went up by %d!" % [user.target.charName, offenseBuff]])
	else:
		await owner.showHappeningText(["%s tried to make %s play some Flippy Board!" % [user.charName, user.target.charName], "But %s is already dead!" % [user.target.charName]])

func vsCode(user : Node, target : Node):
	if (user.target.alive):
		var determinationBuff = randi_range(16, 21)
		print("DETERMINATION ", user.target.determination)
		user.target.determination += determinationBuff
		print("DETERMINATION AFTER ", user.target.determination)
		await owner.showHappeningText(["%s used Visual Studio Code to fix some bugs in the TCC!" % [user.target.charName], "%s felt extremely confident!" % [user.target.charName], "%s's determination went up by %d!" % [user.target.charName, determinationBuff]])
	else:
		await owner.showHappeningText(["%s tried to make %s fix some bugs in the TCC using Visual Studio Code!" % [user.charName, user.target.charName], "But %s is already dead!" % [user.target.charName]])

func discordCall(user : Node, target : Node):
	var finalTarget : Array = user.allyTeam
	await owner.showHappeningText(["%s invited everyone to a Discord Call!" % [user.charName], "Everyone laughed and had a great time!"])
	var healValue : int = 0
	
	# Accounting for confusion status effect
	var userScript = user.get_script()
	var targetScript = target.get_script()
	
	if (userScript != targetScript):
		finalTarget = user.rivalTeam
	# -----------------------------------------
	
	for affected in finalTarget:
		if (affected.alive):
			healValue = randi_range(33, 177)
			if (affected is enemy): healValue *= 2
			var newHealth : int = affected.health + healValue
			
			if (newHealth <= affected.maxHealth):
				affected.health = newHealth
			else:
				healValue = affected.maxHealth - affected.health
				affected.health = affected.maxHealth
			
			owner.updateHealthText(affected)
			await owner.showHappeningText(["%s recovered %d HP!" % [affected.charName, healValue]])
