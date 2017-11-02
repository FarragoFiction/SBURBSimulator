import "dart:async";
import "dart:html";

import "../../loader/loader.dart";

Future<ScriptElement> load() => Loader.loadJavaScript("scripts/Rendering/text/opentype.min.js");
