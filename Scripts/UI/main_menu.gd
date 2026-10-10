extends Control

func _ready() -> void:
	if (MenuBackgroundMusic.stream == null):
		MenuBackgroundMusic.playMusic("res://Resources/Music/EarthBound Beginnings (USA)-261009-145537.mp3")

func _on_begin_pressed() -> void:
	Global.customPlayerNames.clear()
	Transition.changeScene("res://Scenes/story.tscn")
