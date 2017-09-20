class TarManifest {
    Map<String,String> _fileToTar = <String,String>{};
    Map<String,Set<String>> _tarToFile = <String,Set<String>>{};

    void add(String file, String tar) {
        _fileToTar[file] = tar;

        if (!_tarToFile.containsKey(tar)) {
            _tarToFile[tar] = new Set<String>();
        }

        _tarToFile[tar].add(file);
    }

    List<String> getFilesInTar(String tar) {
        if (!_tarToFile.containsKey(tar)) { return null; }
        return _tarToFile[tar].toList();
    }

    String getTarForFile(String file) {
        if (!_fileToTar.containsKey(file)) { return null; }
        return _fileToTar[file];
    }

    Iterable<String> get tarFiles => _tarToFile.keys;
}