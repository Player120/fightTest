extends Node
class_name damageVisualEffect

func enemyTookDamage(sprite : TextureRect) -> void:
	var colorTween : Tween = sprite.create_tween()
	var dissapearTween : Tween = sprite.create_tween()
	dissapearTween.set_loops(2)
	
	# Flashes the enemy sprite in red
	colorTween.tween_property(sprite, "modulate", Color.RED, 0.0)
	# Makes the enemy dissapear
	dissapearTween.tween_property(sprite, "modulate:a", 0.0, 0.0)
	dissapearTween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	#  Makes the enemy reapear
	dissapearTween.tween_property(sprite, "modulate:a", 1.0, 0.0)
	dissapearTween.tween_property(sprite, "modulate:a", 1.0, 0.2)
	# Turns the sprite back to normal
	colorTween.tween_property(sprite, "modulate", Color.WHITE, 0.9)
	
	await dissapearTween.finished

func enemyDied(scene : Control, sprite : TextureRect) -> void:
	var deathTween : Tween = sprite.create_tween()
	const colorDuration : float = 2.5
	var dissapearDuration : float = colorDuration * 0.85
	
	scene.hpNumber.visible = false
	
	# Brightens the enemy's sprite using the shader
	sprite.set_instance_shader_parameter("active", true)
	deathTween.tween_property(sprite, "instance_shader_parameters/quantity", 1.0, colorDuration)
	
	# Makes the enemy dissapear
	deathTween.tween_property(sprite, "modulate:a", 0.0, dissapearDuration)
	await deathTween.finished
	
	scene.visible = false

func enemyObliterated(sprite : TextureRect):
	var colorTween : Tween = create_tween()
	const loopTime : float = 0.5
	colorTween.set_loops(3)
	
	# Darkens and brightens the enemy's sprite
	colorTween.tween_property(sprite, "modulate", Color.BLACK, loopTime / 2.0)
	colorTween.tween_property(sprite, "modulate", Color.WHITE, loopTime / 2.0)
	
	await colorTween.finished

func playerTookDamage(scene : Control, damage : int) -> void:
	var initialPosition : Vector2 = scene.position
	var shakeTween : Tween = create_tween()
	var intensity : float = damage / 3
	const duration : float = 0.15
	
	# Draws 12 random positions
	for i in range(12):
		var positionOffset : Vector2 = initialPosition + Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		shakeTween.tween_property(scene, "position", positionOffset, duration / 5)
	
	# Returns the scene to its original position
	shakeTween.tween_property(scene, "position", initialPosition, duration / 5)
	
	await shakeTween.finished

func playerDied(character : player, background : TextureRect, playerSprite : TextureRect) -> void:
	var colorTween : Tween = create_tween()
	var changeSpriteTween : Tween = create_tween()
	var ghostSprite : Texture2D = load(character.ghostSprite)
	var yPos : float = playerSprite.position.y - 30
	const duration : float = 0.6
	
	# Darkens the dead player's window
	colorTween.tween_property(background, "modulate", Color.BLACK, 0.55)
	
	# Dissapears with the player's sprite
	changeSpriteTween.tween_property(playerSprite, "modulate:a", 0.0, duration / 2)
	
	# Changes the dead player's sprite to the ghost sprite
	changeSpriteTween.tween_callback(func(): 
		playerSprite.texture = ghostSprite
		playerSprite.position.y = yPos
	)
	
	# Makes the player's sprite appear again
	changeSpriteTween.tween_property(playerSprite, "modulate:a", 1.0, duration / 2)
	
	if (character == Global.currentCharacter):
		await changeSpriteTween.finished
	else:
		await colorTween.finished
	
	moveTombstone(character)

func moveTombstone(character : player, battleOver : bool = false):
	if (character == Global.currentCharacter):
		await Global.playerFinishedTurn
	
	var movementTween : Tween = create_tween()
	var duration : float = 1.5
	var distance : float = -120.0
	
	if (battleOver):
		distance *= -1
	
	# Moves the tombstone sprite
	movementTween.tween_property(character.myUI.tombstoneSprite, "position:y", distance, duration)
	
	# Creates oscilations in the X axis
	var shakeAmount : int = 12
	var shakeIntensity : float = 2.0
	var initialPosition : Vector2 = character.myUI.tombstoneSprite.position
	var timeByStep : float = duration / shakeAmount
	
	for i in range(shakeAmount):
		var offsetX : float = randf_range(-shakeIntensity, shakeIntensity)

		movementTween.parallel().tween_property(character.myUI.tombstoneSprite, "position:x", initialPosition.x + offsetX, timeByStep).set_delay(i * timeByStep)
	# Puts the tombstone back in the original X axis
	movementTween.chain().tween_property(character.myUI.tombstoneSprite, "position:x", initialPosition.x, 0.05)
	
	await movementTween.finished
	
	if (battleOver):
		moveGhostPlayer(character)

func moveGhostPlayer(character : player):
	var movementTween = create_tween()
	var yTarget : int = -155
	
	# Transitions the property position:y to the target in 0.6 sec
	movementTween.tween_property(character.myUI.playerSprite, "position:y", yTarget, 1.2)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN_OUT)
