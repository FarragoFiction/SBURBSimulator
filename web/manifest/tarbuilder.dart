import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:archive/archive_io.dart";

String relPath = "web/";
RegExp slash = new RegExp("[\\/]");

void main() {
    process();
}

Future<bool> process() async {
    Map<String, Set<String>> sourceManifest = readManifest(await readSource());

    print(sourceManifest);

    Map<String, Set<String>> manifest = <String, Set<String>>{};

    for (String tar in sourceManifest.keys) {
        Set<String> files = sourceManifest[tar];

        int split = tar.lastIndexOf(slash)+1;
        String dir = tar.substring(0, split);

        String remdir = "$relPath$dir";

        for (String pattern in files) {
            RegExp p = new RegExp(pattern);

            Directory directory = new Directory(remdir);
            List<FileSystemEntity> entries = directory.listSync(recursive:true);

            List<FileSystemEntity> matching = entries.where((FileSystemEntity f) {
                return (f is File) && p.hasMatch(f.path.split(slash).last);
            }).toList();

            if (!manifest.containsKey(tar)) {
                manifest[tar] = new Set<String>();
            }

            for (FileSystemEntity f in matching) {
                String name = f.path.substring(remdir.length);

                manifest[tar].add(name);
            }
        }
    }

    List<String> output = writeManifest(manifest);
    writeManifestFile(output);

    for (String tar in manifest.keys) {
        writeTar(tar, manifest[tar]);
    }

    return true;
}

Future<List<String>> readSource() async {
    Completer<List<String>> callback = new Completer<List<String>>();
    final File smfile = new File("${relPath}manifest/sourcemanifest.txt");

    List<String> sourcelines = <String>[];
    smfile.openRead()
        .transform(UTF8.decoder)
        .transform(new LineSplitter())
        .listen(sourcelines.add, onDone: () => callback.complete(sourcelines));

    return callback.future;
}

void writeManifestFile(List<String> lines) {
    final File manifest = new File("${relPath}manifest/manifest.txt");

    IOSink writer = manifest.openWrite();

    for (String line in lines) {
        writer.writeln(line);
    }

    writer.close();
}

Map<String,Set<String>> readManifest(List<String> lines) {
    Map<String, Set<String>> data = <String, Set<String>>{};

    String tar = null;

    for (int i=1; i<lines.length; i++) {
        String line = lines[i];

        if (line.isEmpty) {
            // empty line, not in a block
            tar = null;
        } else {
            if (tar == null) {
                // first non-empty, set tar
                tar = line.trim();
            } else {
                // subsequent non-empty, add to category
                if (!data.containsKey(tar)) {
                    data[tar] = new Set<String>();
                }

                data[tar].add(line.trim());
            }
        }
    }

    return data;
}

List<String> writeManifest(Map<String,Set<String>> data) {
    List<String> lines = <String>[];

    lines..add("SBURBSim Tar Manifest")..add("");

    for (String tar in data.keys) {
        lines.add(tar);
        for (String file in data[tar]) {
            lines.add("    $file");
        }
        lines.add("");
    }

    return lines;
}

void writeTar(String path, Iterable<String> files) {
    TarFileEncoder encoder = new TarFileEncoder();

    String dirpath = "$relPath${path.substring(0,path.lastIndexOf(slash)+1)}";
    String fullpath = "$relPath$path.tar";

    encoder.open(fullpath);

    for (String file in files) {
        encoder.addFile(new File("$dirpath$file"), file);
    }

    encoder.close();
}