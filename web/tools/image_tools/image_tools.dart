import "dart:async";
import "dart:html";

import "../../scripts/SBURBSim.dart";
import '../../scripts/formats/Formats.dart';

ImageElement sourceImage;
ImageElement maskImage;

void main() {
    Formats.init();

    querySelector("#sdg_buttons")
        ..append(FileFormat.loadButton(Formats.png, loadImage, caption: "Load Image"))
        ..append(FileFormat.loadButton(Formats.png, loadMask, caption: "Load Mask"));

    querySelector("#sdg_render")..addEventListener("click", render);

    Random rand = new Random();
    querySelector("#sdg_setseed")..addEventListener("click", (Event e){
        (querySelector("#sdg_seed") as NumberInputElement).valueAsNumber = rand.nextInt();
    });

}

void loadImage(ImageElement image, String filename) {
    sourceImage = image;
    querySelector("#sdg_source")..setInnerHtml("")..append(image);
}

void loadMask(ImageElement image, String filename) {
    maskImage = image;
    querySelector("#sdg_mask")..setInnerHtml("")..append(image);
}

Future<Null> render([Event e]) async {
    if (sourceImage == null) { return; }

    bool backgroundOnly = (querySelector("#sdg_background") as CheckboxInputElement).checked;
    int scale = (querySelector("#sdg_scale") as NumberInputElement).valueAsNumber.toInt();
    double strength = (querySelector("#sdg_strength") as RangeInputElement).valueAsNumber.toDouble().clamp(0.0, 1.0);

    int ox = (querySelector("#sdg_x") as NumberInputElement).valueAsNumber.toInt();
    int oy = (querySelector("#sdg_y") as NumberInputElement).valueAsNumber.toInt();

    int seed = (querySelector("#sdg_seed") as NumberInputElement).valueAsNumber.toInt();

    int w = sourceImage.width;
    int h = sourceImage.height;

    Element container = querySelector("#sdg_container");

    RenderJob job = await RenderJob.create(w, h);
    
    container..setInnerHtml("")..append(job.div);

    job.addPass(new GroupPass()
        ..addPass(new RenderJobPassImage(new Asset<ImageElement>.direct(sourceImage)))
        ..addEffect(new RenderEffectStardustGlitch(seed: seed, strength: strength, scale:scale, mask:new Asset<ImageElement>.direct(maskImage), backgroundOnly: backgroundOnly, ox: ox, oy: oy))
    );
    
    Renderer.render(job);
}