
import 'dart:html';

import 'colour.dart';

class ColourPicker {
    InputElement _input;
    Element _anchor;

    Element _button;
    Element _buttonSwatch;
    Element _overlay;
    
    Colour colour = new Colour();
    Colour previousColour;

    ColourPicker(InputElement this._input, {int width = 48, int height = 25, int colourInt = 0xDDDDDD, Colour colour}) {
        if (colour == null) {
            colour = new Colour.fromHex(colourInt);
        }
        createButton(colour, width, height);
        createElement();
        
        readColourFromInput();
    }

    void update() {
        this._buttonSwatch.style.backgroundColor = this.colour.toStyleString();
    }
    
    void open() {
        this.previousColour = new Colour.from(this.colour);

        this._overlay.style.display = "block";
        this.resizeOverlay();
        this.update();
    }

    void close() {
        this._overlay.style.display = "none";
    }
    
    void readColourFromInput() { 
        this.colour = new Colour.fromStyleString(_input.value);
        this.update();
    }
    
    void writeColourToInput() { 
        this._input.value = this.colour.toStyleString(); 
        this._input.dispatchEvent(new Event("change"));
    }

    // element and getter stuff ###############################################################

    InputElement get input => _input;

    void createButton(Colour colour, int width, int height) {
        Element anchor = new DivElement()
            ..className = "colourPicker_anchor";

        Element b = new DivElement()
            ..className = "colourPicker_button"
            ..onClick.listen((MouseEvent e) {
                this.open();
                e.preventDefault();
                e.stopPropagation();
            });
        anchor.append(b);

        Element border1 = new DivElement()..className = "colourPicker_button_inner colourPicker_button_inner_1";
        b.append(border1);
        Element border2 = new DivElement()..className = "colourPicker_button_inner colourPicker_button_inner_2";
        b.append(border2);

        Element swatch = new DivElement()
            ..className = "colourPicker_swatch";
        b.append(swatch);

        Colour light = colour * 1.15;
        Colour dark = colour * 0.85;
        Colour bordercol = colour * 0.4;

        b.style
            ..width = "${width+2}px"
            ..height = "${height+2}px"
            ..borderColor = bordercol.toStyleString();
        border1.style
            ..width = "${width}px"
            ..height = "${height}px"
            ..backgroundColor = colour.toStyleString()
            ..borderLeftColor = light.toStyleString()
            ..borderTopColor = light.toStyleString()
            ..borderRightColor = dark.toStyleString()
            ..borderBottomColor = dark.toStyleString();
        border2.style
            ..width = "${width}px"
            ..height = "${height}px"
            ..backgroundColor = colour.toStyleString()
            ..borderLeftColor = dark.toStyleString()
            ..borderTopColor = dark.toStyleString()
            ..borderRightColor = light.toStyleString()
            ..borderBottomColor = light.toStyleString();
        swatch.style
            ..width = "${width-12}px"
            ..height = "${height-12}px";

        this._anchor = anchor;
        this._button = b;
        this._buttonSwatch = swatch;

        this._input.replaceWith(anchor);
    }

    void createElement() {
        Element overlay = new DivElement()
            ..className = "colourPicker_overlay"
            ..onClick.listen((MouseEvent e) {
                this.close();
                e.preventDefault();
                e.stopPropagation();
            });

        this._anchor.append(overlay);

        Element w = new DivElement()
            ..className = "colourPicker_window"
            ..onClick.listen((Event e) => e.stopPropagation())
            ..text = "Stuff goes in here";

        overlay.append(w);

        this._overlay = overlay;
        window.onResize.listen(resizeOverlay);
        resizeOverlay();
    }

    void resizeOverlay([Event e]) {
        int width = window.innerWidth;
        int height = window.innerHeight;

        this._overlay.style
            ..width = "${width}px"
            ..height = "${height}px";

        Element w = this._overlay.firstChild as Element;
        w.style
            ..left = "${(width - w.clientWidth)~/2}px"
            ..top = "${(height - w.clientHeight)~/2}px";
    }

    void destroy() {
        window.removeEventListener("resize", this.resizeOverlay);
        this._button.replaceWith(this._input);
    }
}