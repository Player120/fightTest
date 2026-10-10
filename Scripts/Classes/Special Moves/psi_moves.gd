extends Node
class_name psiMoves

const animations : PackedScene = preload("res://Prefabs/visual_effects.tscn")

@export var effects : statusEffects

func pkStarstorm(user : Node, target : Node) -> void:
	const ppCost : int = 20
	
	if (await ppDepleteHandler(user, ppCost)):
		var finalTarget : Array = user.rivalTeam
		var vfx = animations.instantiate()
		add_child(vfx)
		
		if (randi_range(1, 2) == 1):
			vfx.startAnimation("PK Starstorm")
		else:
			vfx.startAnimation("PK Starstorm 2")
		await vfx.tree_exited
		
		# Accounting for if the user is confused or not
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript == targetScript):
			finalTarget = user.allyTeam
		# --------------------------------------------------
		
		for defender in finalTarget:
			if (defender.alive):
				var damage : int = randi_range(344, 577)
		
				var damageMessage : String = " HP of ultra super star damage to %s!" % [defender.charName]
		
				await damageHandler(user, defender, damage, damageMessage)

func pkFire(user : Node, target : Node) -> void:
	const ppCost : int = 12
	
	if (await ppDepleteHandler(user, ppCost)):
		var finalTarget : Array = user.rivalTeam
		var vfx = animations.instantiate()
		add_child(vfx)
		
		if (randi_range(1, 2) == 1):
			vfx.startAnimation("PK Fire")
		else:
			vfx.startAnimation("PK Fire 2")
		await vfx.tree_exited
		
		# Accounting for if the user is confused or not
		var userScript = user.get_script()
		var targetScript = target.get_script()
		
		if (userScript == targetScript):
			finalTarget = user.allyTeam
		# --------------------------------------------------
		
		for defender in finalTarget:
			if (defender.alive):
				var damage : int = randi_range(121, 221)
				var willBurn : int = randi_range(1, 2)
			
				var damageMessage : String = " HP of toasting damage to %s!" % [defender.charName]
			
				await damageHandler(user, defender, damage, damageMessage)
			
				if (!defender.statusEffect.has("burn") && willBurn == 1 && defender.alive):
					defender.statusEffect.append("burn")
					await owner.showHappeningText(["%s has been burned!" % [defender.charName]])

func pkFreeze(user : Node, target : Node) -> void:
	const ppCost : int = 8
	
	if (await ppDepleteHandler(user, ppCost)):
		var vfx = animations.instantiate()
		add_child(vfx)
		
		vfx.startAnimation("PK Freeze")
		await vfx.tree_exited
		
		if (target.alive):
			var damage : int = randi_range(260, 360)
			var willFreeze : int = randi_range(1, 3)
			
			var damageMessage : String = " HP of freezing damage to %s!" % [target.charName]
			
			await damageHandler(user, target, damage, damageMessage)
			
			if (willFreeze == 1 && !target.statusEffect.has("freeze") && target.alive):
				target.statusEffect.append("freeze")
				await owner.showHappeningText(["%s was frozen!" % [target.charName]])
		else:
			await owner.showHappeningText(["%s is already dead idiot!" % [target.charName]])

func ppDepleteHandler(user : Node, amount : int) -> bool:
	if (user.powerPoints >= amount):
		user.powerPoints -= amount
		if (user is player):
			owner.updatepowerPointsText(user)
		return true
	else:
		await owner.showHappeningText(["Not enough PP!"])
		return false

func damageHandler(attacker : Node, defender : Node, damage : int, message : String) -> void:
	var finalMessage : Array = []
	var shieldInfo : Array = []
	if (defender.statusEffect.has("shield")):
		shieldInfo = effects.shield(attacker, defender, damage)
		# shieldInfo positions: [0] damage | [1] reflected damage | [2] reflected message 1 | [3] reflected message 2 | [4] dissapeared message
		damage = shieldInfo[0]
		
	defender.health -= damage
	owner.updateHealthText(defender)
	finalMessage.append(str(damage) + message)
	await owner.showHappeningText(finalMessage)
	await owner.testForDeath(defender)
	
	if (owner.isPlayerTeamAlive and owner.isEnemyTeamAlive and not shieldInfo.is_empty() and attacker.alive):
		var reflectedMessages : Array[String] = [shieldInfo[2], shieldInfo[3]]
		finalMessage = reflectedMessages
		
		attacker.health -= shieldInfo[1]
		
		await owner.showHappeningText([finalMessage[0]])
		owner.updateHealthText(attacker)
		await owner.showHappeningText([finalMessage[1]])
		await owner.testForDeath(attacker)
		if (shieldInfo.size() > 4 and owner.isPlayerTeamAlive and owner.isEnemyTeamAlive):
			await owner.showHappeningText([shieldInfo[4]])
	elif (owner.isPlayerTeamAlive and owner.isEnemyTeamAlive and shieldInfo.size() > 4):
		await owner.showHappeningText([shieldInfo[4]])
