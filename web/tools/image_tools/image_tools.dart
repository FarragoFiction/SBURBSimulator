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
}

void loadImage(ImageElement image) {
    sourceImage = image;
    querySelector("#sdg_source")..setInnerHtml("")..append(image);
}

void loadMask(ImageElement image) {
    maskImage = image;
    querySelector("#sdg_mask")..setInnerHtml("")..append(image);
}

Future<Null> render([Event e]) async {
    if (sourceImage == null) { return; }

    bool backgroundOnly = (querySelector("#sdg_background") as CheckboxInputElement).checked;
    int scale = (querySelector("#sdg_scale") as NumberInputElement).valueAsNumber.toInt();
    double strength = (querySelector("#sdg_strength") as RangeInputElement).valueAsNumber.toDouble().clamp(0.0, 1.0);

    int w = sourceImage.width;
    int h = sourceImage.height;

    Element container = querySelector("#sdg_container");

    RenderJob job = await RenderJob.create(w, h);
    
    container..setInnerHtml("")..append(job.div);

    job.addPass(new GroupPass()
        ..addPass(new RenderJobPassImageDirect(sourceImage))
        ..addEffect(new RenderEffectStardustGlitch(strength: strength)
            ..uniforms["mask"].value = maskImage == null ? null : (Renderer.getCachedTexture(maskImage)..needsUpdate=true)
        )
    );
    
    Renderer.render(job);
}