shader_type canvas_item;

uniform float sensitivity : hint_range(0.0, 1.0) = 0.15;
uniform float smoothness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	// Takes the color of the current animation's frame
	vec4 frameColor = texture(TEXTURE, UV);
	
	// Calculates the pixel's brightness
	float brightness = (frameColor.r + frameColor.g + frameColor.b) / 3.0;
	
	// If it's very dark (black background), transforms the alpha to 0 (transparent)
	float alpha = smoothstep(sensitivity, sensitivity + smoothness, brightness);
	
	COLOR = vec4(frameColor.rgb, frameColor.a * alpha);
}