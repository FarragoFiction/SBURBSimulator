
varying vec2 v_uv;

const int pixelsize = 512;

vec4 centred_circle(vec4 col, float radius, float dist, float dist_max, vec4 colour) {
    if (dist < radius && dist_max >= radius) {
        return colour;
    }
    return col;
}

vec4 halo_circle(vec4 col, float inner, float outer, float dist, vec4 inner_col, vec4 outer_col) {
    if (dist < outer && dist > inner) {
        return mix(inner_col, outer_col, (dist - inner) / (outer - inner));
    }
    return col;
}

//for values of t from 0 to 14 * PI:
//x = 17 * cos(t) - 7 * cos(17 * t / 7)
//y = 17 * sin(t) - 7 * sin(17 * t / 7)

const float PI = 3.1415926535897932384626433832795;
const int steps = 350;
vec4 spiro() {
    for (int i=0; i<14 * steps; i++) {
        float t = (float(i) / float(steps)) * PI;
        vec2 plot = vec2(17.0 * cos(t) - 7.0 * cos(17.0 * t / 7.0), 17.0 * sin(t) - 7.0 * sin(17.0 * t / 7.0));

        plot *= 0.01;

        if ( length((v_uv - 0.5) - plot) < 0.002) {
            return vec4(1.0,1.0,1.0, 1.0);
        }
    }
    return vec4(1.0,1.0,1.0, 0.0);
}

void main() {
    float pixel = 1.0 / float(pixelsize);
    vec3 offset = vec3(-1,0,1) * pixel;

    vec4 col = vec4(1.0,1.0,1.0,0.0);

    float dist = length((v_uv - 0.5) * 2.0);

    float dist_l = length((v_uv + offset.xy - 0.5) * 2.0);
    float dist_r = length((v_uv + offset.zy - 0.5) * 2.0);
    float dist_u = length((v_uv + offset.yx - 0.5) * 2.0);
    float dist_d = length((v_uv + offset.yz - 0.5) * 2.0);

    float dist_max = max(max(dist_l, dist_r), max(dist_u, dist_d));
    float dist_min = min(min(dist_l, dist_r), min(dist_u, dist_d));

    //col = halo_circle(col, 0.9, 1.0, dist, vec4(1.0,1.0,1.0,0.25), vec4(1.0,1.0,1.0,0.0));

    //col = centred_circle(col, 0.8, dist, dist_max, vec4(1.0,1.0,1.0,0.45)); // veil
    //col = centred_circle(col, 0.55, dist, dist_max, vec4(1.0,1.0,1.0,1.0)); // derse
    //col = centred_circle(col, 0.1, dist, dist_max, vec4(1.0,1.0,1.0,1.0)); // prospit

    //col = centred_circle(col, 0.05, dist, dist_max, vec4(1.0,1.0,1.0,1.0)); // skaia
    //if (dist < 0.05) {
    //    col.a = 1.0;
    //}

    //col = spiro();

	gl_FragColor = col;
}
