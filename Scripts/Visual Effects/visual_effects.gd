extends Control

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

var animationBank = {
	"PK Starstorm": "res://Resources/Animations/Sprite Frames/PSI/pkStarstorm.tres",
	"PK Starstorm 2": "res://Resources/Animations/Sprite Frames/PSI/pkStarstorm2.tres",
	"PK Fire": "res://Resources/Animations/Sprite Frames/PSI/pkFire.tres",
	"PK Fire 2": "res://Resources/Animations/Sprite Frames/PSI/pkFire2.tres",
	"PK Freeze": "res://Resources/Animations/Sprite Frames/PSI/pkFreeze.tres",
	"Anti-Innovation": "res://Resources/Animations/Sprite Frames/Dark Arts/antiInnovation.tres",
	"Anti-Innovation 2": "res://Resources/Animations/Sprite Frames/Dark Arts/antiInnovation2.tres",
	"Globalization": "res://Resources/Animations/Sprite Frames/Dark Arts/globalization.tres",
	"Logarithms": "res://Resources/Animations/Sprite Frames/Dark Arts/logarithms.tres",
	"Thunderstorm": "res://Resources/Animations/Sprite Frames/Caipira Powers/thunderstorm.tres",
	"Friendship Star": "res://Resources/Animations/Sprite Frames/Friendship Magic/friendshipStar.tres",
	"Power Shield": "res://Resources/Animations/Sprite Frames/Friendship Magic/powerShield.tres",
	"Rainbow Comet": "res://Resources/Animations/Sprite Frames/Friendship Magic/rainbowComet.tres"
}

func _ready() -> void:
	resized.connect(_on_screen_resized)
	_on_screen_resized()
	
	# Native signal that detects when the animation ends
	animationPlayer.animation_finished.connect(_on_animation_ended)
	
	# Centers misaligned animations
	sprite.animation_changed.connect(centerAnimationSprite)
	get_tree().root.size_changed.connect(centerAnimationSprite)
	
	# Use to test new animations that are added!!! by rafa
	#startAnimation("Thunderstorm")

func startAnimation(animationName : String) -> void:
	if animationBank.has(animationName):
		print("Animation Started Playing...")
		var animationPath = animationBank[animationName]
		
		sprite.sprite_frames = load(animationPath)
		adjustAnimationSize(animationName)
		
		visible = true
		sprite.play(animationName)
		animationPlayer.play(animationName)
	else:
		push_error("The animation '", animationPlayer, "' does not exist in the animation player.")
		queue_free() # Avoids freezing the game if there is a typo XD

func _on_screen_resized() -> void:
	if size == Vector2.ZERO:
		return
	
	if (sprite.sprite_frames != null):
		var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		
		if texture:
			var originalSizeVfx = texture.get_size()
			sprite.scale = size / originalSizeVfx
			sprite.position = size / 2

func adjustAnimationSize(animationName : String) -> void:
	var texture = sprite.sprite_frames.get_frame_texture(animationName, 0)
	
	if (texture):
		var originalSize = texture.get_size()
		var screenSize = get_viewport_rect().size
		
		sprite.scale.x = screenSize.x / originalSize.x
		sprite.scale.y = screenSize.y / originalSize.y
	
		if (sprite.centered):
			sprite.global_position = screenSize / 2
		else:
			sprite.global_position = Vector2.ZERO

func centerAnimationSprite() -> void:
	if (sprite.animation == "PK Freeze" || sprite.animation == "Thunderstorm"):
		var currentTexture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		
		if currentTexture:
			var textureWidth = currentTexture.get_size().x
			
			var desalignmentValue : float = 0.13
			sprite.offset.x = textureWidth * desalignmentValue
	else:
		sprite.offset.x = 0

func _on_animation_ended(animationName : String) -> void:
	print("VISUAL EFFECTS:: ANIMATION FINISHED!!!!!!!!!")
	sprite.sprite_frames = null
	queue_free()
