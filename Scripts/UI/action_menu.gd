extends Control

@onready var buttons : Array[Node] = get_tree().get_nodes_in_group("actionButtons")
@onready var background : TextureRect = $Actions/TextureRect
@onready var specialActionsMenu : Control = $SpecialActions
@onready var specialActionsBackground : TextureRect = $SpecialActions/SpecialActionsBackground
@onready var attackButton : Button = $Actions/HBoxContainer/Attack
@onready var healButton : Button = $Actions/HBoxContainer/Heal
@onready var specialButton : Button = $Actions/HBoxContainer/Special
@onready var specialActions : Control = $SpecialActions
@onready var psiMenu : Control = $SpecialActions/PsiMenu
@onready var darkArtsMenu : Control = $SpecialActions/DarkArtsMenu
@onready var devToolsMenu : Control = $SpecialActions/DevToolsMenu
@onready var caipiraPowersMenu : Control = $SpecialActions/CaipiraPowersMenu
@onready var friendshipMagicMenu : Control = $SpecialActions/FriendshipMagic
@onready var askTarget : ColorRect = $AskTarget
@onready var targetNameLabel : Label = $AskTarget/ColorRect/TargetName

var isMenuOpen : bool = false
var isAnimationPlaying : bool = false

signal playerChosenAction(actionType : String)

var currentPlayer : player

func _ready() -> void:
	get_tree().call_group("specialActions", "hide")
	specialActionsBackground.hide()
	
	# Connect normal action buttons --------------------------------
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

func _input(event: InputEvent) -> void:
	if isAnimationPlaying:
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if (Global.isSelectingEnemy):
		for button in buttons:
			button.disabled = true
			askTarget.visible = true
		Global.hoveringEnemy.connect(changeTargetNameLabel)
	else:
		for button in buttons:
			button.disabled = false
			askTarget.visible = false
		changeTargetNameLabel("Hover a target...")
	
	if (isMenuOpen):
		attackButton.disabled = true
		healButton.disabled = true
	elif (!Global.isSelectingEnemy):
		attackButton.disabled = false
		healButton.disabled = false

func changeTargetNameLabel(targetName : String) -> void:
	targetNameLabel.text = targetName

func changeColors() -> void:
	var actionMenuTheme = load("res://Resources/Themes/actionMenuTheme.tres")
	
	background.modulate = currentPlayer.themeColor.lerp(Color.WHITE, 0.6)
	
	specialActionsBackground.modulate = currentPlayer.themeColor
	
	actionMenuTheme.get_stylebox("hover", "Button").modulate_color = currentPlayer.themeColor.lerp(Color.WHITE, 0.3)
	
	actionMenuTheme.get_stylebox("pressed", "Button").modulate_color = currentPlayer.themeColor.lerp(Color.BLACK, 0.1)
	
	specialActionsMenu.specialGradient(currentPlayer)

func _on_button_pressed(pressedButton : Button) -> void:
	var act : String = ""
	match pressedButton.name:
		"Attack":
			act = "Attack"
			Global.enableEnemySelection()
			await Global.enemyChosen
			Global.disableEnemySelection()
			playerChosenAction.emit(act)
		"Heal":
			act = "Heal"
			currentPlayer.target = currentPlayer
			playerChosenAction.emit(act)
		"Special":
			attackButton.disabled = true
			healButton.disabled = !healButton.disabled
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
	currentPlayer.target = Global.enemyTeam[0]
	match pressedButton.name:
		"PkStarstorm":
			currentPlayer.specialMoveName = "PK Starstorm"
			toggleSpecialMenu(psiMenu)
		"PkFire":
			currentPlayer.specialMoveName = "PK Fire"
			toggleSpecialMenu(psiMenu)
		"PkFreeze":
			currentPlayer.specialMoveName = "PK Freeze"
			Global.enableEnemySelection()
			toggleSpecialMenu(psiMenu)
			await Global.enemyChosen
			Global.disableEnemySelection()
	playerChosenAction.emit("PSI")

func _on_darkArts_button_pressed(pressedButton : Button) -> void:
	currentPlayer.target = Global.enemyTeam[0]
	match pressedButton.name:
		"Anti-Innovation":
			currentPlayer.specialMoveName = "Anti-Innovation"
			toggleSpecialMenu(darkArtsMenu)
		"Globalization":
			currentPlayer.specialMoveName = "Globalization"
			toggleSpecialMenu(darkArtsMenu)
		"Logarithms":
			currentPlayer.specialMoveName = "Logarithms"
			toggleSpecialMenu(darkArtsMenu)
	playerChosenAction.emit("Dark Arts")

func _on_devTools_button_pressed(pressedButton : Button) -> void:
	currentPlayer.target = currentPlayer
	match pressedButton.name:
		"Flippy Board":
			currentPlayer.specialMoveName = "Flippy Board"
		"VS Code":
			currentPlayer.specialMoveName = "VS Code"
		"Discord Call":
			currentPlayer.specialMoveName = "Discord Call"
	toggleSpecialMenu(devToolsMenu)
	playerChosenAction.emit("Dev Tools")

func _on_caipiraPowers_button_pressed(pressedButton : Button) -> void:
	currentPlayer.target = Global.enemyTeam[0]
	match pressedButton.name:
		"Thunderstorm":
			currentPlayer.specialMoveName = "Thunderstorm"
		"NatureBeam":
			currentPlayer.specialMoveName = "Nature Beam"
		"Organization":
			currentPlayer.specialMoveName = "Organization"
	toggleSpecialMenu(caipiraPowersMenu)
	playerChosenAction.emit("Caipira Powers")

func _on_friendshipMagic_button_pressed(pressedButton : Button) -> void:
	currentPlayer.target = Global.enemyTeam[0]
	match pressedButton.name:
		"FriendshipStar":
			currentPlayer.specialMoveName = "Friendship Star"
		"PowerShield":
			currentPlayer.target = Global.playerTeam[0]
			currentPlayer.specialMoveName = "Power Shield"
		"RainbowComet":
			currentPlayer.target = Global.playerTeam[0]
			currentPlayer.specialMoveName = "Rainbow Comet"
	toggleSpecialMenu(friendshipMagicMenu)
	playerChosenAction.emit("Friendship Magic")

func toggleSpecialMenu(menu : Control) -> void:
	var myTween = create_tween().set_parallel(true)
	var yTarget : int = 0
	
	attackButton.disabled = !attackButton.disabled
	healButton.disabled = !healButton.disabled
	
	if (!isMenuOpen && !isAnimationPlaying):
		isAnimationPlaying = true
		yTarget = position.y + 80
		isMenuOpen = !isMenuOpen
		
		menu.visible = !menu.visible
		specialActionsBackground.visible = !specialActionsBackground.visible
		
		myTween.tween_property(specialActionsBackground, "position:y", yTarget, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
		myTween.tween_property(menu, "position:y", yTarget, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
		myTween.tween_callback(freeInputs).set_delay(0.3)
		
	elif (!isAnimationPlaying):
		isAnimationPlaying = true
		yTarget = position.y - 80
		isMenuOpen = !isMenuOpen
		
		myTween.tween_property(specialActionsBackground, "position:y", yTarget, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
		myTween.tween_property(menu, "position:y", yTarget, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
		await get_tree().create_timer(0.3).timeout
		
		menu.visible = !menu.visible
		specialActionsBackground.visible = !specialActionsBackground.visible
		freeInputs()

func freeInputs() -> void:
	isAnimationPlaying = false

func togglePlayerActions() -> void:
	self.visible = !self.visible
	print("ACTION MENU Visibility:: ", self.visible)
	if (self.visible):
		self.PROCESS_MODE_INHERIT
	else:
		self.PROCESS_MODE_DISABLED
