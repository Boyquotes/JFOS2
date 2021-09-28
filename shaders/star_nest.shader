// Star Nest by Pablo Roman Andrioli
// https://www.shadertoy.com/view/XlfGRj

// This content is under the MIT License.

shader_type spatial;
render_mode unshaded;

const float PI_OVER_180 = 0.0174532925;

const int iterations = 17;
const float formuparam = 0.53;

const int volsteps = 20;
const float stepsize = 0.1;

const float tile = 0.85;

const float brightness = 0.0015;
const float darkmatter = 0.3;
const float distfading = 0.73;

uniform vec2 position = vec2(0.0, 0.0);
uniform vec2 rotation = vec2(0.5, 0.8);
uniform float speed : hint_range(0.0, 10.0, 0.001) = 0.01;
uniform float direction : hint_range(0.0, 360.0, 1.0) = 30;
uniform float zoom : hint_range(0.0001, 1.0, 0.0001) = 0.1;
uniform float saturation : hint_range(0.0, 1.0, 0.01) = 0.85;
uniform vec4 tint : hint_color = vec4(1.0);

float srgb_to_linear(float srgb) {
	return srgb < 0.04045 ? srgb / 12.92 : pow((srgb + 0.055) / 1.055, 2.4);
}

vec3 srgb_to_linear_vec(vec3 srgb) {
	return vec3(srgb_to_linear(srgb.r), srgb_to_linear(srgb.g), srgb_to_linear(srgb.b));
}

void fragment() {
	// get coords and direction
	vec2 uv = FRAGCOORD.xy / VIEWPORT_SIZE.xy - 0.5;
	uv.y *= VIEWPORT_SIZE.y / VIEWPORT_SIZE.x;
	vec3 dir = vec3(uv * zoom, 1.0);
	float time = TIME * speed + 0.25;

	// rotation
	float a1 = rotation.x;
	float a2 = rotation.y;
	mat2 rot1 = mat2(vec2(cos(a1), sin(a1)), vec2(-sin(a1), cos(a1)));
	mat2 rot2 = mat2(vec2(cos(a2), sin(a2)), vec2(-sin(a2), cos(a2)));
	dir.xz *= rot1;
	dir.xy *= rot2;
	vec3 from = vec3(position, 0.5);
	from += vec3(cos(direction * PI_OVER_180) * time, sin(direction * PI_OVER_180) * time, -2.0);
	from.xz *= rot1;
	from.xy *= rot2;
	
	// volumetric rendering
	float s = 0.1, fade = 1.0;
	vec3 v = vec3(0.0);
	for (int r = 0; r < volsteps; r++) {
		vec3 p = from + s * dir * 0.5;
		p = abs(vec3(tile) - mod(p, vec3(tile * 2.0))); // tiling fold
		float pa, a = pa = 0.0;
		for (int i = 0; i < iterations; i++) { 
			p = abs(p) / dot(p, p) - formuparam; // the magic formula
			a += abs(length(p) - pa); // absolute sum of average change
			pa = length(p);
		}
		float dm = max(0.0, darkmatter - a * a * 0.001); //dark matter
		a *= a * a; // add contrast
		if (r > 6) fade *= 1.0 - dm; // dark matter, don't render near
		//v += vec3(dm, dm * 0.5, 0.0);
		v += fade;
		v += vec3(s, s * s, s * s * s * s) * a * brightness * fade; // coloring based on distance
		fade *= distfading; // distance fading
		s += stepsize;
	}
	v = mix(vec3(length(v)), v, saturation); // color adjust
	ALBEDO = srgb_to_linear_vec(min(v * 0.01, vec3(1.0))) * tint.rgb;
}