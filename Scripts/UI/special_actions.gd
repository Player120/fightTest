extends Control

@onready var background : TextureRect = $SpecialActionsBackground

func specialGradient(currentPlayer : player) -> void:
	# Writing shader code manually
	var shaderCode = """
	shader_type canvas_item;
	
	uniform vec4 leftColor : source_color;
	uniform vec4 rightColor : source_color;
	
	void fragment() {
		vec4 originalColor = texture(TEXTURE, UV);
		vec4 gradient = mix(leftColor, rightColor, UV.x);
		
		COLOR = originalColor * gradient;
	}
	"""
	
	# Creates material resources at runtime
	var newShader : Shader = Shader.new()
	newShader.code = shaderCode
	
	var shaderMaterial : ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = newShader
	
	# Defining the gradient's colors
	shaderMaterial.set_shader_parameter("leftColor", currentPlayer.themeColor)
	shaderMaterial.set_shader_parameter("rightColor", currentPlayer.themeColor.from_hsv(
		currentPlayer.themeColor.h + 0.7,
		currentPlayer.themeColor.s, 
		currentPlayer.themeColor.v
	))
	
	# Applying the material to the node
	background.material = shaderMaterial
	
