import 'dart:async';

import "../formats/Formats.dart";
import "../includes/path_utils.dart";
import "resource.dart";

export "resource.dart";

abstract class Loader {

    static Map<String, Resource<dynamic>> _resources = <String, Resource<dynamic>>{};

    static void init() {
        Formats.init();
    }

    static Future<T> getResource<T>(String path, [FileFormat<T, dynamic> format]) async {
        if (_resources.containsKey(path)) {
            Resource<dynamic> res = _resources[path];
            if (res is Resource<T>) {
                if (res.object != null) {
                    return res.object;
                } else {
                    return res.addListener();
                }
            } else {
                throw "Requested resource ($path) is ${res.object.runtimeType}. Expected $T";
            }
        } else {
            return _load(path, format);
        }
    }

    static Future<T> _load<T>(String path, [FileFormat<T, dynamic> format = null]) {
        if(_resources.containsKey(path)) {
            throw "Resource $path has already been requested for loading";
        }

        if (format == null) {
            String extension = path.split(".").last;
            format = Formats.getFormatForExtension(extension);
        }

        Resource<T> res = new Resource<T>(path);
        _resources[path] = res;

        format.requestFromUrl(PathUtils.adjusted(path))..then((T item) => res.populate(item));

        return res.addListener();
    }
}