extends Node
class_name statusEffects

@export var bossStatus : boss

func burn(affected : Node) -> void:
	var stopBurning : int = randi_range(1, 4)
	
	if (stopBurning > 1 && affected.alive):
		await owner.showHappeningText(["%s is toasting!" % [affected.charName]])
		var damage : int = randi_range(12, 33)
		var damageMessage : String = "%s took %d HP of damage from the severe toasting!" % [affected.charName, damage]
		
		print("BURNTARGET BEFORE:: %d HP" % [affected.health])
		await damageHandler(affected, damage, damageMessage)
		print("BURNTARGET AFTER:: %d HP" % [affected.health])
	else:
		affected.statusEffect.erase("burn")
		await owner.showHappeningText(["%s stopped toasting!" % [affected.charName]])

func freeze(affected : Node) -> void:
	var unfreeze : int = randi_range(1, 3)
	if (unfreeze != 1):
		await owner.showHappeningText(["%s is frozen and can't move!" % [affected.charName]])
	elif (affected.alive):
		affected.statusEffect.erase("freeze")
		await owner.showHappeningText(["%s has unfrozen!" % [affected.charName]])

func confusion(affected : Node) -> void:
	var stopConfusion : int = randi_range(1, 3)
	print("STOPCONFUSION:: ", stopConfusion)
	if (stopConfusion != 1):
		var confusionMessages : Array[String] = ["is so confused!", "is acting a bit unusual...", "is feeling very funky...", "is completely lost!", "is daydreaming about innovation!"]
		
		var chosenMessage : String = confusionMessages.pick_random()
		await owner.showHappeningText(["%s %s" % [affected.charName, chosenMessage]])
		
		affected.target = affected
	else:
		affected.statusEffect.erase("confusion")
		await owner.showHappeningText(["%s felt lucid again!" % [affected.charName]])

func paralysis(affected : Node) -> bool:
	var canMove : int = randi_range(1, 2)
	if (canMove == 1):
		return true
	else:
		await owner.showHappeningText(["%s is paralysed and can't move!" % [affected.charName]])
		return false

func shield(attacker : Node, affected : Node, damage : int, criticalMessage : String) -> void:
	var blockedDamage : int = ceil(damage * 0.4)
	print("DAMAGE BEFORE SHIELD:: ", damage)
	damage *= 0.5
	print("DAMAGE AFTER SHIELD:: ", damage)
	
	var damageMessage : String = "%s%d HP of damage to %s!" % [criticalMessage, damage, affected.charName]
	
	await damageHandler(affected, damage, damageMessage)
	
	if (owner.isSomeoneAlive):
		owner.showHappeningText(["%s's power shield reflected the attack!" % [affected.charName]])
		
		var reflectedMessage : String =  "%d HP of reflected damage to %s!" % [blockedDamage, attacker.charName]
		
		await damageHandler(attacker, blockedDamage, reflectedMessage)
		
		affected.shieldHealth -= 1
		if (affected.shieldHealth <= 0):
			affected.shieldHealth = 0
			affected.statusEffect.erase("shield")
			await owner.showHappeningText(["%s's power shield dissapeared!" % [affected.charName]])

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
