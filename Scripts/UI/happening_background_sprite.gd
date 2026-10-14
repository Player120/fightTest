extends TextureRect

@onready var happeningText : Label = $"../HappeningText"
@onready var battleBackground : TextureRect = $"../../EnemyArea/Background"

var victoryColors : Array[Color] = [
	Color.YELLOW,
	Color.LIME,
	Color.DARK_BLUE,
	Color.WHITE
]

var labelColors : Array[Color] = [
	Color.WHITE,
	Color.BLACK
]

var defeatColors : Array[Color] = [
	Color.RED,
	Color.ORANGE_RED,
	Color.BLACK
]

func changeColors(battleResult : String):
	var colorTween : Tween = create_tween()
	var labelTween : Tween = create_tween()
	colorTween.set_loops()
	labelTween.set_loops()
	
	if (battleResult == "victory"):
		changeBackground("res://Resources/Sprites/Background/main_menu_background.png")
		for color in victoryColors:
			# Changes the color in the texture rect
			colorTween.tween_property(self, "modulate", color, 1.0)
			# Changes the color in the label
			for labelColor in labelColors:
				labelTween.tween_property(happeningText, "theme_override_colors/font_color", labelColor, 1.0)
	elif (battleResult == "defeat"):
		for color in defeatColors:
			# Changes the color in the texture rect
			colorTween.tween_property(self, "modulate", color, 1.0)
			# Changes the color in the label
			for labelColor in labelColors:
				labelTween.tween_property(happeningText, "theme_override_colors/font_color", labelColor, 2.0)

func changeBackground(imagePath : String):
	var newBackground : Texture2D = load(imagePath)
	var backgroundTween : Tween = create_tween()
	
	# Make the background transparent
	backgroundTween.tween_property(battleBackground, "modulate:a", 0.0, 1.0)
	
	# Change the backgroud while it's fully transparent
	backgroundTween.tween_callback(func(): battleBackground.texture = newBackground)
	
	# Make the background visible again
	backgroundTween.tween_property(battleBackground, "modulate:a", 1.0, 1.0)
