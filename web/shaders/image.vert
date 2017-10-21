
varying vec2 v_uv;

uniform vec2 size;

void main() {
    v_uv = uv;
    vec3 pos = position;
    pos.xy *= size;
    gl_Position = projectionMatrix * modelViewMatrix * vec4( pos, 1.0 );
}