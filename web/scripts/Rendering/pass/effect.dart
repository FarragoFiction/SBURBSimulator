import "../../random.dart";
import "../3d/three.dart" as THREE;

class RenderEffect {
    String vertexShader;
    String fragmentShader;

    Map<String, THREE.ShaderUniform<dynamic>> uniforms = <String, THREE.ShaderUniform<dynamic>>{};

    RenderEffect(String this.vertexShader, String this.fragmentShader);
}

class RenderEffectNullGlitch extends RenderEffect {
    static Random rand = new Random();

    RenderEffectNullGlitch() : super("shaders/image.vert", "shaders/nullglitch.frag") {
        this.uniforms["seed"] = new THREE.ShaderUniform<double>()..value = rand.nextDouble();
    }
}