import 'dart:async';
import "dart:typed_data";

import "package:archive/archive.dart";

import "../formats/Formats.dart";
import "../formats/BundleManifest.dart";
import "../includes/path_utils.dart";
import "resource.dart";

export "resource.dart";

abstract class Loader {

    static BundleManifest manifest;
    static Map<String, Resource<dynamic>> _resources = <String, Resource<dynamic>>{};

    static void init() {
        Formats.init();
    }

    static Future<T> getResource<T>(String path, {FileFormat<T, dynamic> format, bool bypassManifest = false}) async {
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
            if (!bypassManifest) {
                if (manifest == null) {
                    manifest = await Loader.getResource("manifest/manifest.txt", format: Formats.manifest, bypassManifest: true);
                }

                String bundle = manifest.getBundleForFile(path);

                if (bundle != null) {
                    print("File $path is in bundle $bundle");

                    _loadBundle(bundle);
                    return _createResource(path).addListener();
                }
            }
            return _load(path, format);
        }
    }

    static Resource<T> _createResource<T>(String path) {
        if (!_resources.containsKey(path)) {
            _resources[path] = new Resource<T>(path);
        }
        return _resources[path];
    }

    static Future<T> _load<T>(String path, [FileFormat<T, dynamic> format = null]) {
        if(_resources.containsKey(path)) {
            throw "Resource $path has already been requested for loading";
        }

        if (format == null) {
            String extension = path.split(".").last;
            format = Formats.getFormatForExtension(extension);
        }

        Resource<T> res = _createResource(path);

        format.requestObjectFromUrl(PathUtils.adjusted(path))..then((T item) => res.populate(item));

        return res.addListener();
    }

    static Future<bool> _loadBundle(String path) async {
        print(path);
        Archive bundle = await Loader.getResource("$path.bundle", bypassManifest: true);

        String dir = path.substring(0, path.lastIndexOf("/"));

        for (ArchiveFile file in bundle.files) {
            String extension = file.name.split(".").last;
            FileFormat<dynamic, dynamic> format = Formats.getFormatForExtension(extension);

            String fullname = "$dir/${file.name}";
            print(fullname);

            Resource<dynamic> res = _createResource(fullname);

            Uint8List data = file.content as Uint8List;

            print(data.sublist(0,8));

            format.read(await format.fromBytes(data.buffer)).then(res.populate);
        }

        return true;
    }
}