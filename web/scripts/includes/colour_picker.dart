import 'dart:async';
import 'dart:html';
import 'dart:html_common';
import 'dart:math' as Math;

import 'colour.dart';
import 'logger.dart';

class ColourPicker {
    static Logger logger = Logger.get("ColourPicker", false);

    static Set<ColourPicker> _pickers = new Set<ColourPicker>();

    bool isOpen = false;

    InputElement _input;
    Element _anchor;

    Element _button;
    Element _buttonSwatch;
    Element _overlay;
    Element _window;

    CanvasElement _mainPicker;
    FancySlider _mainSlider;

    FancySlider _rgb_slider_red;
    FancySlider _rgb_slider_green;
    FancySlider _rgb_slider_blue;
    NumberInputElement _rgb_input_red;
    NumberInputElement _rgb_input_green;
    NumberInputElement _rgb_input_blue;

    FancySlider _hsv_slider_hue;
    FancySlider _hsv_slider_sat;
    FancySlider _hsv_slider_val;
    NumberInputElement _hsv_input_hue;
    NumberInputElement _hsv_input_sat;
    NumberInputElement _hsv_input_val;

    NumberInputElement _lab_input_l;
    NumberInputElement _lab_input_a;
    NumberInputElement _lab_input_b;

    TextInputElement _hex_input;

    Element _previewOld;
    Element _previewNew;

    List<RadioButtonInputElement> modeButtons = <RadioButtonInputElement>[];

    static int pickMode = 3; // 0-5 = r,g,b, h,s,v - shared between all pickers
    bool picking = false;

    List<FancySlider> _sliders = <FancySlider>[];
    List<FancySliderFill> _fillers = <FancySliderFill>[];

    List<MainPickerFill> _mainPickerFillers = <MainPickerFill>[];
    List<FancySliderFill> _mainSliderFillers = <FancySliderFill>[];
    
    Colour colour = new Colour();
    Colour previousColour;

    ColourPicker._internal(InputElement this._input, {int width = 48, int height = 25, int colourInt = 0xDDDDDD, Colour colour}) {
        if (colour == null) {
            colour = new Colour.fromHex(colourInt);
        }
        createButton(colour, width, height);
        createElement();
        initFillers();
        readColourFromInput();
        _pickers.add(this);
        ColourPickerMouseHandler.init();
    }

    static ColourPicker create(InputElement input, {int width = 48, int height = 25, int colourInt = 0xDDDDDD, Colour colour}) {
        if (_isThisEdge()) {
            logger.debug("IE or Edge detected, skipping.");
            return null;
        }
        return new ColourPicker._internal(input, width:width, height:height, colourInt:colourInt, colour:colour);
    }

    Element get anchor => this._anchor;

    void setFromRGB([bool fromMain = false]) {
        logger.debug("setFromRGB");
        this.colour.redDouble = this._rgb_slider_red.value;
        this.colour.greenDouble = this._rgb_slider_green.value;
        this.colour.blueDouble = this._rgb_slider_blue.value;

        if (fromMain) {
            this._rgb_input_red.valueAsNumber = colour.red;
            this._rgb_input_green.valueAsNumber = colour.green;
            this._rgb_input_blue.valueAsNumber = colour.blue;
        }

        this.update(rgb:false, fromMain: fromMain);
    }

    void setFromHSV([bool fromMain = false]) {
        logger.debug("setFromRGB");
        this.colour.hue = this._hsv_slider_hue.value;
        this.colour.saturation = this._hsv_slider_sat.value;
        this.colour.value = this._hsv_slider_val.value;

        if (fromMain) {
            this._hsv_input_hue.valueAsNumber = (colour.hue * 360).floor();
            this._hsv_input_sat.valueAsNumber = (colour.saturation * 100).floor();
            this._hsv_input_val.valueAsNumber = (colour.value * 100).floor();
        }

        this.update(hsv:false, fromMain: fromMain);
    }

    void setFromLab() {
        this.colour.setLAB(
            _lab_input_l.valueAsNumber.toDouble(),
            _lab_input_a.valueAsNumber.toDouble(),
            _lab_input_b.valueAsNumber.toDouble()
        );
        this.update(lab:false);
    }

    void update({bool rgb = true, bool hsv = true, bool lab = true, bool fromMain = false, bool force = false}) {
        if (!(this.isOpen || force)) { return; }

        logger.debug("update: rgb: $rgb, hsv: $hsv, fromMain: $fromMain, force: $force");

        if (rgb) {
            this._rgb_slider_red.value = colour.redDouble;
            this._rgb_slider_green.value = colour.greenDouble;
            this._rgb_slider_blue.value = colour.blueDouble;

            this._rgb_input_red.valueAsNumber = colour.red;
            this._rgb_input_green.valueAsNumber = colour.green;
            this._rgb_input_blue.valueAsNumber = colour.blue;
        }

        if (hsv) {
            this._hsv_slider_hue.value = colour.hue;
            this._hsv_slider_sat.value = colour.saturation;
            this._hsv_slider_val.value = colour.value;

            this._hsv_input_hue.value = (colour.hue * 360).floor().toString();
            this._hsv_input_sat.value = (colour.saturation * 100).floor().toString();
            this._hsv_input_val.value = (colour.value * 100).floor().toString();
        }

        if (lab) {
            this._lab_input_l.value = this.colour.lab_lightness.toStringAsFixed(2);
            this._lab_input_a.value = this.colour.lab_a.toStringAsFixed(2);
            this._lab_input_b.value = this.colour.lab_b.toStringAsFixed(2);
        }

        for (int i=0; i<_sliders.length; i++) {
            _sliders[i]
                ..update(true)
                ..drawBackground(_fillers[i]);
        }

        this._updateMainPicker(!fromMain);

        this._hex_input.value = this.colour.toHexString();

        this._previewNew.style.backgroundColor = this.colour.toStyleString();

        this.modeButtons[pickMode].checked = true;
    }

    void _updateButtonSwatch() {
        this._buttonSwatch.style.backgroundColor = this.colour.toStyleString();
    }

    void _updateMainPicker(bool setValue) {
        logger.debug("updateMainPicker: setValue: $setValue");
        FancySliderFill sfill = _mainSliderFillers[pickMode];
        MainPickerFill pfill = _mainPickerFillers[pickMode];

        _mainSlider.drawBackground(sfill);

        CanvasRenderingContext2D ctx = _mainPicker.context2D;
        ImageData idata = ctx.getImageData(0, 0, 256, 256);

        int i;
        Colour fill;
        for (int x = 0; x < 256; x++) {
            for (int y = 0; y < 256; y++) {
                i = (y * 256 + x) * 4;

                fill = pfill(x / 255, 1.0 - (y / 255));

                idata.data[i] = fill.red;
                idata.data[i + 1] = fill.green;
                idata.data[i + 2] = fill.blue;
                idata.data[i + 3] = 255;
            }
        }

        ctx.putImageData(idata, 0, 0);

        List<FancySlider> sliders = _getSlidersForMode();
        double x = sliders[0].value;
        double y = sliders[1].value;
        double s = sliders[2].value;

        String selectorFill = this.colour.lab_lightness > 50 ? "#000000" : "#FFFFFF";
        ctx
            ..beginPath()
            ..arc((x * 255).round(), ((1.0-y) * 255).round(), 5, 0, Math.PI * 2)
            ..strokeStyle = selectorFill
            ..stroke();

        if (setValue) {
            this._mainSlider.value = s;
        }
        this._mainSlider.update(true);
    }

    List<FancySlider> _getSlidersForMode() {
        FancySlider x,y,s;
        if (pickMode == 0) {
            //red
            x = _rgb_slider_blue;
            y = _rgb_slider_green;
            s = _rgb_slider_red;
        } else if (pickMode == 1) {
            // green
            x = _rgb_slider_blue;
            y = _rgb_slider_red;
            s = _rgb_slider_green;
        } else if (pickMode == 2) {
            // blue
            x = _rgb_slider_red;
            y = _rgb_slider_green;
            s = _rgb_slider_blue;
        } else if (pickMode == 3) {
            // hue
            x = _hsv_slider_sat;
            y = _hsv_slider_val;
            s = _hsv_slider_hue;
        } else if (pickMode == 4) {
            // sat
            x = _hsv_slider_hue;
            y = _hsv_slider_val;
            s = _hsv_slider_sat;
        } else if (pickMode == 5) {
            // val
            x = _hsv_slider_hue;
            y = _hsv_slider_sat;
            s = _hsv_slider_val;
        }
        return <FancySlider>[x,y,s];
    }

    ColourPickerUpdateFunction _getUpdaterForMode() => pickMode >= 3 ? this.setFromHSV : this.setFromRGB;

    void open() {
        this.isOpen = true;
        this.previousColour = new Colour.from(this.colour);
        this._previewOld.style.backgroundColor = this.previousColour.toStyleString();

        this.readColourFromInput();
        this.update(force:true);

        this._overlay.style.display = "block";
        this.resizeOverlay();

        for (ColourPicker p in _pickers) {
            if (p!=this) {
                p.close();
            }
        }
    }

    void close() {
        this.isOpen = false;
        this._overlay.style.display = "none";
    }

    void _confirm([Event e]) {
        this.writeColourToInput();
        this.close();
    }

    void _cancel([Event e]) {
        this.colour.setFrom(this.previousColour);
        this.close();
    }

    void _setMode(int mode) {
        pickMode = mode;
        this.update();
    }

    void readColourFromInput() {
        this.colour = new Colour.fromStyleString(_input.value);
        this._updateButtonSwatch();
        this.update(force:true);
    }
    
    void writeColourToInput() { 
        this._input.value = this.colour.toStyleString();
        this._updateButtonSwatch();
        this._input.dispatchEvent(new Event("change"));
    }

    void initFillers() {
        //rgb
        _fillers.add((double val) => new Colour.from(this.colour)..redDouble = val);
        _fillers.add((double val) => new Colour.from(this.colour)..greenDouble = val);
        _fillers.add((double val) => new Colour.from(this.colour)..blueDouble = val);

        _mainSliderFillers.add((double val) => new Colour.from(this.colour)..redDouble = val);
        _mainSliderFillers.add((double val) => new Colour.from(this.colour)..greenDouble = val);
        _mainSliderFillers.add((double val) => new Colour.from(this.colour)..blueDouble = val);

        _mainPickerFillers.add((double x, double y) => new Colour.from(this.colour)..blueDouble = x..greenDouble = y);
        _mainPickerFillers.add((double x, double y) => new Colour.from(this.colour)..blueDouble = x..redDouble = y);
        _mainPickerFillers.add((double x, double y) => new Colour.from(this.colour)..redDouble = x..greenDouble = y);

        //hsv
        _fillers.add((double val) => new Colour.from(this.colour)..hue = val);
        _fillers.add((double val) => new Colour.from(this.colour)..saturation = val);
        _fillers.add((double val) => new Colour.from(this.colour)..value = val);

        _mainSliderFillers.add((double val) => new Colour.hsv(val, 1.0, 1.0));
        _mainSliderFillers.add((double val) => new Colour.from(this.colour)..saturation = val);
        _mainSliderFillers.add((double val) => new Colour.from(this.colour)..value = val);

        _mainPickerFillers.add((double x, double y) => new Colour.hsv(_hsv_slider_hue.value, x,y));
        _mainPickerFillers.add((double x, double y) => new Colour.hsv(x, _hsv_slider_sat.value, y));
        _mainPickerFillers.add((double x, double y) => new Colour.hsv(x, y, _hsv_slider_val.value));
    }

    // element and getter stuff ###############################################################

    InputElement get input => _input;

    void createButton(Colour colour, int width, int height) {
        Element anchor = new DivElement()
            ..className = "colourPicker_anchor";

        //CssStyleDeclaration inputstyle = this._input.getComputedStyle();

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

        this._anchor.append(new DivElement()..className="colourPicker_hidden"..append(this._input));
    }

    void createElement() {
        Element overlay = new DivElement()
            ..className = "colourPicker_overlay";

        this._anchor.append(overlay);

        Element overlay_shade = new DivElement()
            ..className = "colourPicker_overlay_2"
            ..onClick.listen((MouseEvent e) {
                //this._cancel();
                e.preventDefault();
                e.stopPropagation();
            });

        overlay.append(overlay_shade);

        Element w = new DivElement()
            ..className = "colourPicker_window"
            ..onClick.listen((Event e) => e.stopPropagation());
            //..text = "Stuff goes in here";

        overlay.append(w);
        this._window = w;

        this._mainPicker = new CanvasElement(width:256, height:256)
            ..className="colourPicker_canvas"
            ..onMouseDown.listen((MouseEvent e) {
                logger.debug("PICKER CLICK");
                this.picking = true;
                logger.info("click");
                this._pickerDrag(e);
            });
        w.append(_mainPicker);

        this._mainSlider = new FancySlider(0.0, 1.0, 25, 256, true)..appendTo(w)..onChange.listen(_setFromPicker);
        _place(_mainSlider.bar, 268, 0);

        // #########################################################

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "Old"..style.textAlign="center";
            _place(title, 57, 263);
            w.append(title);
        }

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "New"..style.textAlign="center";
            _place(title, 183, 263);
            w.append(title);
        }

        Element previewbox = new DivElement()..className = "colourPicker_previewbox";
        _place(previewbox, 4, 279);
        w.append(previewbox);

        _previewOld = new DivElement()..style.cursor="pointer"..onClick.listen((Event e) {
            this.colour.setFrom(this.previousColour);
            this.update();
        });
        previewbox.append(_previewOld);
        _previewNew = new DivElement()..style.left = "50%";
        previewbox.append(_previewNew);

        // #########################################################

        int radio_left = 305;
        int bar_left = 330;
        int input_left = 600;

        int rgb_top = 5;
        int hsv_top = 115;
        int per_slider = 30;
        int slider_title_height = 15;

        // #########################################################
        // RGB #####################################################
        // #########################################################

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "Red, Green, Blue";
            _place(title, bar_left, rgb_top);
            w.append(title);
        }

        // RED #########

        this._rgb_input_red = new NumberInputElement()..className="colourPicker_number"..min="0"..max="255"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_rgb_input_red, 0, 255, 0);
                _rgb_slider_red.value = _rgb_input_red.valueAsNumber/255.0;
                this.setFromRGB();
            });
        _place(_rgb_input_red, input_left, rgb_top + slider_title_height);
        w.append(_rgb_input_red);

        this._rgb_slider_red = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._rgb_input_red.value = (this._rgb_slider_red.value * 255).round().toString();
                this.setFromRGB();
            });
        _place(_rgb_slider_red.bar, bar_left, rgb_top + slider_title_height);
        _sliders.add(_rgb_slider_red);

        // GREEN #########

        this._rgb_input_green = new NumberInputElement()..className="colourPicker_number"..min="0"..max="255"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_rgb_input_green, 0, 255, 0);
                _rgb_slider_green.value = _rgb_input_green.valueAsNumber/255.0;
                this.setFromRGB();
            });
        _place(_rgb_input_green, input_left, rgb_top + per_slider + slider_title_height);
        w.append(_rgb_input_green);
        
        this._rgb_slider_green = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._rgb_input_green.value = (this._rgb_slider_green.value * 255).round().toString();
                this.setFromRGB();
            });
        _place(_rgb_slider_green.bar, bar_left, rgb_top + per_slider + slider_title_height);
        _sliders.add(_rgb_slider_green);

        // BLUE #########

        this._rgb_input_blue = new NumberInputElement()..className="colourPicker_number"..min="0"..max="255"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_rgb_input_blue, 0, 255, 0);
                _rgb_slider_blue.value = _rgb_input_blue.valueAsNumber/255.0;
                this.setFromRGB();
            });
        _place(_rgb_input_blue, input_left, rgb_top + per_slider*2 + slider_title_height);
        w.append(_rgb_input_blue);
        
        this._rgb_slider_blue = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._rgb_input_blue.value = (this._rgb_slider_blue.value * 255).round().toString();
                this.setFromRGB();
            });
        _place(_rgb_slider_blue.bar, bar_left, rgb_top + per_slider*2 + slider_title_height);
        _sliders.add(_rgb_slider_blue);

        // #########################################################
        // HSV #####################################################
        // #########################################################

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "Hue, Saturation, Value";
            _place(title, bar_left, hsv_top);
            w.append(title);
        }

        // HUE #########
        double huemax = 360.0;

        this._hsv_input_hue = new NumberInputElement()..className="colourPicker_number"..min="0"..max="360"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_hsv_input_hue, 0, huemax, 0);
                _hsv_slider_hue.value = _hsv_input_hue.valueAsNumber/huemax;
                this.setFromHSV();
            });
        _place(_hsv_input_hue, input_left, hsv_top + slider_title_height);
        w.append(_hsv_input_hue);
        
        this._hsv_slider_hue = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._hsv_input_hue.value = (this._hsv_slider_hue.value * huemax).round().toString();
                this.setFromHSV();
            });
        _place(_hsv_slider_hue.bar, bar_left, hsv_top + slider_title_height);
        _sliders.add(_hsv_slider_hue);

        // SAT #########

        this._hsv_input_sat = new NumberInputElement()..className="colourPicker_number"..min="0"..max="100"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_hsv_input_sat, 0, 100, 0);
                _hsv_slider_sat.value = _hsv_input_sat.valueAsNumber/100.0;
                this.setFromHSV();
            });
        _place(_hsv_input_sat, input_left, hsv_top + per_slider + slider_title_height);
        w.append(_hsv_input_sat);
        
        this._hsv_slider_sat = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._hsv_input_sat.value = (this._hsv_slider_sat.value * 100).round().toString();
                this.setFromHSV();
            });
        _place(_hsv_slider_sat.bar, bar_left, hsv_top + per_slider + slider_title_height);
        _sliders.add(_hsv_slider_sat);

        // VAL #########

        this._hsv_input_val = new NumberInputElement()..className="colourPicker_number"..min="0"..max="100"..step="1"
            ..onChange.listen((Event e){
                _limitInputValue(_hsv_input_val, 0, 100, 0);
                _hsv_slider_val.value = _hsv_input_val.valueAsNumber/100.0;
                this.setFromHSV();
            });
        _place(_hsv_input_val, input_left, hsv_top + per_slider * 2 + slider_title_height);
        w.append(_hsv_input_val);
        
        this._hsv_slider_val = new FancySlider(0.0, 1.0, 256, 16, false)
            ..appendTo(w)
            ..onChange.listen((Event e) {
                this._hsv_input_val.value = (this._hsv_slider_val.value * 100).round().toString();
                this.setFromHSV();
            });
        _place(_hsv_slider_val.bar, bar_left, hsv_top + per_slider * 2 + slider_title_height);
        _sliders.add(_hsv_slider_val);

        // #########################################################
        // #########################################################
        // #########################################################

        // buttons and stuff

        Element radiobox = new FormElement();
        int radio_offset = -1;

        // RGB #####################################################
        
        RadioButtonInputElement r_red = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(0); });
        radiobox.append(r_red);
        _place(r_red, radio_left, rgb_top + slider_title_height + radio_offset);
        this.modeButtons.add(r_red);

        RadioButtonInputElement r_green = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(1); });
        radiobox.append(r_green);
        _place(r_green, radio_left, rgb_top + per_slider + slider_title_height + radio_offset);
        this.modeButtons.add(r_green);

        RadioButtonInputElement r_blue = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(2); });
        radiobox.append(r_blue);
        _place(r_blue, radio_left, rgb_top + per_slider * 2 + slider_title_height + radio_offset);
        this.modeButtons.add(r_blue);

        // HSV #####################################################

        RadioButtonInputElement r_hue = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(3); });
        radiobox.append(r_hue);
        _place(r_hue, radio_left, hsv_top + slider_title_height + radio_offset);
        this.modeButtons.add(r_hue);

        RadioButtonInputElement r_sat = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(4); });
        radiobox.append(r_sat);
        _place(r_sat, radio_left, hsv_top + per_slider + slider_title_height + radio_offset);
        this.modeButtons.add(r_sat);

        RadioButtonInputElement r_val = new RadioButtonInputElement()..name="mode"..onChange.listen((Event e) { this._setMode(5); });
        radiobox.append(r_val);
        _place(r_val, radio_left, hsv_top + per_slider * 2 + slider_title_height + radio_offset);
        this.modeButtons.add(r_val);

        // #########################################################
        
        w.append(radiobox);

        // #########################################################
        // #########################################################
        // #########################################################

        // Lab
        int lab_left = bar_left;
        int lab_box_left = lab_left + 4 + 10;
        int lab_width = 78;
        int lab_top = 226;
        int label_offset = 4;
        
        {
            Element title = new DivElement()..className="colourPicker_text"..text = "CIEL*a*b";
            _place(title, lab_left, lab_top);
            w.append(title);
        }

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "L";
            _place(title, lab_left, lab_top + slider_title_height + label_offset);
            w.append(title);
        }

        this._lab_input_l = new NumberInputElement()..className="colourPicker_number colourPicker_lab"..min="0"..max="100"..step="0.01"
            ..onChange.listen((Event e){
                _limitInputValue(_lab_input_l, 0, 100, 2);
                this.setFromLab();
            });
        _place(_lab_input_l, lab_box_left, lab_top + slider_title_height);
        w.append(_lab_input_l);

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "a";
            _place(title, lab_left + lab_width, lab_top + slider_title_height + label_offset);
            w.append(title);
        }

        this._lab_input_a = new NumberInputElement()..className="colourPicker_number colourPicker_lab"..min="-127"..max="128"..step="0.01"
            ..onChange.listen((Event e){
                _limitInputValue(_lab_input_a, -127, 128, 2);
                this.setFromLab();
            });
        _place(_lab_input_a, lab_box_left + lab_width, lab_top + slider_title_height);
        w.append(_lab_input_a);

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "b";
            _place(title, lab_left + lab_width * 2, lab_top + slider_title_height + label_offset);
            w.append(title);
        }

        this._lab_input_b = new NumberInputElement()..className="colourPicker_number colourPicker_lab"..min="-127"..max="128"..step="0.01"
            ..onChange.listen((Event e){
                _limitInputValue(_lab_input_b, -127, 128, 2);
                this.setFromLab();
            });
        _place(_lab_input_b, lab_box_left + lab_width * 2, lab_top + slider_title_height);
        w.append(_lab_input_b);

        // #########################################################
        
        // hex
        
        int hex_left = 573;
        int hex_top = 226;
        
        {
            Element title = new DivElement()..className="colourPicker_text"..text = "Hex";
            _place(title, hex_left, hex_top);
            w.append(title);
        }

        {
            Element title = new DivElement()..className="colourPicker_text"..text = "#";
            _place(title, hex_left, hex_top + slider_title_height + label_offset);
            w.append(title);
        }

        this._hex_input = new TextInputElement()..maxLength=6..pattern=r"[\d|a-f|A-F]{6}"..className="colourPicker_hex"
            ..onChange.listen((Event e){
                String hex = _hex_input.value;
                Colour col = new Colour.fromHexString(hex);
                this.colour.setFrom(col);
                this.update();
            });
        _place(_hex_input, hex_left + 12, hex_top + slider_title_height);
        w.append(_hex_input);
        
        // #########################################################
        // buttons

        ButtonElement okbutton = new ButtonElement()..className="colourPicker_innerButton"..text="OK"..onClick.listen(_confirm);
        _place(okbutton, 570, 285);
        w.append(okbutton);

        ButtonElement cancelbutton = new ButtonElement()..className="colourPicker_innerButton"..text="Cancel"..onClick.listen(_cancel);
        _place(cancelbutton, 470, 285);
        w.append(cancelbutton);

        // #########################################################

        this._overlay = overlay;
        window.onResize.listen(resizeOverlay);
        resizeOverlay();
    }

    static void _place(Element e, int x, int y) {
        e.style
            ..top = "${y}px"
            ..left = "${x}px";
    }

    static void _limitInputValue(NumberInputElement input, num min, num max, int decimals) {
        num val = _roundToPoints(input.valueAsNumber, decimals);
        input.value = val.clamp(min, max).toStringAsFixed(decimals);
    }

    static num _roundToPoints(num input, int decimals) {
        num val = input;
        for (int i=0; i<decimals; i++) {
            val *= 10;
        }
        val = (val).roundToDouble();
        for (int i=0; i<decimals; i++) {
            val *= 0.1;
        }
        return val;
    }

    static void notifyAllPickers() {
        if (_isThisEdge()) { return; }
        for (ColourPicker p in _pickers) {
            if (p._input.value != p.colour.toStyleString()) {
                p.readColourFromInput();
            }
        }
    }

    void _pickerDrag(MouseEvent e) {
        if (!picking) { return; }
        logger.info("a1");
        logger.debug("pickerDrag");
        logger.info("a2");
        int relx = e.client.x - this._mainPicker.documentOffset.x -1;
        int rely = e.client.y - this._mainPicker.documentOffset.y -1;
        logger.info("a3");
        relx = relx.clamp(0, 255);
        rely = rely.clamp(0, 255);
        logger.info("a4");
        List<FancySlider> sliders = _getSlidersForMode();
        logger.info("a5");
        sliders[0].value = relx/255.0;
        sliders[1].value = 1.0 - (rely/255.0);
        logger.info("a6");
        //_getUpdaterForMode()(true);
        _setFromPicker();
        logger.info("a7");
    }

    void _setFromPicker([Event e]) {
        logger.debug("setFromPicker");
        List<FancySlider> sliders = _getSlidersForMode();
        sliders[2].value = _mainSlider.value;
        _getUpdaterForMode()(true);

        //this.update();
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

    static RegExp _detectEdge = new RegExp(r"Edge\/\d+");
    static bool _isThisEdge() {
        return Device.isIE || window.navigator.userAgent.contains(_detectEdge);
    }
}

typedef Colour MainPickerFill(double x, double y);
typedef Colour FancySliderFill(double fraction);
typedef void ColourPickerUpdateFunction(bool fromMain);

class FancySlider {
    Logger logger = Logger.get("FancySlider", false);

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

    void update([bool silent = false]) {
        logger.debug("update: silent: $silent");
        double percent = (this.value - this.minVal) / (this.maxVal - this.minVal);

        if (this.vertical) {
            int pos = (this.height * (1.0 - percent)).floor();
            this.slider.style.top = "${pos}px";
        } else {
            int pos = (this.width * percent).floor();
            this.slider.style.left = "${pos}px";
        }

        if (!silent) {
            this._streamController.add(new CustomEvent("update", detail: this));
        }
    }

    void _mouseDown(MouseEvent e) {
        logger.debug("SLIDER CLICK");
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
            percent = (1.0 - (rely / this.height)).clamp(0.0, 1.0);
        } else {
            percent = (relx / this.width).clamp(0.0, 1.0);
        }

        this.value = percent * (this.maxVal - this.minVal) + this.minVal;

        this.update();
    }

    void drawBackground(FancySliderFill filler) {
        CanvasRenderingContext2D ctx = this.background.context2D;

        ImageData img = ctx.getImageData(0, 0, this.background.width, this.background.height);

        for (int x = 0; x<this.width; x++) {
            for (int y = 0; y<this.height; y++) {
                int i = (y * this.width + x) * 4;

                Colour c = filler(this.vertical ? 1.0 - (y / this.height) : x / this.width);

                img.data[i] = c.red;
                img.data[i+1] = c.green;
                img.data[i+2] = c.blue;
                img.data[i+3] = 255;
            }
        }

        ctx.putImageData(img, 0, 0);
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
                p.picking = false;
            }

            for (FancySlider s in FancySlider._sliders) {
                s._mouseUp(e);
            }
        });

        window.onMouseMove.listen((MouseEvent e) {
            for (ColourPicker p in ColourPicker._pickers) {
                p._pickerDrag(e);
            }

            for (FancySlider s in FancySlider._sliders) {
                s._mouseMove(e);
            }
        });
    }
}