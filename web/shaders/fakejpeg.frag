varying vec2 v_uv;

uniform sampler2D image;
uniform vec2 size;

const int blocksize = 8;
const int kernelrad = 3;
const int kernelcount = (kernelrad * 2 + 1) * (kernelrad * 2 + 1);
const mat4 kernel = mat4(0.22508352, 0.11098164, 0.01330373, 0.00038771,
                         0.11098164, 0.05472157, 0.00655965, 0.00019117,
                         0.01330373, 0.00655965, 0.00078633, 0.00002292,
                         0.00038771, 0.00019117, 0.00002292, 0.00000067);

const mat3 rgb2yuv = mat3( 0.299,  0.587,  0.114,
                          -0.147, -0.289,  0.436,
                           0.615, -0.515, -0.100);

const mat3 yuv2rgb = mat3( 1.000,  0.000,  1.140,
                           1.000, -0.395, -0.581,
                           1.000,  2.032,  0.000);

int iabs(int i) {
    if (i < 0) {
        return i * -1;
    }
    return i;
}

int iclamp(int i, int min, int max) {
    if (i < min) {
        return min;
    }
    if (i > max) {
        return max;
    }
    return i;
}

float brightness(vec3 col) {
    //return 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b;
    return (col.r + col.g + col.b) / 3.0;
}

void main() {
    vec2 pos = v_uv * size;

    float gx = floor(mod(pos.x, float(blocksize)));
    float gy = floor(mod(pos.y, float(blocksize)));

    vec4 colour = texture2D(image, v_uv);

    vec4 blurred = vec4(0.0);
    vec4 average = vec4(0.0);

    vec2 offset = vec2(1.5);

    for (int y = -kernelrad; y <= kernelrad; y++) {
        for (int x = -kernelrad; x <= kernelrad; x++) {
            float ox = (float(x) * offset.x) + gx;
            float oy = (float(y) * offset.y) + gy;

            float mult = kernel[iabs(x)][iabs(y)];

            vec2 gpos = vec2(gx,gy) / size;
            vec2 spos = vec2(clamp(float(x) * (offset.x / size.x) + gpos.x, 0.0, float(blocksize)) - gpos.x,
                             clamp(float(y) * (offset.y / size.y) + gpos.y, 0.0, float(blocksize)) - gpos.y);

            vec4 poscol = texture2D(image, v_uv + spos);
            //average += poscol / float(kernelcount);
            blurred += poscol * mult;
        }
    }

    for (int y = 0; y<blocksize; y++) {
        for (int x = 0; x<blocksize; x++) {
            average += texture2D(image, v_uv + vec2(float(x)-gx,float(y)-gy) / size) / float(blocksize * blocksize);
        }
    }

    float diff = abs(brightness(colour.rgb) - brightness(blurred.rgb)) + abs(colour.a - blurred.a);

	vec4 mixcol = mix(colour, blurred, min(1.0, diff * 2.5));

	vec3 mixyuv = mixcol.rgb * rgb2yuv;
	vec3 aveyuv = average.rgb * rgb2yuv;
	vec3 mergedyuv = aveyuv;
	mergedyuv.r = mixyuv.r * 0.65 + aveyuv.r * 0.35;

	mixcol.rgb = mergedyuv * yuv2rgb;

	mixcol.a = colour.a * 0.25 + blurred.a * 0.45 + average.a * 0.3;

	gl_FragColor = mixcol;
}

