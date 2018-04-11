import "dart:async";
import "dart:typed_data";

import "../Rendering/threed/three.dart" as THREE;

import "../SBURBSim.dart";

class OBJFormat extends BinaryFileFormat<THREE.Mesh> {
    THREE.OBJLoader2 _parser;

    @override
    String mimeType() => "application/object";

    @override
    Future<THREE.Mesh> read(ByteBuffer input) async {
        await THREE.ScriptLoader.three();
        await THREE.ScriptLoader.obj();

        if (_parser == null) {
            _parser = new THREE.OBJLoader2();
        }

        print("parser: $_parser");
        print("parse?: ${_parser.parse}");

        _parser.parse(input);

        return null;//_parser.parse(input);
    }

    @override
    Future<ByteBuffer> write(THREE.Mesh data) { throw "OBJ saving not implemented"; }

    @override
    String header() => "";
}