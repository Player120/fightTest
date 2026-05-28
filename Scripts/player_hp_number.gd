extends Label

var playerStatus : player

func _ready() -> void:
	playerStatus = player.new()
	self.text = str(playerStatus.health)
