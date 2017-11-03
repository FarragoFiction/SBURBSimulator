import "dart:async";
import "dart:math";

import '../../includes/colour.dart';
import "../3d/three.dart" as THREE;
import "../renderer.dart";

class RenderJobPassGradient extends RenderJobPass {
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;
    static THREE.Scene _scene;
    static THREE.Mesh _mesh;
    static THREE.ShaderMaterial _defaultMaterial;

    final int x;
    final int y;
    final int width;
    final int height;
    final Colour colour_a;
    final Colour colour_b;
    final THREE.Vector2 pos_a;
    final THREE.Vector2 pos_b;

    RenderJobPassGradient(int this.x, int this.y, int this.width, int this.height, Colour this.colour_a, Colour this.colour_b, THREE.Vector2 this.pos_a, THREE.Vector2 this.pos_b);

    @override
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        THREE.ShaderMaterial material = _defaultMaterial;

        //THREE.getUniform(material, "image").value = bayer;
        THREE.getUniform(material, "size").value = new THREE.Vector2(width, height);
        THREE.getUniform(material, "col_a").value = new THREE.Vector4(colour_a.redDouble, colour_a.greenDouble, colour_a.blueDouble, colour_a.alphaDouble);
        THREE.getUniform(material, "col_b").value = new THREE.Vector4(colour_b.redDouble, colour_b.greenDouble, colour_b.blueDouble, colour_b.alphaDouble);
        THREE.getUniform(material, "pos").value = new THREE.Vector4(pos_a.x, height - pos_a.y, pos_b.x, height - pos_b.y);

        _mesh.material = material;
        _mesh.position..x = x + width * 0.5..y = y + height * 0.5;

        Renderer.webgl.render(_scene, _camera, target);
    }

    Future<Null> _initScene() async {
        if (_scene != null) { return; }

        _scene = new THREE.Scene();

        THREE.PlaneBufferGeometry plane = new THREE.PlaneBufferGeometry(1,1,1,1);

        _defaultMaterial = await THREE.makeShaderMaterial("shaders/image.vert", "shaders/gradient.frag")..transparent = true;
        THREE.setUniform(_defaultMaterial, "image", new THREE.ShaderUniform<THREE.Texture>());
        THREE.setUniform(_defaultMaterial, "size", new THREE.ShaderUniform<THREE.Vector2>());
        THREE.setUniform(_defaultMaterial, "col_a", new THREE.ShaderUniform<THREE.Vector4>());
        THREE.setUniform(_defaultMaterial, "col_b", new THREE.ShaderUniform<THREE.Vector4>());
        THREE.setUniform(_defaultMaterial, "pos", new THREE.ShaderUniform<THREE.Vector4>());

        _mesh = new THREE.Mesh(plane, _defaultMaterial)..rotation.x = PI;
        _scene.add(_mesh);
    }
}