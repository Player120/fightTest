extends Control

@onready var nameText : Label = $VBoxContainer/PlayerName
@onready var hpNumber : Label = $VBoxContainer/hpContainer/hpNumber
@onready var ppNumber : Label = $VBoxContainer/ppContainer/ppNumber

var trackedPlayer : player

func initializeWithPlayer(playerData : player) -> void:
	trackedPlayer = playerData
	nameText.text = trackedPlayer.charName

func updateUIText(stat : String, value : int) -> void:
	match stat:
		"health":
			hpNumber.text = str(value)
		"powerPoints":
			ppNumber.text = str(value)
		_:
			hpNumber.text = "something went wrong..."
			ppNumber.text = "check for errors"
