extends Node
class_name psiMoves

@export var playerStatus : player

func pkStarstorm(user : Node, target : Node) -> void:
	const ppCost : int = 10
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(50, 70)
		damageHandler(user.target, damage)
		await owner.showHappeningText(["%d HP of ultra damage to %s!" % [damage, target.charName]])

func pkFire(user : Node, target : Node):
	const ppCost : int = 6
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(20, 40)
		var willBurn : int = randi_range(1, 2)
		
		damageHandler(user.target, damage)
		await owner.showHappeningText(["%d HP of toasting damage to %s!" % [damage, target.charName]])
		
		if (!target.statusEffect.has("burn") && willBurn == 1):
			target.statusEffect.append("burn")
			await owner.showHappeningText(["%s has been burned!" % [target.charName]])

func pkFreeze(user : Node, target : Node) -> void:
	const ppCost : int = 4
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(10, 20)
		var willFreeze : int = randi_range(1, 3)
		
		damageHandler(target, damage)
		await owner.showHappeningText(["%d HP of freezing damage to %s!" % [damage, target.charName]])
		
		if (willFreeze == 1 && !target.statusEffect.has("freeze")):
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

func damageHandler(deffender : Node, damage : int) -> void:
	deffender.health -= damage
	
	owner.updateHealthText(deffender)
	owner.testForDeath(deffender)
