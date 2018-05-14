import '../../scripts/formats/Formats.dart';
import 'dart:async';
import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";
import "dart:web_audio";

import "../../scripts/Rendering/threed/three.dart" as THREE;
import "../../scripts/Rendering/text/opentype.dart" as OT;
import "../../scripts/SBURBSim.dart";
import "../../scripts/includes/bytebuilder.dart";
import "../../scripts/includes/colour.dart";
import "../../scripts/includes/improvedbytebuilder.dart";
import '../../scripts/includes/png.dart';


void main() {
    Element stuff = querySelector("#stuff");

    /*new Timer(new Duration(seconds: 1),()
    {
        //print("event stuff:");
        //print(querySelector("#testpicker")); //.onChange);

        ColourPicker.create(querySelector("#testpicker"));//..onChange.listen((Event e) => //print((e.target as InputElement).value)));
    });*/

    //testDrawing();
    
    //testScaling(stuff);


    /*Random rand = new Random();

    List<int> list = new List<int>.generate(16, (int i) => rand.nextInt(100));

    print(list);

    ImprovedByteBuilder builder = new ImprovedByteBuilder();

    for (int i in list) {
        builder.appendExpGolomb(i);
    }

    ByteBuffer buffer = builder.toBuffer();

    ImprovedByteBuilder.prettyPrintByteBuffer(buffer);

    ImprovedByteReader reader = new ImprovedByteReader(buffer);

    List<int> outlist = new List<int>.generate(list.length, (int i) => reader.readExpGolomb());

    print(outlist);*/

    //testPNG();

    //Loader.getResource("/test.png");
    
    //testAudio();

    //testText();

    testLoaderIssues();
}

Future<Null> testLoaderIssues() async {
    Loader.init();
    await Loader.loadManifest();

    print("start");
    Loader.getResource("images/Hair/hair1.png");
    Loader.getResource("images/Hair/hair2.png");
    Loader.getResource("images/Hair/hair3.png");
    print("done");
}

Future<Null> testText() async {
    TextEngine text = new TextEngine();
    await text.loadList("headcanon");

    Element e = querySelector("#stuff");

    for (int i=0; i<20; i++) {
        e.append(new ParagraphElement()..text = text.phrase("JRheadcanon"));
    }

    //print(text.wordLists);
}

Future<Null> testAudio() async {
    Audio.masterVolume.value = 0.15;
    //ImageElement imageElementTest = await Loader.getResource("images/ab.png");
    //print(imageElementTest.src);
    //querySelector("#stuff").append(imageElementTest);
    //AudioElement soundElement = await  Loader.getResource("audio/spiderblood.ogg");
    AudioElement soundElement = await Audio.loadStreamed("audio/spiderblood");

    AudioSourceNode sound = Audio.node(soundElement);

    MuffleEffect muffle = new MuffleEffect(1.0);

    sound.connectNode(muffle.input);
    muffle.output.connectNode(Audio.output);

    soundElement.loop = true;
    soundElement.play();

    querySelector("#stuff").append(Audio.slider(muffle));
}
 
Future<Null> testPNG() async {
    Formats.init();

    int size = 256;
    CanvasElement canvas = new CanvasElement(width:size, height:size);
    CanvasRenderingContext2D ctx = canvas.context2D;
    Random rand = new Random();

    for (int i=0; i<200; i++) {
        ctx.fillStyle = new Colour(rand.nextInt(256),rand.nextInt(256),rand.nextInt(256),80).toStyleString(true,true);
        int x = rand.nextInt(size);
        int y = rand.nextInt(size);
        int w = rand.nextInt(size - x);
        int h = rand.nextInt(size - y);
        ctx.fillRect(x,y,w,h);
    }

    querySelector("#stuff").append(canvas);

    PayloadPng png = new PayloadPng(canvas);

    String blob = await Formats.payloadPng.objectToDataURI(png);

    querySelector("#stuff").append(new ImageElement(src: blob));

    //print("");
    //print("Output:");
    //ByteBuilder.prettyPrintByteBuffer(data);
}

Future<bool> testDrawing() async {
    Aspects.init();
    Element stuff = querySelector("#stuff");

    // preload to be fair
    await Loader.getResource("images/guide_bot.png");
    await Renderer.loadThree();

    int startx = -120;
    int starty = -40;
    int dim = 5;
    int dimx = 5;
    int dimy = 1;
    int space = 120;

    /*{
        DateTime then = new DateTime.now();

        CanvasElement testcanvas = new CanvasElement(width: 640, height: 480);
        CanvasRenderingContext2D ctx = testcanvas.context2D;

        for (int x = 0; x < dim; x++) {
            for (int y = 0; y < dim; y++) {
                ctx.drawImage(await Loader.getResource("images/guide_bot.png"), space * x, space * y);
            }
        }

        stuff.append(testcanvas);

        DateTime now = new DateTime.now();
        int mis = now.microsecondsSinceEpoch - then.microsecondsSinceEpoch;

        print("2d: ${mis / 1000}ms");
    }*/

    {
        //RenderJob job = await RenderJob.create(400, 300);

        /*job.addPass(new RenderJobPassGradient(0,0,400,300, 0,0,400,300)..smoothing = 0.5..useGamma = 1.0
            ..addStop(0.0, new Colour.fromHex(0xFF0000))
            ..addStop(0.5, new Colour.fromHex(0x00FF00))
            ..addStop(1.0, new Colour.fromHex(0x0000FF))
        );*/
        /*job.addPass(new RenderJobPassGradient(0,0, 400,300, 200,150,200,300)
            ..gradient_type = RJPGradientType.ANGLE
            ..repeat = 4.0
            ..addStop(0.0, new Colour.fromHex(0x2989CC))
            ..addStop(0.5, new Colour.fromHex(0xFFFFFF))
            ..addStop(0.52,new Colour.fromHex(0x906A00))
            ..addStop(0.64,new Colour.fromHex(0xD99F00))
            ..addStop(1.0, new Colour.fromHex(0xFFFFFF))
        );*/

        /*job.addPass(new RenderJobPassGradient(0,0,400,300, 200,150,200,300)
            ..gradient_type = RJPGradientType.ANGLE
            ..repeat = 24.0
            ..addStop(0.0, new Colour.fromHex(0x2989CC))
            ..addStop(0.5, new Colour.fromHex(0xFFFFFF))
            ..addStop(0.52,new Colour.fromHex(0x906A00))
            ..addStop(0.64,new Colour.fromHex(0xD99F00))
            ..addStop(1.0, new Colour.fromHex(0xFFFFFF))
        );*/

        /*job.addPass(new RenderJobPassGradient(0,0,400,300, 200,150,200,300)
            ..smoothing = 1.0
            ..gradient_type = RJPGradientType.RADIAL
            //..addStop(0.0, new Colour.fromHex(0xFF0000))
            //..addStop(0.3, new Colour.fromHex(0xFF000000, true))
            ..addStop(0.6, new Colour.fromHex(0xFFFFFF00, true))
            ..addStop(1.0, new Colour.fromHex(0xFFFFFF))
        );*/

        //job.addPass(new RenderJobPassGradient(0,0,400,300, new Colour.fromHex(0x00EE10), new Colour.fromHex(0xFF005F), new THREE.Vector2(0,0), new THREE.Vector2(400,300)));
        
        /*GroupPass group = job.addGroupPass()
            ..addEffect(new RenderEffect("shaders/image.vert", "shaders/sharpen.frag"))
            ..addEffect(new RenderEffect("shaders/image.vert", "shaders/sharpen.frag"))
            ..addEffect(new RenderEffect("shaders/image.vert", "shaders/fakejpeg.frag"))
            ..addEffect(new RenderEffect("shaders/image.vert", "shaders/sharpen.frag"));*/

        RenderJob job = await RenderJob.create(640,480);

        GroupPass group = job.addGroupPass()
            ..addEffect(new RenderEffectStardustGlitch(strength: 0.675)
                ..uniforms["mask"].value = (Renderer.getCachedTexture(await Loader.getResource("tools/aspect_palette/milestone_1000_5_mask.png"))..needsUpdate=true)
                );

        group
            ..addImagePass("tools/aspect_palette/milestone_1000_5.png");

        /*int hairid = 7;

        group
            ..addImagePass("images/Hair/hair_back$hairid.png")
            ..addImagePass("images/Bodies/Null.png")
            ..addImagePass("images/Light.png")
            ..addImagePass("images/Hair/hair$hairid.png");*/

        stuff.append(job.dispatch());
    }

    /*{
        Random rand = new Random();

        Palette skin = new Palette()
            ..add("skin", new Colour.fromHex(0xFFFFFF))
            ..add("skinline", new Colour.fromHex(0x000000));

        DateTime then = new DateTime.now();

        RenderJob job = await RenderJob.create(640, 480);

        for (int y = 0; y < dimy; y++) {
            for (int x = 0; x < dimx; x++) {
                GroupPass group = job.addGroupPass();
                group.addEffect(new RenderEffect("shaders/image.vert", "shaders/fadetest.frag"));
                int hairid = rand.nextInt(74)+1;

                group.addImagePass("images/Hair/hair_back$hairid.png", x * space + startx, y * space + starty);
                group.addSpritePass("images/Bodies/god4.psprite", <Palette>[skin, rand.pickFrom(Aspects.all).palette], x * space + startx, y * space + starty);
                group.addImagePass("images/Hair/hair$hairid.png", x * space + startx, y * space + starty);
            }
        }

        stuff.append(job.dispatch());

        DateTime now = new DateTime.now();
        int mis = now.microsecondsSinceEpoch - then.microsecondsSinceEpoch;

        print("3d: ${mis / 1000}ms");
    }*/

    /*{
        CanvasElement texttest = new CanvasElement(width:500, height:300);
        stuff.append(texttest);
        
        //OT.Font font = await Loader.getResource("Fonts/Strife.ttf");

        CanvasRenderingContext2D ctx = texttest.context2D;

        //font.draw(ctx, "Hello", 20, 50, 48);
        await OT.drawText("Fonts/Strife.ttf", ctx, "Hello", 20, 50, 48, fill: "red");
    }*/

    /*{
        CanvasElement canvas = new CanvasElement(width:500, height:500);
        THREE.WebGLRenderer renderer = new THREE.WebGLRenderer(new THREE.WebGLRendererOptions(canvas: canvas));
        THREE.Camera camera = new THREE.PerspectiveCamera(90, 1.0, 0.1, 500.0)
            ..position.z = 50
            ..lookAt(new THREE.Vector3.zero());

        THREE.Scene scene = new THREE.Scene();

        List<THREE.Shape> shapes = THREE.getShapesForText("gigglesnort", await Loader.getResource("Fonts/Alternian.ttf"), 7);
        //THREE.ShapeBufferGeometry geom = new THREE.ShapeBufferGeometry(shapes);
        THREE.ExtrudeGeometry geom = new THREE.ExtrudeGeometry(shapes, new THREE.ExtrudeGeometryOptions(amount: 8, bevelEnabled: false));
        //THREE.Material mat = new THREE.MeshBasicMaterial(new THREE.MeshBasicMaterialProperties(wireframe:true));
        THREE.Material mat = new THREE.MeshStandardMaterial();
        THREE.Mesh mesh = new THREE.Mesh(geom, mat);
        mesh..rotation.x = Math.PI;
        mesh..position.x = -50;

        scene.add(mesh);
        scene.add(new THREE.DirectionalLight()..position.z = 50..position.x = 20..position.y = 25..lookAt(new THREE.Vector3.zero()));
        scene.add(new THREE.AmbientLight(0xFFFFFF,0.2));

        renderer.render(scene, camera);

        stuff.append(canvas);
    }*/

    return true;
}

void checkLABRanges() {
    double min_l = double.INFINITY;
    double max_l = double.NEGATIVE_INFINITY;

    double min_a = double.INFINITY;
    double max_a = double.NEGATIVE_INFINITY;

    double min_b = double.INFINITY;
    double max_b = double.NEGATIVE_INFINITY;

    for (int r = 0; r<256; r++) {
        for (int g = 0; g<256; g++) {
            for (int b = 0; b<256; b++) {
                Colour col = new Colour(r,g,b);

                min_l = Math.min(min_l, col.lab_lightness_scaled);
                max_l = Math.max(max_l, col.lab_lightness_scaled);

                min_a = Math.min(min_a, col.lab_a_scaled);
                max_a = Math.max(max_a, col.lab_a_scaled);

                min_b = Math.min(min_b, col.lab_b_scaled);
                max_b = Math.max(max_b, col.lab_b_scaled);
            }
        }
    }

    //print("L: $min_l,$max_l, a: $min_a,$max_a, b: $min_b,$max_b");
}

CanvasElement makeGradientSwatch() {
    CanvasElement canvas = new CanvasElement(width: 200, height:200);
    CanvasRenderingContext2D ctx = canvas.context2D;

    Random rand = new Random();

    //double brightness = rand.nextDouble() * 0.4 + 0.5;
    //double sat = rand.nextDouble() * 0.2 + 0.5;

    //Colour col1 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);
    //Colour col2 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);

    //Colour col1 = new Colour.fromHex(0xFF0000);
    //Colour col2 = new Colour.fromHex(0x00FF00);

    double lightness = rand.nextDouble() * 0.4 + 0.3;
    double l1 = (rand.nextDouble() * 0.6 - 0.3 + lightness);
    l1 = 1-((1-l1)*(1-l1));
    double l2 = (rand.nextDouble() * 0.6 - 0.3 + lightness);
    l2 = 1-((1-l2)*(1-l2));

    Colour col1 = new Colour.labScaled(l1, rand.nextDouble(), rand.nextDouble());
    Colour col2 = new Colour.labScaled(l2, rand.nextDouble(), rand.nextDouble());

    int w = canvas.width;
    int h = canvas.height;

    ImageData data = ctx.getImageData(0,0,w,h);

    for (int x = 0; x<w; x++) {
        for (int y = 0; y<h; y++) {
            int index = ((w*y) +x) * 4;

            double frac = x / (w*2) + y / (h*2);

            Colour mix = col1.mix(col2, frac, true);

            data.data[index] = mix.red;
            data.data[index+1] = mix.green;
            data.data[index+2] = mix.blue;
            data.data[index+3] = 255;
        }
    }

    ctx.putImageData(data, 0, 0);

    return canvas;
}

void testScaling(Element parent) {
    parent.append(new DivElement()
        ..append(new NumberInputElement()..id="sourcewidth"..step="1"..valueAsNumber = 200..onChange.listen(updateScaling))
        ..append(new NumberInputElement()..id="sourceheight"..step="1"..valueAsNumber = 500..onChange.listen(updateScaling))
        ..append(new NumberInputElement()..id="destwidth"..step="1"..valueAsNumber = 400..onChange.listen(updateScaling))
        ..append(new NumberInputElement()..id="destheight"..step="1"..valueAsNumber = 300..onChange.listen(updateScaling))
    );

    parent.append(new CanvasElement()..id="sizecanvas");

    updateScaling();
}

void updateScaling([Event e]) {
    int sourcewidth = (querySelector("#sourcewidth") as NumberInputElement).valueAsNumber.toInt();
    int sourceheight = (querySelector("#sourceheight") as NumberInputElement).valueAsNumber.toInt();
    int destwidth = (querySelector("#destwidth") as NumberInputElement).valueAsNumber.toInt();
    int destheight = (querySelector("#destheight") as NumberInputElement).valueAsNumber.toInt();

    CanvasElement sizecanvas = querySelector("#sizecanvas");
    CanvasRenderingContext2D ctx = sizecanvas.context2D;

    sizecanvas..width=destwidth..height=destheight;

    double widthratio = destwidth / sourcewidth;
    double heightratio = destheight / sourceheight;
    double ratio = Math.min(widthratio, heightratio);

    double width = sourcewidth * ratio;
    double height = sourceheight * ratio;

    double left = (destwidth - width) * 0.5;
    double top = (destheight - height) * 0.5;

    ctx.fillStyle = "black";
    ctx.fillRect(0,0,destwidth,destheight);

    ctx.fillStyle = "red";
    ctx.fillRect(left, top, width, height);
}