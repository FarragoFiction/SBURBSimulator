import '../../loader/loader.dart';
import "dart:async";
import "dart:math";

import "../3d/three.dart" as THREE;
import "../renderer.dart";
import "effect.dart";

class GroupPass extends RenderJobPass with RenderPassReceiver {
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;
    static THREE.Scene _scene;
    static THREE.Mesh _mesh;
    static THREE.ShaderMaterial _defaultMaterial;

    List<RenderJobPass> subPasses = <RenderJobPass>[];
    List<RenderEffect> effects = <RenderEffect>[];

    @override
    void addPass(RenderJobPass pass) {
        subPasses.add(pass);
    }

    void addEffect(RenderEffect effect) {
        effects.add(effect);
    }

    @override
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        THREE.WebGLRenderTarget buffer = Renderer.pushBufferStack(job.width, job.height);
        Renderer.webgl.clearTarget(buffer, true, true, true);

        for (RenderJobPass pass in subPasses) {
            await pass.draw(job, buffer);
        }

        THREE.WebGLRenderTarget source = buffer;
        THREE.WebGLRenderTarget dest = null;

        THREE.Material material = _defaultMaterial;
        _mesh.position..x = job.width * 0.5..y = job.height * 0.5;
        //_mesh.material = material;

        if (!effects.isEmpty) {
            // get another buffer so we can draw the effects and swap each time
            dest = Renderer.pushBufferStack(job.width, job.height);

            for (RenderEffect effect in effects) {
                THREE.ShaderMaterial effectmat = new THREE.ShaderMaterial(new THREE.ShaderMaterialParameters(
                    vertexShader: await Loader.getResource(effect.vertexShader),
                    fragmentShader: await Loader.getResource(effect.fragmentShader))
                )..transparent = true;

                THREE.setUniform(effectmat, "image", new THREE.ShaderUniform<THREE.Texture>()..value = source.texture);
                THREE.setUniform(effectmat, "size", new THREE.ShaderUniform<THREE.Vector2>()..value = new THREE.Vector2(job.width, job.height));

                for (String key in effect.uniforms.keys) {
                    THREE.setUniform(effectmat, key, effect.uniforms[key]);
                }

                _mesh.material = effectmat;
                Renderer.webgl.clearTarget(dest, true, true, true);
                Renderer.webgl.render(_scene, _camera, dest);

                THREE.WebGLRenderTarget swap = dest;
                dest = source;
                source = swap;
            }

            Renderer.popBufferStack();
        } else {
            // no effects, draw to the target buffer
            dest = source;
        }

        //_mesh.material = _defaultMaterial;
        THREE.getUniform(material, "image").value = dest.texture;
        THREE.getUniform(material, "size").value = new THREE.Vector2(job.width, job.height);

        Renderer.webgl.render(_scene, _camera);

        Renderer.popBufferStack();
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