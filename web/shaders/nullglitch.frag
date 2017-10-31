varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;
uniform float seed;

highp float rand(vec2 co) {
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

void main() {
    vec2 offset = vec2(v_uv);
    offset.x += 2.0 / size.x;
    offset.y += 3.0 / size.y;

    float ro = rand(vec2(seed, floor(v_uv.y * size.y * (1.0 / 15.0))));
    ro = ro * ro * ro * ro * ro;

    offset.x += ro * (20.0 / size.x);

    vec4 maincol = texture2D(image, v_uv);
    vec4 offcol = texture2D(image, offset);

    vec4 colour = offcol;
    colour.g = maincol.g;
    colour.a = max(maincol.a, offcol.a * 0.66);

    if (colour.a == 0.0) {
        discard;
    }
	gl_FragColor = colour;
}