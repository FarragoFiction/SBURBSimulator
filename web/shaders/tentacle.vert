varying vec2 v_uv;


const int segments = 49;
uniform float total_curve;
uniform float total_offset;
uniform float tip_curve_mult;
uniform float tip_curve_exponent;
uniform float base_curve_mult;
uniform float base_curve_exponent;
uniform float period;

uniform vec2 size;

const float PI = 3.1415926535897932384626433832795;

vec2 angledOffset(float angle, float len) {
    return vec2(sin(angle), cos(angle)) * len;
}

float curveMult(float fraction) {
    return 1.0 + pow(fraction, tip_curve_exponent) * (tip_curve_mult - 1.0) + pow(1.0 - fraction, base_curve_exponent) * (base_curve_mult - 1.0);
}

void main() {
    float curve = total_curve / float(segments);
    float offset = total_offset / float(segments);

    v_uv = uv;

    float f_segments = float(segments);

    float segment_fraction = (position.y + 0.5) * f_segments;

    vec2 prevstep = vec2(0.0);
    float prevangle = 0.0;
    vec2 curstep = vec2(0.0);
    float curangle = 0.0;
    vec2 nextstep = vec2(0.0);
    float nextangle = 0.0;
    vec2 nextnextstep = vec2(0.0);
    float nextnextangle = 0.0;

    vec2 pos = vec2(0.0);
    float angle = 0.0;

    float periodangle = period * PI * 2.0;

    for (int i=0; i<segments; i++) {
        if (segment_fraction > float(i)) {
            float curvemult = curveMult(float(i) / f_segments);

            prevstep = curstep;
            prevangle = curangle;
            curstep = nextstep;
            curangle = nextangle;

            nextangle  = curangle + curve * sin(periodangle - offset * float(i)) * curvemult;
            nextstep = curstep + angledOffset(nextangle, size.y / f_segments);

            nextnextangle  = nextangle + curve * sin(periodangle - offset * float(i + 1)) * curvemult;
            nextnextstep = nextstep + angledOffset(nextnextangle, size.y / f_segments);

            float fraction = fract(segment_fraction);
            pos = mix(curstep,nextstep,fraction);
            angle = mix(mix(prevangle,curangle,0.5),mix(nextangle,nextnextangle,0.5),fraction);
        }
    }

    pos += angledOffset(angle + PI * 0.5, size.x * position.x);

    gl_Position = projectionMatrix * modelViewMatrix * vec4( pos, position.z, 1.0 );
}
