import "dart:async";
import "dart:html";
import "dart:math";

import "../../loader/loader.dart";
import "../3d/three.dart" as THREE;
import "../renderer.dart";

class RenderJobPassImage extends RenderJobPass {
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;
    static THREE.Scene _scene;
    static THREE.Mesh _mesh;
    static THREE.ShaderMaterial _defaultMaterial;

    final String imagePath;
    final int x;
    final int y;
    THREE.ShaderMaterial materialOverride;

    RenderJobPassImage(String this.imagePath, [int this.x=0, int this.y=0, THREE.ShaderMaterial this.materialOverride]);

    @override
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        ImageElement img = await Loader.getResource(imagePath);
        THREE.Texture texture = Renderer.getCachedTextureNearest(img);

        THREE.ShaderMaterial material = this.materialOverride != null ? this.materialOverride : _defaultMaterial;

        THREE.getUniform(material, "image").value = texture;
        THREE.getUniform(material, "size").value = new THREE.Vector2(img.width, img.height);

        _mesh.material = material;
        _mesh.position..x = x + img.width * 0.5..y = y + img.height * 0.5;

        Renderer.webgl.render(_scene, _camera, target);
    }

    Future<Null> _initScene() async {
        if (_scene != null) { return; }

        _scene = new THREE.Scene();

        THREE.PlaneBufferGeometry plane = new THREE.PlaneBufferGeometry(1,1,1,1);

        _defaultMaterial = await THREE.makeShaderMaterial("shaders/image.vert", "shaders/image.frag")..transparent = true;
        THREE.setUniform(_defaultMaterial, "image", new THREE.ShaderUniform<THREE.Texture>());
        THREE.setUniform(_defaultMaterial, "size", new THREE.ShaderUniform<THREE.Vector2>());

        _mesh = new THREE.Mesh(plane, _defaultMaterial)..rotation.x = PI;
        _scene.add(_mesh);
    }
}