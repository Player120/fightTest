shader_type canvas_item;

instance uniform float quantity : hint_range(0.0, 1.0) = 0.0;
instance uniform bool active = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 originalColor = texture(TEXTURE, UV);
	vec3 whiteColor = vec3(1.0, 1.0, 1.0);
	float alpha = originalColor.a * COLOR.a;
	// Keeps the original transparency (alpha channel), but forces the RGB color to pure white (1, 1, 1)
	if (active) {
		COLOR = vec4(mix(originalColor.rgb, whiteColor, quantity), alpha);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
