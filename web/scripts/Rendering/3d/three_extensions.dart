import "dart:async";

import "package:js/js_util.dart" as JsUtil;

import '../../includes/colour.dart';
import "../../loader/loader.dart";
import "../text/opentype.dart" as OT;
import "three.dart";

Future<ShaderMaterial> makeShaderMaterial(String vertexfile, String fragmentfile) async {
    List<String> programs = await Future.wait(<Future<String>>[
        Loader.getResource(vertexfile),
        Loader.getResource(fragmentfile)
    ]);

    return new ShaderMaterial(new ShaderMaterialParameters(vertexShader: programs[0], fragmentShader: programs[1]));
}

ShaderUniform<dynamic> getUniform(ShaderMaterial mat, String name) {
    return JsUtil.getProperty(mat.uniforms, name);
}

void setUniform(ShaderMaterial mat, String name, ShaderUniform<dynamic> value) {
    JsUtil.setProperty(mat.uniforms, name, value);
}

Vector4 colour2vec(Colour colour) {
    return new Vector4(colour.redDouble, colour.greenDouble, colour.blueDouble, colour.alphaDouble);
}

List<Shape> getShapesForText(String text, OT.Font font, num fontSize) {
    OT.Path textPath = font.getPath(text, 0, 0, fontSize);

    return getShapesFromOTPath(textPath);
}

List<Shape> getShapesFromOTPath(OT.Path path) {
    List<Shape> shapes = <Shape>[];

    Shape shape = new Shape();

    for(OT.PathCommand c in path.commands) {
        if (c.type == "M") {
            print("moveTo ${c.x},${c.y}");
            shape.moveTo(c.x, c.y);
        } else if (c.type == "L") {
            print("lineTo ${c.x},${c.y}");
            shape.lineTo(c.x, c.y);
        } else if (c.type == "Q") {
            print("quadraticCurveTo ${c.x},${c.y}, control: ${c.x1},${c.y1}");
            shape.quadraticCurveTo(c.x1, c.y1, c.x, c.y);
        } else if (c.type == "C") {
            print("bezierCurveTo ${c.x},${c.y}, controls: ${c.x1},${c.y1}, ${c.x2},${c.y2}");
            shape.bezierCurveTo(c.x1, c.y1, c.x2, c.y2, c.x, c.y);
        } else if (c.type == "Z") {
            print("closePath");
            shape.closePath();
            shapes.add(shape);
            shape = new Shape();
        }
    }

    return shapes;
}

