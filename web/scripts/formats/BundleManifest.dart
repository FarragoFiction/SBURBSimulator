class BundleManifest {
    Map<String,String> _fileToBundle = <String,String>{};
    Map<String,Set<String>> _bundleToFile = <String,Set<String>>{};

    static RegExp _slash = new RegExp("[\\/]");

    void add(String file, String bundle) {
        String bundlepath = bundle.substring(0, bundle.lastIndexOf(_slash)+1);
        file = "$bundlepath$file";

        _fileToBundle[file] = bundle;

        if (!_bundleToFile.containsKey(bundle)) {
            _bundleToFile[bundle] = new Set<String>();
        }

        _bundleToFile[bundle].add(file);
    }

    List<String> getFilesInBundle(String bundle) {
        if (!_bundleToFile.containsKey(bundle)) { return null; }
        return _bundleToFile[bundle].toList();
    }

    String getBundleForFile(String file) {
        if (!_fileToBundle.containsKey(file)) { return null; }
        return _fileToBundle[file];
    }

    Iterable<String> get bundleFiles => _bundleToFile.keys;
}