shader_type sky;

uniform vec3 color: source_color = vec3(0.2, 0.6, 1.0);
// The `Environment`'s ambient light color controls the sunlight's average scattered color, i.e. the horizon's color.
// See https://earthscience.stackexchange.com/a/24632/26582
uniform vec3 horizon: source_color = vec3(0.5, 0.75, 1.0);
uniform vec2 hazePeriod = vec2(5.0, 10.0);

vec2 modulo(vec2 numerator, vec2 divisor) {
	vec2 positiveNumerator = mod(numerator, divisor) + divisor;
	return mod(positiveNumerator, divisor);
}

vec2 random(vec2 value) {
	value = vec2( dot(value, vec2(127.1,311.7) ),
				  dot(value, vec2(269.5,183.3) ) );
	return -1.0 + 2.0 * fract(sin(value) * 43758.5453123);
}

const float noiseScale = 20.0;
/** Generate seamless perlin noise. */
float noise(vec2 uv) {
	uv = uv * noiseScale;
	vec2 cellsMinimum = floor(uv);
	vec2 cellsMaximum = ceil(uv);

	cellsMinimum = modulo(cellsMinimum, hazePeriod);
	cellsMaximum = modulo(cellsMaximum, hazePeriod);

	vec2 lowerLeftDirection = random(vec2(cellsMinimum.x, cellsMinimum.y));
	vec2 lowerRightDirection = random(vec2(cellsMaximum.x, cellsMinimum.y));
	vec2 upperLeftDirection = random(vec2(cellsMinimum.x, cellsMaximum.y));
	vec2 upperRightDirection = random(vec2(cellsMaximum.x, cellsMaximum.y));

	vec2 blur = smoothstep(0, 1, fract(uv));
	vec2 fraction = fract(uv);
	return mix(
    mix(
      dot(lowerLeftDirection, fraction - vec2(0, 0)),
      dot(lowerRightDirection, fraction - vec2(1, 0)),
      blur.x
    ),
    mix(
      dot(upperLeftDirection, fraction - vec2(0, 1)),
      dot(upperRightDirection, fraction - vec2(1, 1)),
      blur.x
    ),
    blur.y
  ) * 0.8 + 0.5;
}

vec3 skyAt(vec3 eye) {
	float factor = clamp(eye.y / 0.1, 0, 1);
  float haze = noise(vec2(eye.x, eye.y)) * factor;
  // TODO: Scatter more skylight at higher eye directions
	vec3 base = mix(horizon, color, factor * haze) * LIGHT0_ENERGY;
	if (AT_QUARTER_RES_PASS) return base;
	else if (AT_HALF_RES_PASS) return base;
	else return base;
}

// Called for every visible pixel in the sky background, as well as all pixels in the radiance cubemap.
void sky() {
	COLOR = AT_CUBEMAP_PASS ? color : skyAt(EYEDIR);
}
