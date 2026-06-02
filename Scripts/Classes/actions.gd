extends Node
class_name actions

@export var psiActions : psiMoves
@export var darkArtsActions : darkArts

func attack(attacker : Node, deffender : Node) -> void:
	await owner.showHappeningText(["%s is attacking!" % [attacker.charName]])
	
	var dodgeChance : int = randi_range(1, 100)
	
	if (dodgeChance > deffender.speed):
		var damage : int = randi_range(attacker.offense - 5, attacker.offense + 10)
		if (damage < 0):
			damage = 0
		
		var criticalChance : int = randi_range(1, 100)
		var criticalMessage : String = ""
		print("ATTACK:: Critical chance: %d" % [criticalChance])
		if (criticalChance <= attacker.determination):
			var criticalDamage = damage * 2.5
			print("ATTACK:: Critical Hit!!")
			damage = ceil(criticalDamage)
			criticalMessage = "A critical hit! "
		
		var damageMessage : String = "%s%d HP of damage to %s!" % [criticalMessage, damage, deffender.charName]
		
		await damageHandler(deffender, damage, damageMessage)
	else:
		await owner.showHappeningText(["%s dodged with style!" % [deffender.charName]])

func heal(healer : Node, target : Node) -> void:
	await owner.showHappeningText(["%s is healing!" % [healer.charName]])
	var healValue : int = randi_range(20, 64)
	var newHealth : int = target.health + healValue
	
	if (newHealth <= target.maxHealth):
		target.health = newHealth
	else:
		healValue = target.maxHealth - target.health
		target.health = target.maxHealth
	
	owner.updateHealthText(target)
	await owner.showHappeningText(["%s recovered %d HP!" % [target.charName, healValue]])

func psi(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s tried %s!" % [user.charName, user.specialMoveName]])
	match user.specialMoveName:
		"PK Starstorm":
			await psiActions.pkStarstorm(user, target)
		"PK Fire":
			await psiActions.pkFire(user, target)
		"PK Freeze":
			await psiActions.pkFreeze(user, target)
		_:
			await owner.showHappeningText(["Something went wrong: Invalid move in function psi() in actions.gd. Please restart the application."])

func darkArtsManager(user : Node, target : Node) -> void:
	await owner.showHappeningText(["%s used the dreaded %s dark art!" % [user.charName, user.specialMoveName]])
	match user.specialMoveName:
		"Anti-Innovation":
			await darkArtsActions.antiInnovation(user, target)
		"Globalization":
			await darkArtsActions.globalization(user, target)
		"Logarithms":
			await darkArtsActions.logarithms(user, target)

func damageHandler(deffender : Node, damage : int, message : String) -> void:
	deffender.health -= damage
	owner.updateHealthText(deffender)
	
	await owner.showHappeningText([message])
	
	await owner.testForDeath(deffender)
