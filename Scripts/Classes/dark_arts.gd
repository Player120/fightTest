extends Node
class_name darkArts

func antiInnovation(user : Node, target : Node) -> void:
	var instaKill : int = randi_range(1, 2)
	
	if (instaKill == 1):
		target.health = 0
		owner.updateHealthText(target)
		await owner.showHappeningText(["%s was obliterated from existence!" % [target.charName]])
		await owner.testForDeath(target)
	else:
		await owner.showHappeningText(["It did not work very well!", "The dark art backfired to %s!" % [user.charName]])
		var damage : int = randi_range(50, 100)
		var damageMessage : String = "%d HP of recoil damage to %s" % [damage, user.charName]
		await damageHandler(user, damage, damageMessage)

func globalization(user : Node, target : Node) -> void:
	var damage : int = randi_range(11, 66)
	await owner.showHappeningText(["Globalization deems equality.", "Globalization will make %s and %s lose %d HP!" % [user.charName, target.charName, damage]])
	
	await damageHandler(user, damage, "%d HP of equalization damage to %s!" % [damage, user.charName])
	await damageHandler(target, damage, "%d HP of equalization damage to %s!" % [damage, target.charName])

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
