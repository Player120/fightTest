extends Control

@export var bossStatus : boss

@onready var attackButton : Button = $Actions/HBoxContainer/Attack
@onready var healButton : Button = $Actions/HBoxContainer/Heal
@onready var specialButton : Button = $Actions/HBoxContainer/Special
@onready var specialActions : Control = $SpecialActions
@onready var psiMenu : Control = $SpecialActions/PsiMenu
@onready var darkArtsMenu : Control = $SpecialActions/DarkArtsMenu
@onready var devToolsMenu : Control = $SpecialActions/DevToolsMenu
@onready var caipiraPowersMenu : Control = $SpecialActions/CaipiraPowersMenu
@onready var friendshipMagicMenu : Control = $SpecialActions/FriendshipMagic

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
	
	var devToolsButtons: Array[Node] = get_tree().get_nodes_in_group("devToolsButtons")
	for button in devToolsButtons:
		button.pressed.connect(_on_devTools_button_pressed.bind(button))
	
	var caipiraPowersButtons: Array[Node] = get_tree().get_nodes_in_group("caipiraPowersButtons")
	for button in caipiraPowersButtons:
		button.pressed.connect(_on_caipiraPowers_button_pressed.bind(button))
	
	var friendshipMagicButtons: Array[Node] = get_tree().get_nodes_in_group("friendshipMagicButtons")
	for button in friendshipMagicButtons:
		button.pressed.connect(_on_friendshipMagic_button_pressed.bind(button))	# --------------------------------------------------------------
	

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
				"Dev Tools":
					toggleSpecialMenu(devToolsMenu)
				"Caipira Powers":
					toggleSpecialMenu(caipiraPowersMenu)
				"Friendship Magic":
					toggleSpecialMenu(friendshipMagicMenu)
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
		"Logarithms":
			currentPlayer.specialMoveName = "Logarithms"
	toggleSpecialMenu(darkArtsMenu)
	playerChosenAction.emit("dark arts")

func _on_devTools_button_pressed(pressedButton : Button) -> void:
	match pressedButton.name:
		"Flippy Board":
			currentPlayer.specialMoveName = "Flippy Board"
		"VS Code":
			currentPlayer.specialMoveName = "VS Code"
		"Discord Call":
			currentPlayer.specialMoveName = "Discord Call"
	toggleSpecialMenu(devToolsMenu)
	playerChosenAction.emit("dev tools")

func _on_caipiraPowers_button_pressed(pressedButton : Button) -> void:
	match pressedButton.name:
		"Thunderstorm":
			currentPlayer.specialMoveName = "Thunderstorm"
		"NatureBeam":
			currentPlayer.specialMoveName = "Nature Beam"
		"Organization":
			currentPlayer.specialMoveName = "Organization"
	toggleSpecialMenu(caipiraPowersMenu)
	playerChosenAction.emit("caipira powers")

func _on_friendshipMagic_button_pressed(pressedButton : Button) -> void:
	match pressedButton.name:
		"FriendshipStar":
			currentPlayer.specialMoveName = "Friendship Star"
		"PowerShield":
			currentPlayer.specialMoveName = "Power Shield"
		"RainbowComet":
			currentPlayer.specialMoveName = "Rainbow Comet"
	toggleSpecialMenu(friendshipMagicMenu)
	playerChosenAction.emit("friendship magic")

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
