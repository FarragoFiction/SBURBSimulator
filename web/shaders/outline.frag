varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

uniform vec4 outline_colour;
const int outline_thickness = 3;

void main() {
	vec4 tex = texture2D(image, v_uv);

	gl_FragColor = tex;

	if (tex.a < 1.0) {
	    vec2 pixel = 1.0 / size;
	    float density = 0.0;

	    for (int x = -outline_thickness; x <= outline_thickness; x++) {
	        for (int y = -outline_thickness; y <= outline_thickness; y++) {
        	    if (length(vec2(x,y)) <= float(outline_thickness)) {
                    vec4 col = vec4(0.0,0.0,0.0,0.0);
                    if (x==0 && y==0) {
                        col = tex;
                    } else {
                        col = texture2D(image, v_uv + vec2(x,y) * pixel);
                    }

                    if (col.a > density) {
                        density = col.a;
                    }
        	    }
        	}
	    }

        vec4 line = outline_colour;
        line.a *= density;

        vec4 mixcol = tex * tex.a + line * (1.0 - tex.a);
        mixcol.a = tex.a + line.a * (1.0 - tex.a);

	    gl_FragColor = mixcol;
	}
}
