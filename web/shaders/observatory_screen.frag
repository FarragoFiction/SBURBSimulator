varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

uniform bool overcoat;
uniform float beat;

const float distort_size = 45.0;
const float PI = 3.1415926535897932384626433832795;

const float speedlinescale = 2.0;
uniform sampler2D speedlines;
uniform vec2 velocity;
uniform float speedlineoffset;

const float minspeed = 450.0;
const float maxspeed = 750.0;

vec4 mixlines(vec2 c) {
    vec4 screen = texture2D(image, c);

    float speed = length(velocity);
    float factor = (speed - minspeed) / (maxspeed - minspeed);

    if (factor <= 0.0) {
        return screen;
    }

    factor = clamp(factor, 0.0,1.0);

    factor = factor * 0.5 + (factor * factor) * 0.5;

    vec2 dir;
    if (speed <= 0.0) {
        dir = vec2(1.0,0.0);
    } else {
        dir = normalize(velocity);
    }

    vec2 ratio = (size / (512.0 * speedlinescale));

    vec2 lc = c * ratio;

    lc = lc - 0.5 * ratio;
    lc = vec2(lc.x * dir.x - lc.y * dir.y, lc.x * dir.y + lc.y * dir.x);
    lc += 0.5 * ratio;
    lc.x += speedlineoffset;

    float lines = clamp(texture2D(speedlines, lc).r - (1.0 - factor), 0.0, 1.0) * 0.25;;

    vec4 col = screen;

    col.rgb += vec3(lines * 0.65, lines, lines * 0.65);

    return col;
}

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
        vec4 red = mixlines(distorted3);
        vec4 green = mixlines(distorted2);
        vec4 blue = mixlines(distorted);

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
