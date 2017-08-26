import 'dart:html';
import 'dart:math' as Math;
import 'logger.dart';

abstract class PathUtils {
    static Logger logger = Logger.get("Path Utils", false);

    static Map<Uri, int> _pathdepth = <Uri, int>{};

    /// PL: WOW THIS IS TOTAL BULLSHIT
    static int getSubDirectoryCount(Uri path) {
        String hereUrl = path.toString();
        List<Element> links = querySelectorAll("link");
        for (Element e in links) {
            if (e is LinkElement && e.rel == "stylesheet") {
                logger.debug("is sheet: ${e.href}");
                int shorter = Math.min(hereUrl.length, e.href.length);
                for (int i=0; i<shorter; i++) {
                    if (!(hereUrl[i] == e.href[i])) {
                        String local = hereUrl.substring(i);
                        logger.debug("path: $local");
                        return local.split("/").length-1;
                    }
                    continue;
                }
            }
        }
        logger.warn("Didn't find a css link to derive relative path");
        return 0;
    }

    static String adjusted(String path) {
        return "${"../" * getPathDepth()}$path";
    }

    static int getPathDepth() {
        Uri path = Uri.base;
        if (!_pathdepth.containsKey(path)) {
            _pathdepth[path] = getSubDirectoryCount(path);
        }
        return _pathdepth[path];
    }
}
