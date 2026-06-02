extends Node
class_name psiMoves

func pkStarstorm(user : Node, target : Node) -> void:
	const ppCost : int = 10
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(50, 70)
		
		var damageMessage : String = "%d HP of ultra damage to %s!" % [damage, target.charName]
		
		await damageHandler(user.target, damage, damageMessage)

func pkFire(user : Node, target : Node):
	const ppCost : int = 6
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(20, 40)
		var willBurn : int = randi_range(1, 2)
		
		var damageMessage : String = "%d HP of toasting damage to %s!" % [damage, target.charName]
		
		await damageHandler(user.target, damage, damageMessage)
		
		if (!target.statusEffect.has("burn") && willBurn == 1 && target.alive):
			target.statusEffect.append("burn")
			await owner.showHappeningText(["%s has been burned!" % [target.charName]])

func pkFreeze(user : Node, target : Node) -> void:
	const ppCost : int = 4
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(10, 20)
		var willFreeze : int = randi_range(1, 3)
		
		var damageMessage : String = "%d HP of freezing damage to %s!" % [damage, target.charName]
		
		await damageHandler(target, damage, damageMessage)
		
		if (willFreeze == 1 && !target.statusEffect.has("freeze") && target.alive):
			target.statusEffect.append("freeze")
			await owner.showHappeningText(["%s was frozen!" % [target.charName]])

func ppDepleteHandler(user : Node, amount : int) -> bool:
	if (user.psychicPoints >= amount):
		user.psychicPoints -= amount
		owner.updatePsychicPointsText(user)
		return true
	else:
		await owner.showHappeningText(["Not enough PP!"])
		return false

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
