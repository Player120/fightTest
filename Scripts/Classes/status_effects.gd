extends Node
class_name statusEffects

@export var playerStatus : player
@export var bossStatus : boss

func burn(affected : Node) -> void:
	var stopBurning : int = randi_range(1, 3)
	
	if (stopBurning > 1):
		await owner.showHappeningText(["%s is toasting!" % [affected.charName]])
		
		var damage : int = randi_range(5, 27)
		affected.health -= damage
		damageHandler(affected, damage)
		
		await owner.showHappeningText(["%s took %d HP of damage from the severe toasting!" % [affected.charName, damage]])
	else:
		affected.statusEffect.erase("burn")
		await owner.showHappeningText(["%s stopped toasting!" % [affected.charName]])

func damageHandler(affected : Node, damage : int):
	affected.health -= damage
	
	owner.updateHealthText(affected)
	owner.testForDeath(affected)

func freeze(affected : Node) -> void:
	var unfreeze : int = randi_range(1, 3)
	if (unfreeze == 1):
		await owner.showHappeningText(["%s is frozen and can't move!" % [affected.charName]])
	else:
		affected.statusEffect.erase("freeze")
		await owner.showHappeningText(["%s has unfrozen!" % [affected.charName]])
