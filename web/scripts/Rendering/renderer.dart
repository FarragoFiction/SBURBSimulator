import "dart:async";
import "dart:html";
import "dart:math";

import "../SBURBSim.dart";
import "3d/three.dart" as THREE;

export "pass/effect.dart";
export "pass/group.dart";
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

    static THREE.WebGLRenderer _renderer = new THREE.WebGLRenderer(new THREE.WebGLRendererOptions(alpha:true, antialias: false))..autoClear = false..setClearColor(0xFF0000, 0x00);

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

    static void _setSize(int width, int height) {
        if (width != _renderer.domElement.width || height != _renderer.domElement.height) {
            _disposeBuffers();
        }
        _renderer.setSize(width, height);
    }

    static Future<Null> _draw(RenderJob job) async {
        _setSize(job.width, job.height);

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

    static const int MAX_BUFFERS = 32;
    static List<THREE.WebGLRenderTarget> _buffers = new List<THREE.WebGLRenderTarget>(MAX_BUFFERS);
    static int _bufferStackDepth = 0;
    static THREE.WebGLRenderTarget _getBufferFromStack(int position, int width, int height) {
        if (position >= MAX_BUFFERS) {
            throw "Buffer depth limite exceeded - honestly if you got this deep something is probably wrong.";
        }
        if (_buffers[position] == null) {
            _buffers[position] = new THREE.WebGLRenderTarget(width, height);
        } else {
            _buffers[position].setSize(width, height);
        }
        return _buffers[position];
    }

    static THREE.WebGLRenderTarget pushBufferStack(int width, int height) {
        THREE.WebGLRenderTarget buffer = _getBufferFromStack(_bufferStackDepth, width, height);
        _bufferStackDepth++;
        return buffer;
    }

    static void popBufferStack() {
        _bufferStackDepth--;
    }

    static void _disposeBuffers() {
        for (int i=0; i<_buffers.length; i++) {
            THREE.WebGLRenderTarget buffer = _buffers[i];
            if (buffer == null) { continue; }
            buffer.dispose();
            _buffers[i] = null;
        }
        _bufferStackDepth = 0;
    }
}

abstract class RendererDefaults {
    static THREE.AmbientLight defaultAmbient = new THREE.AmbientLight(0xFFFFFF, 2.0);
}

class RenderJob extends Object with RenderPassReceiver {
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

    @override
    void addPass(RenderJobPass pass) {
        this._passes.add(pass);
    }
}

abstract class RenderJobPass {
    Future<Null> draw(RenderJob job, [THREE.WebGLRenderTarget target]);
}

abstract class RenderPassReceiver {
    void addPass(RenderJobPass pass);

    void addImagePass(String path, [int x=0, int y=0, THREE.ShaderMaterial materialOverride]) {
        this.addPass(new RenderJobPassImage(path, x,y, materialOverride));
    }

    void addSpritePass(String path, Iterable<Palette> palettes, [int x=0, int y=0, THREE.ShaderMaterial materialOverride]) {
        this.addPass(new RenderJobPassSprite(path, palettes, x, y, materialOverride));
    }

    GroupPass addGroupPass() {
        GroupPass group = new GroupPass();
        this.addPass(group);
        return group;
    }
}



