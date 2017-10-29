import "dart:async";
import "dart:html";
import "dart:math";

import "../../loader/loader.dart";
import "../3d/three.dart" as THREE;
import "../renderer.dart";
import "effect.dart";

class GroupPass extends RenderJobPass {

    List<RenderJobPass> subPasses = <RenderJobPass>[];

    void addPass(RenderJobPass pass) {
        subPasses.add(pass);
    }

    @override
    Future<Null> draw(RenderJob job) async {
        THREE.WebGLRenderTarget buffer = Renderer.pushBufferStack();

        for (RenderJobPass pass in subPasses) {
            pass.draw(job); // TODO: waaaay unfinished here!
        }

        Renderer.popBufferStack();
    }
}