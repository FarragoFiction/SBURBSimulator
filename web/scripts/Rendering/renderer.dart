import "dart:async";
import "dart:html";
import "dart:math";

import "../SBURBSim.dart";
import "3d/three.dart" as THREE;

export "pass/image.dart";
export "pass/sprite.dart";

class Renderer {
    static bool _loadedThree = false;
    static Future<bool> loadThree() async {
        if (_loadedThree) { return true; }
        await Loader.loadJavaScript("scripts/Rendering/3d/three.min.js");
        return true;
    }

    static Map<CanvasImageSource, THREE.Texture> _textureCache = <CanvasImageSource, THREE.Texture>{};

    static THREE.WebGLRenderer _renderer = new THREE.WebGLRenderer(new THREE.WebGLRendererOptions(alpha:true, antialias: false))..autoClear = false;

    static List<RenderJob> _pending = <RenderJob>[];
    static bool _processing = false;

    static THREE.WebGLRenderer get webgl => _renderer;

    static void render(RenderJob job) {
        _pending.add(job);
        _startProcessing();
    }

    static void _startProcessing() {
        if (_processing) { return; }
        _processing = true;

        // specifically using the future constructor here to let the event loop take a breather
        // doing so means it has to wait until the next event loop to do stuff, just calling
        // the method would have it start immediately, and we don't want that here.
        new Future<Null>(_renderLoop);
    }

    static Future<Null> _renderLoop([num dt]) async {
        if (_pending.isEmpty) {
            _processing = false;
            return;
        }

        RenderJob job = _pending.removeAt(0);

        await _draw(job);

        window.requestAnimationFrame(_renderLoop);
    }

    static Future<Null> _draw(RenderJob job) async {
        _renderer.setSize(job.width, job.height);

        for (RenderJobPass pass in job._passes) {
            await pass.draw(job);
        }

        CanvasElement output = new CanvasElement(width: job.width, height: job.height);
        output.context2D.drawImage(_renderer.domElement, 0, 0);

        job.setImage(output);
    }

    static THREE.Texture getCachedTexture(CanvasImageSource image) {
        if (_textureCache.containsKey(image)) { return _textureCache[image]; }

        THREE.Texture texture = new THREE.Texture(image);
        _textureCache[image] = texture;

        return texture;
    }

    static THREE.Texture getCachedTextureNearest(CanvasImageSource image) {
        return getCachedTexture(image)
            ..minFilter = THREE.NearestFilter
            ..magFilter = THREE.NearestFilter
            ..needsUpdate = true;
    }
}

abstract class RendererDefaults {
    static THREE.AmbientLight defaultAmbient = new THREE.AmbientLight(0xFFFFFF, 2.0);
}

class RenderJob {
    DivElement div;

    List<RenderJobPass> _passes = <RenderJobPass>[];

    int width;
    int height;

    RenderJob._(int this.width, int this.height) {
        int bgsize = min(300,(min(width, height) * 0.75).round());
        this.div = new DivElement()
            ..className="renderJobPlaceholder"
            ..style.backgroundSize="${bgsize}px";
        div.style..width="${width}px"..height="${height}px";
    }

    static Future<RenderJob> create(int width, int height, {bool defaultLight = true}) async {
        await Renderer.loadThree();
        RenderJob job = new RenderJob._(width, height);

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

    void add(RenderJobPass pass) {
        this._passes.add(pass);
    }

    void addImage(String path, [int x, int y, THREE.ShaderMaterial materialOverride]) {
        this.add(new RenderJobPassImage(path, x,y, materialOverride));
    }

    void addSprite(String path, Iterable<Palette> palettes, [int x, int y, THREE.ShaderMaterial materialOverride]) {
        this.add(new RenderJobPassSprite(path, palettes, x, y, materialOverride));
    }
}

abstract class RenderJobPass {
    Future<Null> draw(RenderJob job);
}



