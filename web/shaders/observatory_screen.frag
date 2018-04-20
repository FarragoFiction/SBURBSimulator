varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

uniform bool overcoat;
uniform float beat;

const float distort_size = 45.0;
const float PI = 3.1415926535897932384626433832795;

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
    vec2 distorted2 = ((v_uv - 0.5) * (1.0 + distort_pixels * distortion * 0.875)) + 0.5;
    vec2 distorted3 = ((v_uv - 0.5) * (1.0 + distort_pixels * distortion * 0.75)) + 0.5;

    // scan

    float scan = sin(distorted.y * PI * size.y) * 0.1 + 1.0;

    if (!(distorted.x < 0.0 || distorted.x > 1.0 || distorted.y < 0.0 || distorted.y > 1.0)) {
        vec4 red = texture2D(image, distorted3);
        vec4 green = texture2D(image, distorted2);
        vec4 blue = texture2D(image, distorted);

        col = blue;
        col.r = red.r;
        col.g = green.g;

        if (overcoat) {
            vignette_darken *= 0.75 + 0.5 * (1.0 - beat);

            col += vignette_darken * 0.035;
            col.rb *= (1.0 - vignette_darken * 0.35) * scan;
            col.g *= (1.0 + vignette_darken * 0.85) * scan;
        } else {
            col.rgb *= (1.0 - vignette_darken * 0.35) * scan;
        }
	}

	gl_FragColor = col;
}
