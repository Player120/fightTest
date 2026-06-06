extends Node
class_name devTools

func flippyBoard(user : Node, target : Node):
	var offenseBuff = randi_range(9, 33)
	user.offense += offenseBuff
	await owner.showHappeningText(["%s played some Flippy Board!" % [user.charName], "%s felt extremely motivated!" % [user.charName], "%s's offense went up by %d!" % [user.charName, offenseBuff]])

func vsCode(user : Node, target : Node):
	var determinationBuff = randi_range(16, 21)
	user.determination += determinationBuff
	await owner.showHappeningText(["%s used Visual Studio Code to fix some bugs in the TCC!" % [user.charName], "%s felt extremely confident!" % [user.charName], "%s's determination went up by %d!" % [user.charName, determinationBuff]])

func discordCall(user : Node, target : Array):
	await owner.showHappeningText(["%s invited everyone to a Discord Call!" % [user.charName], "Everyone laughed and had a great time!"])
	var healValue : int = 0
	
	for affected in target:
		if (affected.alive):
			healValue = randi_range(33, 177)
			var newHealth : int = affected.health + healValue
			
			if (newHealth <= affected.maxHealth):
				affected.health = newHealth
			else:
				healValue = affected.maxHealth - affected.health
				affected.health = affected.maxHealth
			
			owner.updateHealthText(affected)
			await owner.showHappeningText(["%s recovered %d HP!" % [affected.charName, healValue]])
