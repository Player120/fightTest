extends Control

@onready var scene : Control = self
@onready var enemySprite : TextureRect = $EnemySprite
@onready var hpNumber : Label = $EnemySprite/enemyHpNumber
var trackedEnemy : enemy
signal choseEnemy

func updateHealthText(value : int) -> void:
	hpNumber.text = str(value)

func initializeEnemy(data : enemy) -> void:
	trackedEnemy = data
	enemySprite.texture = load(trackedEnemy.sprite)

func _gui_input(event : InputEvent) -> void:
	if (event is InputEventMouseButton && Global.isSelectingEnemy && trackedEnemy.alive):
		if (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
			resetBrightness()
			Global.setTarget(trackedEnemy)

func _on_mouse_entered() -> void:
	if (Global.isSelectingEnemy):
		enemySprite.modulate.v -= 0.5
		Global.hoveringEnemy.emit(trackedEnemy.charName)

func _on_mouse_exited() -> void:
	if (Global.isSelectingEnemy):
		enemySprite.modulate.v += 0.5
		Global.hoveringEnemy.emit("Hover a target...")

func resetBrightness() -> void:
	enemySprite.modulate.v = 1.0
