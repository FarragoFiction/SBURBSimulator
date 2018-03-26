varying vec2 v_uv;

uniform vec2 size;

uniform float glow_thickness;
uniform vec4 tentacle_colour;
uniform vec4 glow_colour;

void main() {
    vec2 pixel = 1.0 / size;
	vec4 col = tentacle_colour;

    vec2 halo = glow_thickness * pixel;

    float taper = v_uv.y * (1.0 + halo.y);

    float sideval = abs(v_uv - 0.5).x;
    float sidelimit = 0.5 - halo.x * (1.0 - v_uv.y);
    float sidetaper = sidelimit - taper * 0.5;

	if (sideval > sidetaper + halo.x) {
	    discard;
	} else if (sideval > sidetaper) {
	    float glowfrac = 1.0 - ((sideval - sidetaper) / halo.x);
	    float tipglow = clamp((1.0 - v_uv.y) / (halo.y * 3.0), 0.0, 1.0);

	    glowfrac *= tipglow;

	    col = glow_colour;
	    col.a *= glowfrac;
	}

	gl_FragColor = col;
}
