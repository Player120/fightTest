extends Control

@onready var scene : Control = self
@onready var enemySprite : TextureRect = $EnemySprite
@onready var hpNumber : Label = $EnemySprite/enemyHpNumber

var trackedEnemy : enemy
var goalYPos : float = 0.0
var movementTween : Tween
var loopTime : float = randf_range(0.4, 1.2)

func _ready() -> void:
	movementTween = create_tween().set_loops()
	movementTween.tween_property(self, "position:y", -7.0, loopTime)
	movementTween.tween_property(self, "position:y", 7.0, loopTime)
	Global.stopEnemyAnimation.connect(stopAnimation)
	Global.startEnemyAnimation.connect(playAnimation)

func _process(delta : float) -> void:
	self.position.y = lerp(self.position.y, goalYPos, delta * 7)

func stopAnimation(defender : enemy) -> void:
	if (defender == trackedEnemy):
		if (defender.statusEffect.has("paralysis") or defender.statusEffect.has("freeze")):
			movementTween.stop()
		elif (not defender.alive):
			movementTween.kill()

func playAnimation(target : enemy) -> void:
	if (target == trackedEnemy and target.alive):
		movementTween.play()

func updateHealthText(value : int) -> void:
	hpNumber.text = str(value)

func initializeEnemy(data : enemy) -> void:
	trackedEnemy = data
	enemySprite.texture = load(trackedEnemy.sprite)

func _gui_input(event : InputEvent) -> void:
	if (event is InputEventMouseButton && Global.isSelectingEnemy && trackedEnemy.alive):
		if (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
			resetSprite()
			Global.setTarget(trackedEnemy)

func _on_mouse_entered() -> void:
	if (Global.isSelectingEnemy):
		enemySprite.modulate.v -= 0.5
		goalYPos -= 40
		Global.hoveringEnemy.emit(trackedEnemy.charName)
		movementTween.stop()

func _on_mouse_exited() -> void:
	if (Global.isSelectingEnemy):
		enemySprite.modulate.v += 0.5
		goalYPos += 40
		Global.hoveringEnemy.emit("Hover a target...")
		movementTween.play()

func resetSprite() -> void:
	enemySprite.modulate.v = 1.0
	goalYPos = 0.0
	movementTween.play()
