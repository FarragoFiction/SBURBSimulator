import "dart:async";

import "package:js/js_util.dart" as JsUtil;

import '../../includes/colour.dart';
import "../../loader/loader.dart";
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

