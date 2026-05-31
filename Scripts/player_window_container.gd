extends Control

@onready var windowContainer : HBoxContainer = $WindowContainer
@onready var playerWindow : Control = $WindowContainer/PlayerWindow
@onready var hpNumber : Label = $WindowContainer/PlayerWindow/VBoxContainer/hpContainer/hpNumber
@onready var ppNumber : Label = $WindowContainer/PlayerWindow/VBoxContainer/ppContainer/ppNumber

func updateUIText(stat : String, value : int) -> void:
	match stat:
		"health":
			hpNumber.text = str(value)
		"psychicPoints":
			ppNumber.text = str(value)
		_:
			hpNumber.text = "something went wrong..."
			ppNumber.text = "check for errors"
