extends Control

@onready var playerWindowContainer : Control = $PlayerWindowContainer

@export var playerStatus : player

var hpNumber : int = 0

func _ready() -> void:
	updateValues("health", playerStatus.health)
	updateValues("psychicPoints", playerStatus.psychicPoints)

func attributeLabel(type) -> Label:
	match type:
		"hp":
			return playerWindowContainer.hpNumber
		"pp":
			return playerWindowContainer.ppNumber
		_:
			return playerWindowContainer.hpNumber

func updateValues(type : String, amount : int) -> void:
	match type:
		"health":
			playerWindowContainer.updateUIText(type, amount)
		"psychicPoints":
			playerWindowContainer.updateUIText(type, amount)
