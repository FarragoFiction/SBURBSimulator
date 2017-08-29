import '../../scripts/Rendering/sbahj.dart';
import 'dart:html';

import '../../scripts/Rendering/wordgif.dart';
import '../../scripts/includes/colour.dart';
import '../../scripts/includes/colour_picker.dart';



void main() {
    setupWordgif();
    setupShittyWordArt();
}

void setupWordgif() {
    TextInputElement text = querySelector("#wordgif_text");
    NumberInputElement size = querySelector("#wordgif_size");
    NumberInputElement ox = querySelector("#wordgif_x");
    NumberInputElement oy = querySelector("#wordgif_y");
    NumberInputElement depth = querySelector("#wordgif_depth");

    Element list = querySelector("#wordgif_list");

    ButtonElement addFrame = querySelector("#wordgif_add");
    ButtonElement generate = querySelector("#wordgif_generate");

    addFrame.onClick.listen((Event e){
        list.append(addFrameElement());
    });

    Colour col = new Colour(255,0,0);
    list.append(addFrameElement(col.toStyleString(), (col * 0.5).toStyleString()));
    list.append(addFrameElement((col * 0.9).toStyleString(), (col * 0.4).toStyleString()));

    Element container = querySelector("#wordgif");

    generate.onClick.listen((Event e) {
        if (text.value == null || text.value.isEmpty) { return; }

        container.setInnerHtml("");

        List<Colour> foreground = <Colour>[];
        List<Colour> background = <Colour>[];

        for (Element entry in list.children) {
            List<InputElement> inputs = entry.querySelectorAll("input[type=color]");

            foreground.add(new Colour.fromStyleString(inputs[0].value));
            background.add(new Colour.fromStyleString(inputs[1].value));
        }

        container.append(WordGif.dropText(text.value, size.valueAsNumber, foreground, background, ox.valueAsNumber, oy.valueAsNumber, depth.valueAsNumber));
    });
}

Element addFrameElement([String col1 = "#FF0000", String col2 = "#800000"]) {
    Element ele = new DivElement();

    InputElement fore = new InputElement(type:"color")..value=col1;
    InputElement back = new InputElement(type:"color")..value=col2;

    ele.append(fore);
    ele.append(back);

    ColourPicker.create(fore);
    ColourPicker.create(back);

    ele.append(new SpanElement()..text="[-]"..onClick.listen((Event e) {
        ele.remove();
    }));

    return ele;
}

void setupShittyWordArt() {
    TextInputElement text = querySelector("#shitty_text");
    NumberInputElement size = querySelector("#shitty_size");
    SelectElement grad = querySelector("#shitty_gradient");

    ButtonElement generate = querySelector("#shitty_generate");

    Element container = querySelector("#shitty");

    generate.onClick.listen((Event e) {
        if(text.value == null || text.value.isEmpty) { return; }

        container.setInnerHtml("");
        container.append(SBAHJ.sbahjText(text.value, size.valueAsNumber, getGradientFromValue(grad.value)));
    });
}

Gradient getGradientFromValue(String val) {
    if (val == "horizon") {
        return SBAHJGradients.horizon;
    } else if (val == "rainbow") {
        return SBAHJGradients.rainbow;
    } else if (val == "fire") {
        return SBAHJGradients.fire;
    }
    return null;
}