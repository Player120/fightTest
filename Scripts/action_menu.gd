extends Control

@export var bossStatus : boss

@onready var attackButton : Button = $Actions/HBoxContainer/Attack
@onready var healButton : Button = $Actions/HBoxContainer/Heal
@onready var specialButton : Button = $Actions/HBoxContainer/Special
@onready var specialActions : Control = $SpecialActions
@onready var psiMenu : Control = $SpecialActions/PsiMenu
@onready var darkArtsMenu : Control = $SpecialActions/DarkArtsMenu

signal playerChosenAction(actionType : String)

var currentPlayer : player

func _ready() -> void:
	get_tree().call_group("specialActions", "hide")
	
	# Connect normal action buttons --------------------------------
	var buttons : Array[Node] = get_tree().get_nodes_in_group("actionButtons")
	
	for button in buttons:
		button.pressed.connect(_on_button_pressed.bind(button))
	# --------------------------------------------------------------
	
	# Connect special action buttons -------------------------------
	var psiButtons : Array[Node] = get_tree().get_nodes_in_group("psiButtons")
	for button in psiButtons:
		button.pressed.connect(_on_psi_button_pressed.bind(button))
	
	var darkArtsButtons: Array[Node] = get_tree().get_nodes_in_group("darkArtsButtons")
	for button in darkArtsButtons:
		button.pressed.connect(_on_darkArts_button_pressed.bind(button))
	# --------------------------------------------------------------
	

func _on_button_pressed(pressedButton : Button) -> void:
	var act : String = ""
	match pressedButton.name:
		"Attack":
			act = "attack"
			playerChosenAction.emit(act)
		"Heal":
			act = "heal"
			playerChosenAction.emit(act)
		"Special":
			match pressedButton.text:
				"PSI":
					toggleSpecialMenu(psiMenu)
				"Dark Arts":
					toggleSpecialMenu(darkArtsMenu)
		_:
			print("Something went wrong in actions_menu.gd")

func _on_psi_button_pressed(pressedButton : Button) -> void:
	match pressedButton.name:
		"PkStarstorm":
			currentPlayer.specialMoveName = "PK Starstorm"
		"PkFire":
			currentPlayer.specialMoveName = "PK Fire"
		"PkFreeze":
			currentPlayer.specialMoveName = "PK Freeze"
	toggleSpecialMenu(psiMenu)
	playerChosenAction.emit("psi")

func _on_darkArts_button_pressed(pressedButton : Button) -> void:
	match pressedButton.name:
		"Anti-Innovation":
			currentPlayer.specialMoveName = "Anti-Innovation"
		"Globalization":
			currentPlayer.specialMoveName = "Globalization"
	toggleSpecialMenu(darkArtsMenu)
	playerChosenAction.emit("dark arts")

func toggleSpecialMenu(menu : Control) -> void:
	menu.visible = !menu.visible
	attackButton.disabled = !attackButton.disabled
	healButton.disabled = !healButton.disabled

func togglePlayerActions() -> void:
	self.visible = !self.visible
	print("ACTION MENU Visibility:: ", self.visible)
	if (self.visible):
		self.PROCESS_MODE_INHERIT
	else:
		self.PROCESS_MODE_DISABLED
