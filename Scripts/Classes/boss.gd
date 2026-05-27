extends RefCounted
class_name boss

var bossHealth : int = 100
var bossOffense : int = 10
var bossAttackDamage : int = 0

func getBossHealth() -> int:
	return bossHealth

func bossTakeDamage(attackerOffense : int) -> void:
	bossHealth -= randi_range(attackerOffense - 5, attackerOffense + 5)

func bossAttack() -> int:
	bossAttackDamage = randi_range(bossOffense - 5, bossOffense + 5)
	return bossAttackDamage
