varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

void main() {
    vec3 offset = vec3(0.0, 1.0, -1.0);
    vec2 d = vec2(1.0) / size;
    vec4 sum = vec4(0.0);

    sum += -1.0 * texture2D(image, v_uv + offset.zx * d);
    sum += -1.0 * texture2D(image, v_uv + offset.xz * d);
    sum +=  5.0 * texture2D(image, v_uv);
    sum += -1.0 * texture2D(image, v_uv + offset.xy * d);
    sum += -1.0 * texture2D(image, v_uv + offset.yx * d);

	gl_FragColor = sum;
}
