extends Label

var enemyStatus : enemy

func _ready() -> void:
	enemyStatus = enemy.new()
	self.text = str(enemyStatus.health)
