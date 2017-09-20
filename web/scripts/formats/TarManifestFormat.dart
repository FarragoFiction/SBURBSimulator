import "../SBURBSim.dart";

import "TarManifest.dart";

class TarManifestFormat extends StringFileFormat<TarManifest> {

    @override
    String mimeType() => "text/plain";

    @override
    TarManifest read(String input) {
        List<String> lines = input.split("\n");

        TarManifest out = new TarManifest();

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
                    out.add(line.trim(), tar);
                }
            }
        }

        return out;
    }

    @override
    String write(TarManifest data) {
        StringBuffer sb = new StringBuffer()
        ..writeln(header())
        ..writeln();

        for (String tar in data.tarFiles) {
            sb.writeln(tar);
            for (String file in data.getFilesInTar(tar)) {
                sb..writeln("\t$file");
            }
            sb.writeln();
        }

        return sb.toString();
    }

    @override
    String header() => "SBURBSim tar manifest";
}
