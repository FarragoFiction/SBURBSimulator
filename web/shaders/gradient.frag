varying vec2 v_uv;

uniform sampler2D image; // pass the Bayer matrix texture here
uniform vec2 size;

uniform vec4 col_a;
uniform vec4 col_b;
uniform vec4 pos;

const mat3 rgb2yuv = mat3( 0.299,  0.587,  0.114,
                          -0.147, -0.289,  0.436,
                           0.615, -0.515, -0.100);

const mat3 yuv2rgb = mat3( 1.000,  0.000,  1.140,
                           1.000, -0.395, -0.581,
                           1.000,  2.032,  0.000);

float linear(vec2 axis, vec2 point) {
    return dot(point, normalize(axis)) / length(axis);
}

float radial(vec2 axis, vec2 point) {
    return length(point) / length(axis);
}

void main() {
    vec2 axis = pos.zw - pos.xy;
    vec2 point = (v_uv * size) - pos.xy;

    float projection = linear(axis, point);

    vec4 yuv_a = col_a;
    yuv_a.rgb *= rgb2yuv;
    vec4 yuv_b = col_b;
    yuv_b.rgb *= rgb2yuv;

    vec4 gradcol = mix(yuv_a, yuv_b, projection);
    gradcol.rgb *= yuv2rgb;

    /*if (projection > 1.0 || projection < 0.0) {
        gradcol.a = 0.0;
    }*/

	gl_FragColor = gradcol;
}

