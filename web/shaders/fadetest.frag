varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

void main() {
    vec4 colour = texture2D(image, v_uv);
    if (colour.a == 0.0) {
        discard;
    }

    colour.a *= 0.5;

	gl_FragColor = colour;
}
