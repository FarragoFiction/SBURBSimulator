varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

void main() {
	//gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);

	gl_FragColor = texture2D(image, v_uv);
	//gl_FragColor.a = 1.0;
	//gl_FragColor.r = 1.0;

	//gl_FragColor = vec4(1.0,1.0,1.0,1.0);
	//gl_FragColor.rg = v_uv;
}
