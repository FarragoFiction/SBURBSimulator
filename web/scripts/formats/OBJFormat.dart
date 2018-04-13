import "dart:async";
import "dart:typed_data";

import "../Rendering/threed/three.dart" as THREE;

import "../SBURBSim.dart";

class OBJFormat extends StringFileFormat<THREE.Object3D> {
    THREE.OBJLoader2 _parser;

    @override
    String mimeType() => "application/object";

    @override
    Future<THREE.Object3D> read(String input) async {
        await THREE.ScriptLoader.three();
        await THREE.ScriptLoader.obj();

        if (_parser == null) {
            _parser = new THREE.OBJLoader2()
                ..setMaterials(<String,THREE.Material>{
                    "" : THREE.DEFAULT_MATERIAL,
                })
                ..setLogging(false)
            ;
        }

        _parser.parse(input);

        return _parser.parse(input);
    }

    @override
    Future<String> write(THREE.Object3D data) { throw "OBJ saving not implemented"; }

    @override
    String header() => "";
}

/*
class OBJFormat extends BinaryFileFormat<THREE.Object3D> {
    THREE.OBJLoader2 _parser;

    @override
    String mimeType() => "application/object";

    @override
    Future<THREE.Object3D> read(ByteBuffer input) async {
        await THREE.ScriptLoader.three();
        await THREE.ScriptLoader.obj();

        if (_parser == null) {
            _parser = new THREE.OBJLoader2();//..setLogging(false);
        }

        _parser.parse(input);

        return _parser.parse(input);
    }

    @override
    Future<ByteBuffer> write(THREE.Object3D data) { throw "OBJ saving not implemented"; }

    @override
    String header() => "";
}
 */