extends Control

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	resized.connect(_on_screen_resized)
	_on_screen_resized()
	
	# Native signal that detects when the animation ends
	animationPlayer.animation_finished.connect(_on_animation_ended)
	
	# Centers misaligned animations
	sprite.animation_changed.connect(centerAnimationSprite)
	get_tree().root.size_changed.connect(centerAnimationSprite)
	
	# Use to test new animations that are added!!! by rafa
	#startAnimation("Anti-Innovation 2")

func startAnimation(animationName : String) -> void:
	if animationPlayer.has_animation(animationName):
		visible = true
		animationPlayer.play(animationName)
	else:
		push_error("The animation '", animationPlayer, "' does not exist in the animation player.")
		queue_free() # Avoids freezing the game if there is a typo XD

func _on_screen_resized() -> void:
	if size == Vector2.ZERO:
		return
	
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	if texture:
		var originalSizeVfx = texture.get_size()
		sprite.scale = size / originalSizeVfx
		sprite.position = size / 2

func centerAnimationSprite() -> void:
	if sprite.animation == "PK Freeze":
		var currentTexture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		
		if currentTexture:
			var textureWidth = currentTexture.get_size().x
			
			var desalignmentValue : float = 0.13
			sprite.offset.x = textureWidth * desalignmentValue
	else:
		sprite.offset.x = 0

func _on_animation_ended(animationName : String) -> void:
	print("VISUAL EFFECTS:: ANIMATION FINISHED!!!!!!!!!")
	queue_free()
