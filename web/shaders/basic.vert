
varying vec2 v_uv;

uniform vec2 size;

void main() {
    v_uv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}
