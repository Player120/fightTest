extends Control

@onready var story : Label = $StoryArea/StoryText
@onready var advance : Button = $AdvanceButton
var currentPart : int = 1
var storyParts : Array[String] = [
	'The year is 2026.
	Vargem Grande do Sul became the largest economic, military and political power in the world and the capital of Brazil.
	Five teenagers who graduated from Etec de Vargem Grande do Sul the year prior were hanging out at Chiquinho Sorvetes for the Ice Cream Day.
	But them, all of a sudden, a mysterious spaceship landed outside, and from inside, came the lengendary Professor Macena.
	Macena came to warn them about an upcoming universal threat: Their Innovation teacher at Etec VGS, Big Gus, on his obsession for searching the ultimate innovation, went crazy, and is going to destroy the universe with the "Innovation Singularity".',
	"Not only that, but Big Gus also recruited teacher Nivaldo and made a clone of himself to assist him in his evil plans.
	The three are planning to destroy the universe using the power of Innovation, and have grown imensenly powerful from absorbing pure Innovation, Flutter and JavaScript essence, and became so strong that not even Professor Macena himself can take on them without being completely obliterated. The only ones who stand a chance and can defeat them are the chosen five.
	According to an ancient prophecy made by the CPU of Enlightenment, once the Ultimate Innovation is ready to strike with its universal destroying move, the only ones who can defeat it are the five best former Etec VGS students.",
	"Macena says that he believes that they are the chosen ones, and they are the only ones who can defeat Big Gus and his cohorts.
	He them invites them to his lunar base, where he and his dinossaur assistants have built a system to transport them to the deepest depths of the universe, where Big Gus is planning his ultimate atack.
	Reluctanly, they accept, despite knowing the danger of the task and that they may not return alive, and leave Chiquinho Sorvetes and embark on Macena's spaceship alongside him towards the lunar base.
	Once they arrive, they enter the special teletransportation system, prepared to fight and defeat Big Gus once and for all.
	The fate of Vargem Grande do Sul and the entire universe is in their hands."
]

func _ready() -> void:
	story.text = storyParts[0]
	advance.text = "Next"

func _on_advance_button_pressed() -> void:
	if (advance.text == "Begin"):
		Global.customPlayerNames.clear()
		Transition.changeScene("res://Scenes/character_naming.tscn")
	elif (currentPart < storyParts.size()):
		story.text = storyParts[currentPart]
		currentPart += 1
		if (currentPart == 3):
			advance.text = "Begin"
