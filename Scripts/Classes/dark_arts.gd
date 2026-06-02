extends Node
class_name darkArts

func antiInnovation(user : Node, target : Node) -> void:
	var instaKill : int = randi_range(1, 3)
	
	if (instaKill == 1):
		target.health = 0
		owner.updateHealthText(target)
		await owner.showHappeningText(["%s was obliterated from existence!" % [target.charName]])
		await owner.testForDeath(target)
	else:
		await owner.showHappeningText(["It did not work very well!", "The dark art backfired to %s!" % [user.charName]])
		var damage : int = floor(user.health * 0.8)
		var damageMessage : String = "%d HP of recoil damage to %s!" % [damage, user.charName]
		await damageHandler(user, damage, damageMessage)

func globalization(user : Node, target : Node) -> void:
	var damage : int = randi_range(1, 363)
	await owner.showHappeningText(["Globalization deems equality.", "Globalization will make %s and %s lose %d HP!" % [user.charName, target.charName, damage]])
	
	await damageHandler(user, damage, "%d HP of equalization damage to %s!" % [damage, user.charName])
	if (owner.isSomeoneAlive):
		await damageHandler(target, damage, "%d HP of equalization damage to %s!" % [damage, target.charName])

func logarithms(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s learned about the horrors of Logarithms!" % [target.charName]])
	var willCare : int = randi_range(1, 2)
	
	if (willCare == 1 && !target.statusEffect.has("confusion")):
		await owner.showHappeningText(["%s felt lost trying to comprehend the incomprihensible complexity!" % [target.charName]])
		target.statusEffect.append("confusion")
	elif (!target.statusEffect.has("confusion")):
		await owner.showHappeningText(["%s did not care and felt extremely angry!" % [target.charName]])
		var increaseOffense : int = ceil(target.offense * 0.65)
		target.offense += increaseOffense
		await owner.showHappeningText(["%s's offense went up by %d!" % [target.charName, increaseOffense]])
	else:
		await owner.showHappeningText(["It had no visible effect on %s!" % [target.charName]])

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
