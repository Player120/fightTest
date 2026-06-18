extends Control

@onready var nameText : Label = $VBoxContainer/PlayerName
@onready var hpNumber : Label = $VBoxContainer/hpContainer/hpNumber
@onready var ppNumber : Label = $VBoxContainer/ppContainer/ppNumber
@onready var background : TextureRect = $BackgroundSprite
@onready var playerSprite : TextureRect = $PlayerSprite

var trackedPlayer : player

func playerSpriteMove(direction : String) -> void:
	var myTween = create_tween()
	var yTarget : int = 0
	
	if (direction == "up"):
		yTarget = position.y - 115
	elif (direction == "down"):
		yTarget = position.y + 115
	
	# Transitions the property position:y to the target in 0.6 sec
	myTween.tween_property(playerSprite, "position:y", yTarget, 0.6)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN_OUT)

func initializeWithPlayer(data : player) -> void:
	trackedPlayer = data
	nameText.text = trackedPlayer.charName
	background.modulate = trackedPlayer.themeColor
	playerSprite.texture = load(trackedPlayer.sprite)

func updateUIText(stat : String, value : int) -> void:
	match stat:
		"health":
			hpNumber.text = str(value)
		"powerPoints":
			ppNumber.text = str(value)
		_:
			hpNumber.text = "something went wrong..."
			ppNumber.text = "check for errors"
