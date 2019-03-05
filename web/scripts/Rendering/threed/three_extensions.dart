import "dart:async";
import "dart:html";
import "dart:math" as Math;

import "package:js/js_util.dart" as JsUtil;

import '../../includes/colour.dart';
import "../../loader/loader.dart";
import "../text/opentype.dart" as OT;
import "three.dart";

final Material DEFAULT_MATERIAL = new MeshBasicMaterial(new MeshBasicMaterialProperties(color: 0xFF00FF));

abstract class ScriptLoader {
    static Future<ScriptElement> three() => Loader.loadJavaScript("scripts/Rendering/threed/three.min.js");

    static Future<ScriptElement> obj() async {
        await Loader.loadJavaScript("scripts/Rendering/threed/extensions/LoaderSupport.js");
        return Loader.loadJavaScript("scripts/Rendering/threed/extensions/OBJLoader2.js");
    }

    static Future<ScriptElement> particleSystem() => Loader.loadJavaScript("scripts/Rendering/threed/extensions/GPUParticleSystem.js");
}


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
    List<List<OT.PathCommand>> sublists = <List<OT.PathCommand>>[];
    List<OT.PathCommand> sublist = <OT.PathCommand>[];

    for(OT.PathCommand c in path.commands) {
        sublist.add(c);
        if (c.type == "Z") {
            sublists.add(sublist);
            sublist = <OT.PathCommand>[];
        }
    }

    Map<Shape,Vector4> shapes = <Shape,Vector4>{};
    Map<Path,Vector4> holes = <Path,Vector4>{};

    bool first = true;
    bool winding = false;

    //print("sublists: ${sublists.length}");

    for (List<OT.PathCommand> sublist in sublists) {
        List<Vector2> approx = _approximateCommandCoords(sublist);
        if (first) {
            first = false;
            if (ShapeUtils.isClockWise(approx)) {
                winding = true;
            }
        }
        if (ShapeUtils.isClockWise(approx) == winding) {
            //print("main shape");
            //print(sublist.length);
            Shape shape = new Shape();
            for (OT.PathCommand command in sublist) {
                applyPathCommandToPath(shape, command);
            }
            shapes[shape] = _commandBounds(sublist);
        } else {
            //print("hole");
            Path hole = new Path();
            for (OT.PathCommand command in sublist) {
                applyPathCommandToPath(hole, command);
            }
            holes[hole] = _commandBounds(sublist);
        }
    }

    for(Path hole in holes.keys) {
        Vector4 holebounds = holes[hole];

        for (Shape shape in shapes.keys) {
            Vector4 shapebounds = shapes[shape];

            if (holebounds.x >= shapebounds.x && holebounds.y >= shapebounds.y && holebounds.z <= shapebounds.z && holebounds.w <= shapebounds.w) {
                shape.holes.add(hole);
                break;
            }
        }
    }

    return shapes.keys.toList();
}

List<Vector2> _approximateCommandCoords(List<OT.PathCommand> commands) {
    List<Vector2> points = <Vector2>[];
    for (OT.PathCommand c in commands) {
        points.add(new Vector2(c.x, c.y));
    }
    return points;
}

Vector4 _commandBounds(List<OT.PathCommand> commands) {
    num minx = double.INFINITY;
    num miny = double.INFINITY;
    num maxx = double.NEGATIVE_INFINITY;
    num maxy = double.NEGATIVE_INFINITY;

    for (OT.PathCommand c in commands) {
        if (c.x != null && c.y != null) {
            minx = Math.min(minx, c.x);
            miny = Math.min(miny, c.y);
            maxx = Math.max(maxx, c.x);
            maxy = Math.max(maxy, c.y);
        }
    }

    return new Vector4(minx, miny, maxx, maxy);
}

void applyPathCommandToPath(Path shape, OT.PathCommand c) {
    if (c.type == "M") {
        //print("moveTo ${c.x},${c.y}");
        shape.moveTo(c.x, c.y);
    } else if (c.type == "L") {
        //print("lineTo ${c.x},${c.y}");
        shape.lineTo(c.x, c.y);
    } else if (c.type == "Q") {
        //print("quadraticCurveTo ${c.x},${c.y}, control: ${c.x1},${c.y1}");
        shape.quadraticCurveTo(c.x1, c.y1, c.x, c.y);
    } else if (c.type == "C") {
        //print("bezierCurveTo ${c.x},${c.y}, controls: ${c.x1},${c.y1}, ${c.x2},${c.y2}");
        shape.bezierCurveTo(c.x1, c.y1, c.x2, c.y2, c.x, c.y);
    } else if (c.type == "Z") {
        //print("closePath");
        shape.closePath();
    }
}

