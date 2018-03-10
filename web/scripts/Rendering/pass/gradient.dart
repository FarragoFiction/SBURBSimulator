import "dart:async";
import "dart:js" as JS;
import "dart:math";
import "dart:typed_data";

import '../../includes/colour.dart';
import '../../includes/predicates.dart';
import "../threed/three.dart" as THREE;
import "../renderer.dart";

enum RJPGradientType {
    LINEAR,
    RADIAL,
    ANGLE,
}

class RenderJobPassGradient extends RenderJobPass {
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;
    static THREE.Scene _scene;
    static THREE.Mesh _mesh;
    static THREE.ShaderMaterial _defaultMaterial;
    static THREE.DataTexture _solid;
    static THREE.DataTexture _bayer;

    final int x;
    final int y;
    final int width;
    final int height;

    THREE.Vector4 _pos;
    List<Tuple<double,Colour>> _colours = <Tuple<double,Colour>>[];
    double useGamma = 0.0;
    double smoothing = 0.0;
    double repeat = 1.0;
    THREE.TextureBase mask = null;
    RJPGradientType gradient_type = RJPGradientType.LINEAR;

    RenderJobPassGradient(int this.x, int this.y, int this.width, int this.height, int start_x, int start_y, int end_x, int end_y) {
        this._pos = new THREE.Vector4(start_x, height - start_y, end_x, height - end_y);
    }

    void addStop(double pos, Colour colour) {
        if (_colours.length >= 32) { throw "Gradient shader can't handle more than 32 gradient stops!"; }
        _colours.add(new Tuple<double, Colour>(pos,colour));
    }

    @override
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        _colours.sort((Tuple<double, Colour> a, Tuple<double, Colour> b) => a.first.compareTo(b.first));

        List<double> colourvals = <double>[];
        for (Tuple<double,Colour> t in _colours) {
            colourvals.add(t.second.redDouble);
            colourvals.add(t.second.greenDouble);
            colourvals.add(t.second.blueDouble);
            colourvals.add(t.second.alphaDouble);
        }

        THREE.ShaderMaterial material = _defaultMaterial;

        THREE.getUniform(material, "image").value = this.mask != null ? this.mask : _solid;
        THREE.getUniform(material, "size").value = new THREE.Vector2(width, height);
        THREE.getUniform(material, "pos").value = this._pos;
        THREE.getUniform(material, "gradient_type").value = gradient_type.index;
        THREE.getUniform(material, "stops").value = new JS.JsArray<double>.from(_colours.map((Tuple<double,Colour> t) => t.first));
        THREE.getUniform(material, "colours").value = new JS.JsArray<double>.from(colourvals);
        THREE.getUniform(material, "colour_count").value = _colours.length;
        THREE.getUniform(material, "useGamma").value = useGamma.clamp(0.0, 1.0);
        THREE.getUniform(material, "smoothing").value = smoothing.clamp(0.0, 1.0);
        THREE.getUniform(material, "repeat").value = max(0.0,repeat);

        _mesh.material = material;
        _mesh.position..x = x + width * 0.5..y = y + height * 0.5;

        Renderer.webgl.render(_scene, _camera, target);
    }

    Future<Null> _initScene() async {
        if (_scene != null) { return; }

        _scene = new THREE.Scene();

        THREE.PlaneBufferGeometry plane = new THREE.PlaneBufferGeometry(1,1,1,1);

        Uint8List bayerdata = new Uint8List.fromList(<int>[
             0, 32,  8, 40,  2, 34, 10, 42,
            48, 16, 56, 24, 50, 18, 58, 26,
            12, 44,  4, 36, 14, 46,  6, 38,
            60, 28, 52, 20, 62, 30, 54, 22,
             3, 35, 11, 43,  1, 33,  9, 41,
            51, 19, 59, 27, 49, 17, 57, 25,
            15, 47,  7, 39, 13, 45,  5, 37,
            63, 31, 55, 23, 61, 29, 53, 21
        ]);

        _bayer = new THREE.DataTexture(bayerdata, 8, 8, THREE.LuminanceFormat, THREE.UnsignedByteType)
            ..minFilter = THREE.NearestFilter
            ..magFilter = THREE.NearestFilter
            ..needsUpdate = true
        ;

        _solid = new THREE.DataTexture(new Uint8List.fromList(<int>[0]), 1, 1, THREE.LuminanceFormat, THREE.UnsignedByteType)..needsUpdate=true;

        _defaultMaterial = await THREE.makeShaderMaterial("shaders/image.vert", "shaders/gradient.frag")..transparent = true;
        THREE.setUniform(_defaultMaterial, "image", new THREE.ShaderUniform<THREE.TextureBase>());
        THREE.setUniform(_defaultMaterial, "bayer", new THREE.ShaderUniform<THREE.TextureBase>()..value = _bayer);
        THREE.setUniform(_defaultMaterial, "size", new THREE.ShaderUniform<THREE.Vector2>());
        THREE.setUniform(_defaultMaterial, "pos", new THREE.ShaderUniform<THREE.Vector4>());
        THREE.setUniform(_defaultMaterial, "gradient_type", new THREE.ShaderUniform<int>());
        THREE.setUniform(_defaultMaterial, "colour_count", new THREE.ShaderUniform<int>());
        THREE.setUniform(_defaultMaterial, "colours", new THREE.ShaderUniform<List<double>>());
        THREE.setUniform(_defaultMaterial, "stops", new THREE.ShaderUniform<List<double>>());
        THREE.setUniform(_defaultMaterial, "useGamma", new THREE.ShaderUniform<double>());
        THREE.setUniform(_defaultMaterial, "smoothing", new THREE.ShaderUniform<double>());
        THREE.setUniform(_defaultMaterial, "repeat", new THREE.ShaderUniform<double>());

        _mesh = new THREE.Mesh(plane, _defaultMaterial)..rotation.x = PI;
        _scene.add(_mesh);
    }
}