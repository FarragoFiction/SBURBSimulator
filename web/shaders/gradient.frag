varying vec2 v_uv;

uniform sampler2D image; // mask which just uses alpha
uniform vec2 size;

uniform sampler2D bayer; // bayer matrix for dithering
uniform vec4 pos;
uniform int gradient_type;
uniform int colour_count;
const int max_colour_count = 32;
uniform vec4 colours[max_colour_count];
uniform float stops[max_colour_count];

uniform float useGamma;
uniform float smoothing;
uniform float repeat;

const float gamma = 2.2;
const float gamma_i = 1.0 / gamma;

const float PI = 3.14159265359;

float g_linear(vec2 axis, vec2 point) {
    return dot(point, normalize(axis)) / length(axis);
}

float g_radial(vec2 axis, vec2 point) {
    return length(point) / length(axis);
}

float g_angle(vec2 axis, vec2 point) {
    float diffangle = atan(point.y,point.x) - atan(axis.y,axis.x);
    float offsetangle = atan(axis.y + 1.0,axis.x) - atan(axis.y,axis.x);

    float angle =  - (diffangle + offsetangle);
    if (angle < 0.0) {
        angle += PI * 2.0;
    } else if (angle > PI * 2.0) {
        angle -= PI * 2.0;
    }

    return (angle) / (PI * 2.0);
}

float getProjection(vec2 axis, vec2 point) {
    float val = 0.0;

    if (gradient_type == 0) {
        val = g_linear(axis, point);
    } else if (gradient_type == 1) {
        val = g_radial(axis, point);
    } else if (gradient_type == 2) {
        val = g_angle(axis, point);
    }

    if (val < 0.0) {
        return 0.0;
    } else if (val > 1.0) {
        return 1.0;
    }

    return mod(val * repeat, 1.0);
}

vec4 getColour(int id) {
    for (int i=0; i<max_colour_count; i++) {
        if (i == id) {
            return colours[i];
        }
    }
    return colours[0];
}

float getStop(int id) {
    for (int i=0; i<max_colour_count; i++) {
        if (i == id) {
            return stops[i];
        }
    }
    return stops[0];
}

void main() {
    vec2 pixel = v_uv * size;
    vec2 axis = pos.zw - pos.xy;
    vec2 point = pixel - pos.xy;

    float projection = getProjection(axis, point);

    projection = mix(smoothstep(0.0, 1.0, projection), projection, smoothing);

    int last = 0;
    for (int i=0; i<max_colour_count; i++) {
        if (i < colour_count) {
            if (stops[i] <= projection) {
                last = i;
            }
        }
    }
    int current = last;
    if (current < max_colour_count) {
        current++;
    }

    float stop_a = getStop(last);
    float stop_b = getStop(current);
    float fraction = (projection - stop_a) / (stop_b - stop_a);

    vec4 ccol_a = getColour(last);
    vec4 ccol_b = getColour(current);

    vec4 gammacol = vec4(0.0);
    gammacol.r = pow(abs(mix(pow(abs(ccol_a.r), gamma), pow(abs(ccol_b.r), gamma), fraction)), gamma_i);
    gammacol.g = pow(abs(mix(pow(abs(ccol_a.g), gamma), pow(abs(ccol_b.g), gamma), fraction)), gamma_i);
    gammacol.b = pow(abs(mix(pow(abs(ccol_a.b), gamma), pow(abs(ccol_b.b), gamma), fraction)), gamma_i);

    vec4 mixcol = mix(ccol_a, ccol_b, fraction);

    vec4 gradcol = mix(mixcol, gammacol, useGamma);

    gradcol.a = mix(ccol_a.a, ccol_b.a, fraction);

    vec4 dither = texture2D(bayer, mod(pixel, 8.0) / 8.0);

    vec4 mask = texture2D(image, v_uv);
    gradcol.a *= mask.a;

    //if (v_uv.y > 0.5) {
    gradcol.rgb += dither.rgb / 64.0;
    //}

	gl_FragColor = gradcol;
}

