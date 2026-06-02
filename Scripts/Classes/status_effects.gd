extends Node
class_name statusEffects

@export var bossStatus : boss

func burn(affected : Node) -> void:
	var stopBurning : int = randi_range(1, 3)
	
	if (stopBurning > 1 && affected.alive):
		await owner.showHappeningText(["%s is toasting!" % [affected.charName]])
		var damage : int = randi_range(5, 27)
		var damageMessage : String = "%s took %d HP of damage from the severe toasting!" % [affected.charName, damage]
		
		print("BURNTARGET BEFORE:: %d HP" % [affected.health])
		await damageHandler(affected, damage, damageMessage)
		print("BURNTARGET AFTER:: %d HP" % [affected.health])
	else:
		affected.statusEffect.erase("burn")
		await owner.showHappeningText(["%s stopped toasting!" % [affected.charName]])

func freeze(affected : Node) -> void:
	var unfreeze : int = randi_range(1, 3)
	if (unfreeze == 1):
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

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
