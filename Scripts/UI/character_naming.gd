extends Control

@onready var doneButton : Button = $NamingArea/HBoxContainer/VBoxContainer/Done
@onready var textField : LineEdit = $NamingArea/HBoxContainer/VBoxContainer/LineEdit
@onready var character : TextureRect = $NamingArea/HBoxContainer/Character
@onready var nameQuestion : Label = $NamingArea/HBoxContainer/VBoxContainer/Question
var currentCharacter : int = 0

var charSprites : Array[String] = [
	"res://Resources/Sprites/Characters/rafa.svg",
	"res://Resources/Sprites/Characters/otávio.svg",
	"res://Resources/Sprites/Characters/gabriel.svg",
	"res://Resources/Sprites/Characters/breno.svg",
	"res://Resources/Sprites/Characters/neto.svg"
]

var nameQuestions : Array[String] = [
	"Please name him...",
	"Name your emo friend.",
	"Name your other friend.",
	"What is this farmer boy's name?",
	"Lastly, name him, too."
]

func _ready() -> void:
	doneButton.disabled = true
	textField.max_length = 12
	character.texture = load(charSprites[0])
	nameQuestion.text = nameQuestions[0]
	currentCharacter = 0

func _on_back_to_start_pressed() -> void:
	Global.customPlayerNames.clear()
	Transition.changeScene("res://main_menu.tscn")

func _on_line_edit_text_changed(new_text : String) -> void:
	if (new_text.length() > 0):
		doneButton.disabled = false
	else:
		doneButton.disabled = true

func _on_done_pressed() -> void:
	if (textField.text != null):
		Global.customPlayerNames.append(textField.text)
		textField.clear()
		print("Character named: ", Global.customPlayerNames[currentCharacter])
		currentCharacter += 1
		
		if (currentCharacter == 5):
			BackgroundMusic.stop()
			Transition.changeScene("res://Scenes/fight.tscn")
		else:
			character.texture = load(charSprites[currentCharacter])
			nameQuestion.text = nameQuestions[currentCharacter]

func _on_dont_care_pressed() -> void:
	textField.text = Global.defaultPlayerNames[currentCharacter]
	doneButton.disabled = false
