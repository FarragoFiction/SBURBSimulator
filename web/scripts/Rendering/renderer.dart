import "dart:async";
import "dart:html";

import "../SBURBSim.dart";
import "3d/three.dart" as THREE;

class Renderer {
    static bool _loadedThree = false;
    static Future<bool> loadThree() async {
        if (_loadedThree) { return true; }
        await Loader.loadJavaScript("scripts/Rendering/3d/three.min.js");
        return true;
    }

    static THREE.WebGLRenderer _renderer = new THREE.WebGLRenderer();
    static THREE.OrthographicCamera _camera = new THREE.OrthographicCamera.flat(100, 100);

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

class RenderJob {
    DivElement div;
    THREE.Scene scene;
    int width;
    int height;

    THREE.Camera camera = null;

    RenderJob(THREE.Scene this.scene, int this.width, int this.height, {THREE.Camera camera}) {
        this.div = new DivElement()..className="renderJobPlaceholder";
        div.style..width="${width}px"..height="${height}px";
    }

    void setImage(Element image) {
        this.div.className="";
        this.div.append(image);
    }
}