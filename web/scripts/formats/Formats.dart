import "BasicFormats.dart";
import "FileFormat.dart";
import "ImageFormats.dart";
import "ZipFormat.dart";
import "BundleManifestFormat.dart";

export "FileFormat.dart";

abstract class Formats {
    static TextFileFormat text;
    static BundleManifestFormat manifest;
    static ZipFormat zip;

    static PngFileFormat png;

    static void init() {
        text = new TextFileFormat();
        addMapping(text, "txt");

        manifest = new BundleManifestFormat();

        zip = new ZipFormat();
        addMapping(zip, "zip");
        addMapping(zip, "bundle");

        png = new PngFileFormat();
        addMapping(png, "png");
        addMapping(png, "jpg");
    }

    static void addMapping(FileFormat<dynamic,dynamic> format, String extension) {
        extensionMapping[extension] = format;
        format.extensions.add(extension);
    }

    static Map<String, FileFormat<dynamic,dynamic>> extensionMapping = <String, FileFormat<dynamic,dynamic>>{};

    static FileFormat<T,U> getFormatForExtension<T,U>(String extension) {
        if (extensionMapping.containsKey(extension)) {
            FileFormat<dynamic, dynamic> format = extensionMapping[extension];
            if (format is FileFormat<T,U>) {
                return format;
            }
            throw "File format for extension .$extension does not match expected types ($T, $U)";
        }
        throw "No file format found for extension .$extension";
    }
}