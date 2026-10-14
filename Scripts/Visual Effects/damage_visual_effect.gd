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
	var colorTween : Tween = create_tween()
	var dissapearTween : Tween = create_tween()
	colorTween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0), 0.1)
	dissapearTween.tween_property(sprite, "modulate:a", 0.0, 1.0)
	await dissapearTween.finished
	scene.visible = false

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

func playerDied(background : TextureRect) -> void:
	var colorTween : Tween = create_tween()
	
	# Darkens the dead player's window
	colorTween.tween_property(background, "modulate", Color.BLACK, 0.35)
	
	await colorTween.finished
