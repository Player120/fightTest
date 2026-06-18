extends Control

@export var playerStatus : player

var hpNumber : int = 0

#func _ready() -> void:
	#updateValues("health", playerStatus.health)
	#updateValues("powerPoints", playerStatus.powerPoints)

func attributeLabel(type : String, playerWindowScene) -> Label:
	match type:
		"hp":
			return playerWindowScene.hpNumber
		"pp":
			return playerWindowScene.ppNumber
		_:
			return playerWindowScene.hpNumber

func updateValues(type : String, amount : int, playerWindowScene) -> void:
	match type:
		"health":
			playerWindowScene.updateUIText(type, amount)
		"powerPoints":
			playerWindowScene.updateUIText(type, amount)
