import "BasicFormats.dart";
import "BundleManifestFormat.dart";
import "FileFormat.dart";
import "ImageFormats.dart";
import "SpriteFormat.dart";
import "ZipFormat.dart";

export "FileFormat.dart";

abstract class Formats {
    static TextFileFormat text;
    static BundleManifestFormat manifest;
    static ZipFormat zip;

    static PngFileFormat png;

    static SpriteFormat sprite;

    static void init() {
        text = new TextFileFormat();
        addMapping(text, "txt");
        addMapping(text, "vert", "x-shader/x-vertex");
        addMapping(text, "frag", "x-shader/x-fragment");

        manifest = new BundleManifestFormat();

        zip = new ZipFormat();
        addMapping(zip, "zip");
        addMapping(zip, "bundle");

        png = new PngFileFormat();
        addMapping(png, "png");
        addMapping(png, "jpg", "image/jpeg");

        sprite = new SpriteFormat();
        addMapping(sprite, "psprite");
    }

    static void addMapping<T,U>(FileFormat<T,U> format, String extension, [String mimeType = null]) {
        extensionMapping[extension] = new ExtensionMappingEntry<T,U>(format, mimeType);
        format.extensions.add(extension);
    }

    static Map<String, ExtensionMappingEntry<dynamic,dynamic>> extensionMapping = <String, ExtensionMappingEntry<dynamic,dynamic>>{};

    static ExtensionMappingEntry<T,U> getFormatEntryForExtension<T,U>(String extension) {
        if (extensionMapping.containsKey(extension)) {
            ExtensionMappingEntry<T,U> mapping = extensionMapping[extension];
            FileFormat<T,U> format = mapping.format;
            if (format is FileFormat<T,U>) {
                return mapping;
            }
            throw "File format for extension .$extension does not match expected types.";
        }
        throw "No file format found for extension .$extension";
    }

    static FileFormat<T,U> getFormatForExtension<T,U>(String extension) => getFormatEntryForExtension(extension).format;
    static String getMimeTypeForExtension(String extension) => getFormatEntryForExtension(extension).mimeType;
}

class ExtensionMappingEntry<T,U> {
    FileFormat<T,U> format;
    String mimeType;

    ExtensionMappingEntry(FileFormat<T,U> this.format, String this.mimeType);
}