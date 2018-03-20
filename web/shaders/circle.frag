varying vec2 v_uv;

uniform vec4 colour;

void main() {
	if (length(v_uv - 0.5) >= 0.5) {
	    discard;
	}
	gl_FragColor = colour;
}
