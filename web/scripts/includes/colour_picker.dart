import 'dart:async';
import 'dart:html';

import 'colour.dart';

class ColourPicker {
    static Set<ColourPicker> _pickers = new Set<ColourPicker>();

    InputElement _input;
    Element _anchor;

    Element _button;
    Element _buttonSwatch;
    Element _overlay;
    Element _window;
    
    Colour colour = new Colour();
    Colour previousColour;

    ColourPicker(InputElement this._input, {int width = 48, int height = 25, int colourInt = 0xDDDDDD, Colour colour}) {
        if (colour == null) {
            colour = new Colour.fromHex(colourInt);
        }
        createButton(colour, width, height);
        createElement();
        
        readColourFromInput();

        _pickers.add(this);

        ColourPickerMouseHandler.init();
    }

    void update() {
        print("update");

        this._buttonSwatch.style.backgroundColor = this.colour.toStyleString();
    }
    
    void open() {
        this.previousColour = new Colour.from(this.colour);

        this.readColourFromInput();
        this.update();

        this._overlay.style.display = "block";
        this.resizeOverlay();

        for (ColourPicker p in _pickers) {
            if (p!=this) {
                p.close();
            }
        }
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
            ..className = "colourPicker_overlay";

        this._anchor.append(overlay);

        Element overlay_shade = new DivElement()
            ..className = "colourPicker_overlay_2"
            ..onClick.listen((MouseEvent e) {
                this.close();
                e.preventDefault();
                e.stopPropagation();
            });

        overlay.append(overlay_shade);

        Element w = new DivElement()
            ..className = "colourPicker_window"
            ..onClick.listen((Event e) => e.stopPropagation())
            ..text = "Stuff goes in here";

        overlay.append(w);
        this._window = w;

        new FancySlider(0.0, 100.0, 250, 15, false)..appendTo(w)..onChange.listen((Event e) => this.update());

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

        this._window.style
            ..left = "${(width - this._window.clientWidth)~/2}px"
            ..top = "${(height - this._window.clientHeight)~/2}px";
    }

    void destroy() {
        window.removeEventListener("resize", this.resizeOverlay);
        this._button.replaceWith(this._input);
        _pickers.remove(this);
    }
}

typedef Colour FancySliderFill(double fraction);

class FancySlider {
    static Set<FancySlider> _sliders = new Set<FancySlider>();

    Element bar;
    Element slider;
    CanvasElement background;

    int width;
    int height;

    double minVal;
    double maxVal;
    double value;

    bool vertical;
    bool dragging = false;

    StreamController<Event> _streamController;
    Stream<Event> onChange;

    FancySlider(double this.minVal, double this.maxVal, int this.width, int this.height, bool this.vertical) {
        this._streamController = new StreamController<Event>();
        this.onChange = this._streamController.stream;
        this.value = minVal;

        this.bar = new DivElement()
            ..className = "fancySlider_bar"
            ..style.width = "${width}px"
            ..style.height = "${height}px"
            ..onMouseDown.listen(this._mouseDown);

        this.background = new CanvasElement(width:width, height:height)
            ..className = "fancySlider_background";

        this.slider = new DivElement()
            ..className = "fancySlider_slider_${this.vertical?"vertical":"horizontal"}";

        this.bar.append(this.background);
        this.bar.append(this.slider);
        this.update();

        _sliders.add(this);

        ColourPickerMouseHandler.init();
    }

    void update() {
        double percent = (this.value - this.minVal) / (this.maxVal - this.minVal);

        if (this.vertical) {
            int pos = (this.height * percent).floor();
            this.slider.style.top = "${pos}px";
        } else {
            int pos = (this.width * percent).floor();
            this.slider.style.left = "${pos}px";
        }

        this._streamController.add(new CustomEvent("update", detail:this));
    }

    void _mouseDown(MouseEvent e) {
        this.dragging = true;

        this.setFromMousePos(e);
    }

    void _mouseUp(MouseEvent e) {
        this.dragging = false;
    }

    void _mouseMove(MouseEvent e) {
        if (!this.dragging) { return; }

        this.setFromMousePos(e);
    }

    void setFromMousePos(MouseEvent e) {
        int relx = e.client.x - this.bar.documentOffset.x;
        int rely = e.client.y - this.bar.documentOffset.y;

        double percent;
        if (this.vertical) {
            percent = (rely / this.height).clamp(0.0, 1.0);
        } else {
            percent = (relx / this.width).clamp(0.0, 1.0);
        }

        this.value = percent * (this.maxVal - this.minVal) + this.minVal;

        this.update();
    }

    void drawBackground(FancySliderFill filler) {

    }

    void appendTo(Node parent) {
        parent.append(this.bar);
    }

    void destroy() {
        this.bar.remove();
        _sliders.remove(this);
    }
}

class ColourPickerMouseHandler {
    static bool _registered = false;

    static void init() {
        if (_registered) {return;}

        _registered = true;

        window.onMouseUp.listen((MouseEvent e) {
            for (ColourPicker p in ColourPicker._pickers) {

            }

            for (FancySlider s in FancySlider._sliders) {
                s._mouseUp(e);
            }
        });

        window.onMouseMove.listen((MouseEvent e) {
            for (ColourPicker p in ColourPicker._pickers) {

            }

            for (FancySlider s in FancySlider._sliders) {
                s._mouseMove(e);
            }
        });
    }
}