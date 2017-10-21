varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

void main() {
	gl_FragColor = texture2D(image, v_uv);
}
