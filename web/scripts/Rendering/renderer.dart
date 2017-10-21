import "dart:async";
import "dart:html";
import "dart:math";
import "dart:typed_data";

import "../SBURBSim.dart";
import "3d/texturehelper.dart";
import "3d/three.dart" as THREE;
import "sprite/sprite.dart";

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
    Future<Null> draw(RenderJob job) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        ImageElement img = await Loader.getResource(imagePath);
        THREE.Texture texture = Renderer.getCachedTextureNearest(img);

        THREE.ShaderMaterial material = this.materialOverride != null ? this.materialOverride : _defaultMaterial;

        THREE.getUniform(material, "image").value = texture;
        THREE.getUniform(material, "size").value = new THREE.Vector2(img.width, img.height);

        _mesh.position..x = x + img.width * 0.5..y = y + img.height * 0.5;

        Renderer._renderer.render(_scene, _camera);
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
    Future<Null> draw(RenderJob job) async {
        await _initScene();
        _camera..bottom = job.height..right = job.width..updateProjectionMatrix();

        PSprite sprite = await Loader.getResource(spritePath);
        _processPalette(sprite, palettes);
        THREE.Texture texture = sprite.texture;

        THREE.ShaderMaterial material = this.materialOverride != null ? this.materialOverride : _defaultMaterial;

        THREE.getUniform(material, "image").value = texture;
        THREE.getUniform(material, "size").value = new THREE.Vector2(sprite.width, sprite.height);

        _mesh.position..x = x + sprite.width * 0.5..y = y + sprite.height * 0.5;

        Renderer._renderer.render(_scene, _camera);
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