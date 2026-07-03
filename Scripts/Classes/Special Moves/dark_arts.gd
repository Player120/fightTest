extends Node
class_name darkArts

const animations = preload("res://Prefabs/visual_effects.tscn")

func antiInnovation(user : Node, target : Node) -> void:
	var vfx = animations.instantiate()
	add_child(vfx)
	
	if (randi_range(1, 2) == 1):
		vfx.startAnimation("Anti-Innovation")
	else:
		vfx.startAnimation("Anti-Innovation 2")
	await vfx.tree_exited
	
	var instaKill : int = randi_range(1, 4)
	
	if (instaKill == 1):
		target.health = 0
		owner.updateHealthText(target)
		await owner.showHappeningText(["%s was obliterated from existence!" % [target.charName]])
		await owner.testForDeath(target)
	else:
		await owner.showHappeningText(["It did not work very well!", "The dark art backfired to %s!" % [user.charName]])
		var damage : int = floor(user.health * 0.9)
		var damageMessage : String = "%d HP of recoil damage to %s!" % [damage, user.charName]
		await damageHandler(user, damage, damageMessage)

func globalization(user : Node, target : Node) -> void:
	var vfx = animations.instantiate()
	add_child(vfx)
	
	vfx.startAnimation("Globalization")
	await vfx.tree_exited
	
	var damage : int = randi_range(1, user.maxHealth)
	await owner.showHappeningText(["Globalization deems equality.", "Globalization will make %s and %s lose %d HP!" % [user.charName, target.charName, damage]])
	
	await damageHandler(user, damage, "%d HP of equalization damage to %s!" % [damage, user.charName])
	if (owner.isSomeoneAlive):
		await damageHandler(target, damage, "%d HP of equalization damage to %s!" % [damage, target.charName])

func logarithms(user : Node, target : Node) -> void:
	var vfx = animations.instantiate()
	add_child(vfx)
	
	vfx.startAnimation("Logarithms")
	await vfx.tree_exited
	
	await owner.showHappeningText(["%s learned about the horrors of Logarithms!" % [target.charName]])
	var willCare : int = randi_range(1, 2)
	
	if (willCare == 1 && !target.statusEffect.has("confusion")):
		await owner.showHappeningText(["%s felt lost trying to comprehend the incomprehensible complexity of nonsense!" % [target.charName]])
		target.statusEffect.append("confusion")
	elif (!target.statusEffect.has("confusion")):
		await owner.showHappeningText(["%s did not care and felt extremely angry!" % [target.charName]])
		var increaseOffense : int = ceil(target.offense * 0.65)
		target.offense += increaseOffense
		await owner.showHappeningText(["%s's offense went up by %d!" % [target.charName, increaseOffense]])
	else:
		await owner.showHappeningText(["It had no visible effect on %s!" % [target.charName]])

func damageHandler(defender : Node, damage : int, message : String) -> void:
	defender.health -= damage
	owner.updateHealthText(defender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(defender)
