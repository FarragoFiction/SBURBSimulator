import "dart:async";
import "dart:math";
import "dart:typed_data";

import "../../includes/colour.dart";
import "../../includes/palette.dart";
import "../../loader/loader.dart";
import "../3d/three.dart" as THREE;
import "../renderer.dart";
import "../sprite/sprite.dart";

class RenderJobPassSprite extends RenderJobPass {
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;
    static THREE.Scene _scene;
    static THREE.Mesh _mesh;
    static THREE.ShaderMaterial _defaultMaterial;
    static THREE.DataTexture _paletteTexture;

    final String spritePath;
    final Iterable<Palette> palettes;
    final int x;
    final int y;
    THREE.ShaderMaterial materialOverride;

    RenderJobPassSprite(String this.spritePath, Iterable<Palette> this.palettes, [int this.x = 0, int this.y = 0, THREE.ShaderMaterial this.materialOverride]);

    @override
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        PSprite sprite = await Loader.getResource(spritePath);
        _processPalette(sprite, palettes);
        THREE.Texture texture = sprite.texture;

        THREE.ShaderMaterial material = this.materialOverride != null ? this.materialOverride : _defaultMaterial;

        THREE.getUniform(material, "image").value = texture;
        THREE.getUniform(material, "size").value = new THREE.Vector2(sprite.width, sprite.height);

        _mesh.material = material;
        _mesh.position..x = x + sprite.width * 0.5..y = y + sprite.height * 0.5;

        Renderer.webgl.render(_scene, _camera, target);
    }

    static void _processPalette(PSprite sprite, Iterable<Palette> palettes) {
        int index;
        Uint8List data = _paletteTexture.image.data;
        for(int i=0; i<256; i++) {
            index = i * 4;
            data[index] = 0;
            data[index+1] = 0;
            data[index+2] = 0;
            data[index+3] = 0;

            for (Palette palette in palettes) {
                if (sprite.paletteNames.containsKey(i)) {
                    String entry = sprite.paletteNames[i];
                    if (palette.containsName(entry)) {
                        Colour colour = palette[entry];

                        data[index] = colour.red;
                        data[index + 1] = colour.green;
                        data[index + 2] = colour.blue;
                        data[index + 3] = colour.alpha;
                    }
                }
            }
        }

        _paletteTexture.needsUpdate = true;
    }

    Future<Null> _initScene() async {
        if (_scene != null) { return; }

        _scene = new THREE.Scene();

        THREE.PlaneBufferGeometry plane = new THREE.PlaneBufferGeometry(1,1,1,1);

        Uint8List data = new Uint8List(256*4);
        _paletteTexture = new THREE.DataTexture(data, 256, 1, THREE.RGBAFormat, THREE.UnsignedByteType)
            ..minFilter = THREE.NearestFilter
            ..magFilter = THREE.NearestFilter
        ;

        _defaultMaterial = await THREE.makeShaderMaterial("shaders/image.vert", "shaders/sprite.frag")..transparent = true;
        THREE.setUniform(_defaultMaterial, "image", new THREE.ShaderUniform<THREE.Texture>());
        THREE.setUniform(_defaultMaterial, "size", new THREE.ShaderUniform<THREE.Vector2>());
        THREE.setUniform(_defaultMaterial, "palette", new THREE.ShaderUniform<THREE.TextureBase>()..value=_paletteTexture);

        _mesh = new THREE.Mesh(plane, _defaultMaterial)..rotation.x = PI;
        _scene.add(_mesh);
    }
}