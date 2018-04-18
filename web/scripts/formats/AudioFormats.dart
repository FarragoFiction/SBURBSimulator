import 'dart:async';
import "dart:html";

import "../SBURBSim.dart";
import '../includes/path_utils.dart';

abstract class AudioFormat extends ElementFileFormat<AudioElement> {

    @override
    Future<AudioElement> read(String input) async {
        AudioElement element = new AudioElement(PathUtils.adjusted(input));
        await element.onCanPlay.first;
        return element;
    }

    @override
    Future<String> write(AudioElement data) => throw "Audio write not implemented";
}

class MP3Format extends AudioFormat {
    @override
    String mimeType() => "audio/mpeg";
}

class OggFormat extends AudioFormat {
    @override
    String mimeType() => "audio/ogg";
}