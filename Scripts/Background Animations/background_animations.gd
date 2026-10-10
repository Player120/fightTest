extends Control

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	resized.connect(_on_screen_resized)
	_on_screen_resized()

func _on_screen_resized() -> void:
	if size == Vector2.ZERO:
		return
	
	if (sprite.sprite_frames != null):
		var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		
		if texture:
			var originalSizeVfx = texture.get_size()
			sprite.scale = size / originalSizeVfx
			sprite.position = size / 2
