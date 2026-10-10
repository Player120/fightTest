extends Node
class_name darkArts

const animations : PackedScene = preload("res://Prefabs/visual_effects.tscn")

func antiInnovation(user : Node, target : Node) -> void:
	var finalTarget : Array = user.rivalTeam
	var vfx = animations.instantiate()
	add_child(vfx)
	
	if (randi_range(1, 2) == 1):
		vfx.startAnimation("Anti-Innovation")
	else:
		vfx.startAnimation("Anti-Innovation 2")
	await vfx.tree_exited
	
	# Accounting for if the user is confused or not
	var userScript = user.get_script()
	var targetScript = target.get_script()
	
	if (userScript == targetScript):
		finalTarget = user.allyTeam
	# --------------------------------------------------
	
	for defender in finalTarget:
		if (defender.alive):
			var instaKill : int = randi_range(1, 4)
			
			if (instaKill == 1):
				defender.health = 0
				owner.updateHealthText(defender)
				await owner.showHappeningText(["%s was obliterated from existence!" % [defender.charName]])
				await owner.testForDeath(defender)
			else:
				await owner.showHappeningText(["It did not work very well on %s!" % [defender.charName], "The dark art backfired to %s!" % [user.charName]])
				var damage : int = floor(user.health * 0.9)
				var damageMessage : String = "%d HP of recoil damage to %s!" % [damage, user.charName]
				await damageHandler(user, damage, damageMessage)

func globalization(user : Node, target : Node) -> void:
	var finalTarget : Array = user.rivalTeam
	var vfx = animations.instantiate()
	add_child(vfx)
	
	vfx.startAnimation("Globalization")
	await vfx.tree_exited
	
	# Accounting for if the user is confused or not
	var userScript = user.get_script()
	var targetScript = target.get_script()
	
	if (userScript == targetScript):
		finalTarget = user.allyTeam
	# --------------------------------------------------
	
	var damage : int = 242
	await owner.showHappeningText(["Globalization deems equality.", "Globalization will make %s lose %d HP and the enemy lose %d HP!" % [user.charName, damage, damage * 4]])
	
	await damageHandler(user, damage, "%d HP of equalization damage to %s!" % [damage, user.charName])
	
	if (owner.isPlayerTeamAlive && owner.isEnemyTeamAlive):
		for defender in finalTarget:
			if (defender.alive):
				await damageHandler(defender, damage * 4, "%d HP of equalization damage to %s!" % [damage * 4, defender.charName])

func logarithms(user : Node, target : Node) -> void:
	var finalTarget : Array = user.rivalTeam
	var vfx = animations.instantiate()
	add_child(vfx)
	
	vfx.startAnimation("Logarithms")
	await vfx.tree_exited
	
	# Accounting for if the user is confused or not
	var userScript = user.get_script()
	var targetScript = target.get_script()
	
	if (userScript == targetScript):
		finalTarget = user.allyTeam
	# --------------------------------------------------
	
	for defender in finalTarget:
		if (defender.alive):
			await owner.showHappeningText(["%s learned about the horrors of Logarithms!" % [defender.charName]])
			var willCare : int = randi_range(1, 2)
			
			if (willCare == 1 && !defender.statusEffect.has("confusion")):
				await owner.showHappeningText(["%s felt lost trying to comprehend the incomprehensible complexity of nonsense!" % [defender.charName]])
				defender.statusEffect.append("confusion")
			elif (!defender.statusEffect.has("confusion")):
				await owner.showHappeningText(["%s did not care and felt extremely angry!" % [defender.charName]])
				var increaseOffense : int = ceil(defender.offense * 0.65)
				defender.offense += increaseOffense
				await owner.showHappeningText(["%s's offense went up by %d!" % [defender.charName, increaseOffense]])
			else:
				await owner.showHappeningText(["It had no visible effect on %s!" % [defender.charName]])

func damageHandler(defender : Node, damage : int, message : String) -> void:
	defender.health -= damage
	owner.updateHealthText(defender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(defender)
