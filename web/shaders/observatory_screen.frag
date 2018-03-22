varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

const float distort_size = 45.0;

void main() {
    vec2 pixel = 1.0 / size;
    vec4 col = vec4(0.5,0.5,0.5,1.0);

    // distortion

    vec2 distort_pixels = distort_size * pixel;

    vec2 centred = abs((v_uv - 0.5) * 2.0);
    vec2 curve = centred * centred;

    vec2 distortion = curve * curve.yx;

    vec2 vignette = mix(distortion, curve, 0.75);
    vignette *= vignette * 2.0;

    float vignette_darken = max(vignette.x, vignette.y);

    vec2 distorted = ((v_uv - 0.5) * (1.0 + distort_pixels * distortion)) + 0.5;

    if (!(distorted.x < 0.0 || distorted.x > 1.0 || distorted.y < 0.0 || distorted.y > 1.0)) {
        col = texture2D(image, distorted);
        col.rgb *= (1.0 - vignette_darken * 0.35);
	}

	gl_FragColor = col;
}
