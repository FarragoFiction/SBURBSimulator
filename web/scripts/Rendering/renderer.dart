import "dart:async";

import "../SBURBSim.dart";

class Renderer {
    static bool _loadedThree = false;

    Renderer() {

    }

    static Future<bool> loadThree() async {
        if (_loadedThree) { return true; }
        await Loader.loadJavaScript("scripts/Rendering/3d/three.min.js");
        return true;
    }
}