varying vec2 v_uv;

void main() {
    v_uv = uv;

    vec2 pos = position.xy + 0.5;

    pos.y *= 100.0;

    pos.x *= 20.0;

    pos.x += sin(position.y * 8.0) * 20.0;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( pos - 0.5, position.z, 1.0 );
}
