import 'dart:collection';
import 'dart:html';

import 'colour.dart';

class Palette extends Object with IterableMixin<Colour>{
    static Colour MISSING_COLOUR = new Colour(255,0,255);

    HashMap<String, Colour> _colours = new HashMap<String, Colour>();
    HashMap<int, Colour> _colourIds = new HashMap<int, Colour>();
    HashMap<String, int> _name2id = new HashMap<String, int>();
    HashMap<int, String> _id2name = new HashMap<int,String>();

    Palette() {}

    factory Palette.combined(List<Palette> operands) {
        Palette palette = new Palette();

        for (Palette o in operands) {
            for (String name in o.names) {
                palette.add(name, o[name], true);
            }
        }

        return palette;
    }

    Colour operator [](dynamic name) {
        if (name is String) {
            return _colours.containsKey(name) ? _colours[name] : MISSING_COLOUR;
        } else if (name is int) {
            return _colourIds.containsKey(name) ? _colourIds[name] : MISSING_COLOUR;
        }
        throw new ArgumentError.value(name, "'name' should be a String name or int id only");
    }

    @override
    Iterator<Colour> get iterator => _colours.values.iterator;
    Iterable<String> get names => _colours.keys;
    Iterable<int> get ids => _colourIds.keys;

    bool containsName(String name) => this._colours.containsKey(name);
    bool containsId(int id) => this._colourIds.containsKey(id);

    void add(String name, Colour c, [bool overwrite = false]) {
        if (!overwrite && this._colours.containsKey(name)) {
            throw new ArgumentError.value(name, "Colour name already exists in the palette");
        }
        if (this._colours.containsKey(name)) {
            this.remove(name);
        }
        int id = _nextFreeId();
        if (id >= 256) {
            throw new ArgumentError.value(id, "Palette colour ids must be in the range 0-255");
        }
        this._colours[name] = c;
        this._colourIds[id] = c;
        this._name2id[name] = id;
        this._id2name[id] = name;
    }

    void addHex(String name, int hex, [bool overwrite = false]) {
        this.add(name, new Colour.fromHex(hex, hex.toRadixString(16).padLeft(6, "0").length > 6));
    }

    void remove(String name) {
        if (!_colours.containsKey(name)) {
            return;
        }
        int id = _name2id[name];

        this._remove(name, id);
    }

    void removeId(int id) {
        if (!_colourIds.containsKey(id)) {
            return;
        }
        String name = _id2name[id];

        this._remove(name, id);
    }

    void _remove(String name, int id) {
        _colours.remove(name);
        _colourIds.remove(id);
        _name2id.remove(name);
        _id2name.remove(id);
    }

    int _nextFreeId() {
        int i=0;
        while(true) {
            if (!this._colourIds.containsKey(i)) {
                return i;
            }
            i++;
        }
    }

    Element createPreviewElement([String title = "Palette"]) {
        DivElement element = new DivElement();
        element.style
            ..padding = "3px"
            ..margin = "3px"
            ..outline = "1px solid black"
            ..display = "inline-block"
            ..textAlign = "left";

        element.append(new SpanElement()..style.fontWeight="bold"..text=title);

        for (int id in this._colourIds.keys) {
            String name = _id2name[id];

            Colour col = _colourIds[id];

            DivElement div = new DivElement();

            DivElement swatch = new DivElement()..title=col.toStyleString().toUpperCase();
            swatch.style
                ..position = "relative"
                ..display = "inline-block"
                ..marginRight = "3px"
                ..width = "10px"
                ..height = "10px"
                ..backgroundColor = col.toStyleString();

            SpanElement text = new SpanElement()
                ..text = "$id: $name";

            div..append(swatch)..append(text);
            element.append(div);
        }

        return element;
    }
}