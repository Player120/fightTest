extends Node
class_name statusEffects

@export var enemyStatus : enemy

func burn(affected : Node) -> void:
	var stopBurning : int = randi_range(1, 5)
	
	if (stopBurning > 1 && affected.alive):
		await owner.showHappeningText(["%s is toasting!" % [affected.charName]])
		var damage : int = randi_range(44, 101)
		var damageMessage : String = " HP of damage from the severe toasting!" % [affected.charName, damage]
		
		print("BURNTARGET BEFORE:: %d HP" % [affected.health])
		await Global.damageHandler(affected, affected, damage, damageMessage, false, "%s took " % [affected.charName])
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

func confusion(affected : Node, playerTeam : Array[player], enemyTeam : Array[enemy]) -> void:
	var stopConfusion : int = randi_range(1, 4)
	print("STOPCONFUSION:: ", stopConfusion)
	if (stopConfusion != 1):
		var confusionMessages : Array[String] = ["is so confused!", "is acting a bit unusual...", "is feeling very funky...", "is completely lost!", "is daydreaming about innovation!", "cannot comprehend what is happening anymore!", "is thinking about dinner...", "is confused confused and wants to play Etec Evil: Lost Breno!", "feels lost and wished to play Five Nights at Inova Capixaba!", "went crazy!"]
		
		var chosenMessage : String = confusionMessages.pick_random()
		await owner.showHappeningText(["%s %s" % [affected.charName, chosenMessage]])
		
		var allCharacters : Array
		allCharacters.append_array(playerTeam)
		allCharacters.append_array(enemyTeam)
		
		affected.target = allCharacters.pick_random()
	else:
		affected.statusEffect.erase("confusion")
		await owner.showHappeningText(["%s felt lucid again!" % [affected.charName]])

func paralysis(affected : Node) -> bool:
	var willRemove : int = randi_range(1, 10)
	if (willRemove == 1):
		affected.statusEffect.erase("paralysis")
		affected.speed *= 2
		await owner.showHappeningText(["%s's paralysis is gone!" % [affected.charName]])
		return true
	
	
	var canMove : int = randi_range(1, 2)
	if (canMove == 1):
		return true
	else:
		await owner.showHappeningText(["%s is paralysed and can't move!" % [affected.charName]])
		return false

func shield(attacker : Node, affected : Node, damage : int) -> Array:
	var info : Array = []
	var reflectedDamage : int = ceil(damage * 0.4)
	print("DAMAGE BEFORE SHIELD:: ", damage)
	damage = floor(damage * 0.5)
	print("DAMAGE AFTER SHIELD:: ", damage)
	info.append(damage) # [0]
	info.append(reflectedDamage) # [1]
	
	info.append("%s's power shield reflected the attack!" % [affected.charName]) # [2]
	
	info.append("%d HP of reflected damage to %s!" % [reflectedDamage, attacker.charName]) # [3]
	
	affected.shieldHealth -= 1
	if (affected.shieldHealth <= 0):
		affected.shieldHealth = 0
		affected.statusEffect.erase("shield")
		info.append("%s's power shield dissapeared!" % [affected.charName]) # [4]
		
	return info
