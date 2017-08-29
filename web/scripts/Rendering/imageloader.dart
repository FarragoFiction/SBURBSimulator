import 'dart:async';
import 'dart:html';

import '../includes/logger.dart';
import '../includes/path_utils.dart';

abstract class ImageLoader {
    static Logger logger = Logger.get("Image Loader");

    static Map<String, ImageElement> _images = <String, ImageElement>{};
    static Map<String, List<Completer<ImageElement>>> _callbacks = <String, List<Completer<ImageElement>>>{};

    static Future<ImageElement> load(String path) async {
        Completer<ImageElement> completer = new Completer<ImageElement>();

        if (_images.containsKey(path)) {
            return _images[path];
        } else {
            if (!_callbacks.containsKey(path)) {
                _callbacks[path] = <Completer<ImageElement>>[];

                logger.debug("Requesting $path");

                ImageElement img = new ImageElement(src: PathUtils.adjusted("images/$path"));
                img.onLoad.listen((Event e) {
                    logger.debug("Callbacks for $path");
                    _images[path] = img;
                    for (Completer<ImageElement> callback in _callbacks[path]) {
                        callback.complete(_images[path]);
                    }
                    _callbacks[path] = null;
                });
                img.onError.listen((Event e) {
                    logger.warn("Failed to load image $path");
                    for (Completer<ImageElement> callback in _callbacks[path]) {
                        callback.completeError("Failed to load image $path");
                    }
                    _callbacks[path] = null;
                });
            }

            logger.debug("Registering callback for $path");
            _callbacks[path].add(completer);
        }

        return completer.future;
    }

    ImageElement get(String path) => _images[path];
}