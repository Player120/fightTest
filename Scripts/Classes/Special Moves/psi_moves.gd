extends Node
class_name psiMoves

const animations = preload("res://Prefabs/visual_effects.tscn")

func pkStarstorm(user : Node, target : Node) -> void:
	const ppCost : int = 18
	
	if (await ppDepleteHandler(user, ppCost)):
		var vfx = animations.instantiate()
		add_child(vfx)
		
		if (randi_range(1, 2) == 1):
			vfx.startAnimation("PK Starstorm")
		else:
			vfx.startAnimation("PK Starstorm 2")
		await vfx.tree_exited
		
		var damage : int = randi_range(144, 277)
		
		var damageMessage : String = "%d HP of ultra super star damage to %s!" % [damage, target.charName]
		
		await damageHandler(user.target, damage, damageMessage)

func pkFire(user : Node, target : Node):
	const ppCost : int = 7
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(42, 101)
		var willBurn : int = randi_range(1, 2)
		
		var damageMessage : String = "%d HP of toasting damage to %s!" % [damage, target.charName]
		
		await damageHandler(user.target, damage, damageMessage)
		
		if (!target.statusEffect.has("burn") && willBurn == 1 && target.alive):
			target.statusEffect.append("burn")
			await owner.showHappeningText(["%s has been burned!" % [target.charName]])

func pkFreeze(user : Node, target : Node) -> void:
	const ppCost : int = 6
	
	if (await ppDepleteHandler(user, ppCost)):
		var damage : int = randi_range(51, 87)
		var willFreeze : int = randi_range(1, 3)
		
		var damageMessage : String = "%d HP of freezing damage to %s!" % [damage, target.charName]
		
		await damageHandler(target, damage, damageMessage)
		
		if (willFreeze == 1 && !target.statusEffect.has("freeze") && target.alive):
			target.statusEffect.append("freeze")
			await owner.showHappeningText(["%s was frozen!" % [target.charName]])

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
