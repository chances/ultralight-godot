shader_type sky;

uniform vec3 color: source_color = vec3(0.2, 0.6, 1.0);
uniform vec3 horizon: source_color = vec3(0.651, 0.84, 0.63);

vec3 skyAt(vec3 eye) {
	float factor = clamp(eye.y / 0.1, 0, 1);
  // TODO: Scatter more skylight at higher eye directions
	vec3 base = mix(horizon, color, factor) * LIGHT0_ENERGY;
	if (AT_QUARTER_RES_PASS) return base;
	else if (AT_HALF_RES_PASS) return base;
	else return base;
}

// Called for every visible pixel in the sky background, as well as all pixels in the radiance cubemap.
void sky() {
	COLOR = AT_CUBEMAP_PASS ? color : skyAt(EYEDIR);
}
