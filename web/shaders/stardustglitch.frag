varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

uniform bool background;
uniform sampler2D data;
uniform sampler2D mask;
uniform vec2 datasize;
uniform int scale;
uniform vec2 offset;
uniform float strength;

const float tilesize = 16.0;

highp float rand(vec2 co) {
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

void main() {
    float scalef = float(scale);
	vec2 pixel = 1.0 / size;

	vec2 block = size / scalef;
	vec2 tile = size / (scalef * tilesize);

	vec2 datapos = (v_uv * size) / (scalef);
	vec2 datagrid = datapos / tilesize;

    vec2 maskcoords = floor(v_uv * block + 0.5) / block;
    vec2 tilecoords = floor(v_uv * tile + 0.5) / tile;

	float maskval = strength * (1.0 - texture2D(mask, maskcoords).r);
	float masktile = strength * (1.0 - texture2D(mask, tilecoords).r);
	float threshold = min(maskval, 0.65);

    vec2 datacoord = datapos / datasize;
    vec4 dataval = texture2D(data, datacoord);

    vec2 samplecoords = v_uv;

    if (dataval.r < threshold) {
        samplecoords = v_uv;

        float r = rand(maskcoords);

        if (r > 0.05) {
            float tilemove = clamp((masktile - 0.5) * 2.0, 0.0, 1.0);
            tilemove *= tilemove;
            tilemove *= tilemove;
            vec2 tileshift = floor((dataval.gb * 255.0 - 127.0) * tilemove) * tilesize;

            samplecoords += tileshift * scalef * pixel;
        }

        samplecoords += offset * pixel * scalef;
        samplecoords = fract(samplecoords);
        //gl_FragColor = dataval;
    } else {
        if (background) {
            discard;
        }
    }


	gl_FragColor = texture2D(image, samplecoords);
	//gl_FragColor = dataval;
}
