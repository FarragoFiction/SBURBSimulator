import "dart:async";

import "../SBURBSim.dart";
import "3d/three.dart" as THREE;

class Renderer {
    static bool _loadedThree = false;

    static THREE.WebGLRenderer _renderer = new THREE.WebGLRenderer();

    static Future<bool> loadThree() async {
        if (_loadedThree) { return true; }
        await Loader.loadJavaScript("scripts/Rendering/3d/three.min.js");
        return true;
    }
}