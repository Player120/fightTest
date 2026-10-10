extends CanvasLayer

@onready var colorRect : ColorRect = $ColorRect

func changeScene(newScenePath : String, fadeTime : float = 0.5):
	# Blocks mouse clicks and interactions during the transition
	colorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Fade Out (darkens the screen)
	var tweenOut : Tween = create_tween()
	tweenOut.tween_property(colorRect, "color:a", 1.0, fadeTime)
	await tweenOut.finished
	
	# Switches scenes
	get_tree().change_scene_to_file(newScenePath)
	
	# Waits for the new scene to load a frame
	await get_tree().process_frame
	
	# Fade In (brigthens the screen)
	var tweenIn : Tween = create_tween()
	tweenIn.tween_property(colorRect, "color:a", 0.0, fadeTime)
	await tweenIn.finished
	
	# Enables mouse clicks and interactions again
	colorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
