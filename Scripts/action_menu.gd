extends Control

@export var playerStatus : player
@export var bossStatus : boss

@onready var attackButton : Button = $Actions/HBoxContainer/Attack
@onready var healButton : Button = $Actions/HBoxContainer/Heal
@onready var psiButton : Button = $Actions/HBoxContainer/PSI
@onready var psiMenu : Control = $PsiMenu

func _ready() -> void:
	psiMenu.visible = false
	psiMenu.PROCESS_MODE_DISABLED

func _on_attack_pressed() -> void:
	if (playerStatus.alive):
		playerStatus.action = "attack"
		playerStatus.target = bossStatus
		owner.bossMove()

func _on_heal_pressed() -> void:
	if (playerStatus.alive):
		playerStatus.action = "heal"
		playerStatus.target = playerStatus
		owner.bossMove()

func _on_psi_pressed() -> void:
	togglePsiMenu()

func _on_pk_starstorm_pressed() -> void:
	if (playerStatus.alive):
		togglePsiMenu()
		playerStatus.action = "psi"
		playerStatus.psiName = "PK Starstorm"
		playerStatus.target = bossStatus
		owner.bossMove()

func _on_pk_fire_pressed() -> void:
	if (playerStatus.alive):
		togglePsiMenu()
		playerStatus.action = "psi"
		playerStatus.psiName = "PK Fire"
		playerStatus.target = bossStatus
		owner.bossMove()

func _on_pk_freeze_pressed() -> void:
	if (playerStatus.alive):
		togglePsiMenu()
		playerStatus.action = "psi"
		playerStatus.psiName = "PK Freeze"
		playerStatus.target = bossStatus
		owner.bossMove()

func togglePsiMenu() -> void:
	psiMenu.visible = !psiMenu.visible
	attackButton.disabled = !attackButton.disabled
	healButton.disabled = !healButton.disabled
	if (psiMenu.visible):
		psiMenu.PROCESS_MODE_INHERIT
	else:
		psiMenu.PROCESS_MODE_DISABLED

func togglePlayerActions() -> void:
	self.visible = !self.visible
	print(self.visible)
	if (self.visible):
		self.PROCESS_MODE_INHERIT
	else:
		self.PROCESS_MODE_DISABLED
