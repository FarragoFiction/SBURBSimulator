import "dart:async";
import "dart:html";
import "dart:math";

import "../SBURBSim.dart";
import "3d/texturehelper.dart";
import "3d/three.dart" as THREE;

class Renderer {
    static bool _loadedThree = false;
    static Future<bool> loadThree() async {
        if (_loadedThree) { return true; }
        await Loader.loadJavaScript("scripts/Rendering/3d/three.min.js");
        return true;
    }

    static THREE.WebGLRenderer _renderer = new THREE.WebGLRenderer(new THREE.WebGLRendererOptions(alpha:true, antialias: false));
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100)..position.z = 800;

    static List<RenderJob> _pending = <RenderJob>[];
    static bool _processing = false;

    static void render(RenderJob job) {
        _pending.add(job);
        _startProcessing();
    }

    static void _startProcessing() {
        if (_processing) { return; }
        _processing = true;

        _renderLoop();
    }

    static void _renderLoop([num dt]) {
        if (_pending.isEmpty) {
            _processing = false;
            return;
        }

        RenderJob job = _pending.removeAt(0);

        _draw(job);

        window.requestAnimationFrame(_renderLoop);
    }

    static void _draw(RenderJob job) {
        _renderer.setSize(job.width, job.height);

        if (job.camera != null) {
            _renderer.render(job.scene, job.camera);
        } else {
            _camera..right = job.width..bottom = job.height..updateProjectionMatrix();
            _renderer.render(job.scene, _camera);
        }

        CanvasElement output = new CanvasElement(width: job.width, height: job.height);
        output.context2D.drawImage(_renderer.domElement, 0, 0);

        job.setImage(output);
    }
}

abstract class RendererDefaults {
    static THREE.AmbientLight defaultAmbient = new THREE.AmbientLight(0xFFFFFF, 2.0);
}

class RenderJob {
    DivElement div;
    THREE.Scene scene = new THREE.Scene();
    int width;
    int height;

    double _imagedepth = 0.0;

    THREE.Camera camera = null;

    RenderJob._(int this.width, int this.height) {
        this.div = new DivElement()..className="renderJobPlaceholder";
        div.style..width="${width}px"..height="${height}px";
    }

    static Future<RenderJob> create(int width, int height, {bool defaultLight = true}) async {
        await Renderer.loadThree();
        RenderJob job = new RenderJob._(width, height);

        if (defaultLight) {
            job.add(RendererDefaults.defaultAmbient);
        }

        return job;
    }

    void setImage(Element image) {
        this.div.className="";
        this.div.append(image);
    }

    Element dispatch() {
        Renderer.render(this);
        return this.div;
    }

    void add(THREE.Object3D object3d) {
        this.scene.add(object3d);
    }

    Future<THREE.Mesh> addImage(String path, int x, int y) async {
        ImageElement img = await TextureHelper.expandToNextPower(await Loader.getResource(path));
        return _addImage(img, x, y, img.width, img.height);
    }

    Future<THREE.Mesh> _addImage(CanvasImageSource img, int x, int y, int w, int h) async {
        THREE.Mesh image = new THREE.Mesh(new THREE.PlaneGeometry(w, h, 1, 1), new THREE.MeshBasicMaterial.parameters(map: new THREE.Texture(img)..magFilter=THREE.NearestFilter..minFilter=THREE.NearestFilter..needsUpdate = true)..transparent = true);
        image.position..x = x + w/2..y = y + h/2..z = _imagedepth;
        _imagedepth += 0.01;
        image.rotation.x = PI;
        this.add(image);
        return image;
    }
}