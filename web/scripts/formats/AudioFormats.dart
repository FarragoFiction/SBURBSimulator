import 'dart:async';
import "dart:html";
import "dart:typed_data";
import "dart:web_audio";

import "../SBURBSim.dart";

abstract class AudioFormat extends BinaryFileFormat<AudioBufferSourceNode> {
    @override
    Future<AudioBufferSourceNode> read(ByteBuffer input) async {
        AudioBufferSourceNode node = Audio.context.createBufferSource();
        node.buffer = await Audio.context.decodeAudioData(input);
        return node;
    }

    @override
    Future<ByteBuffer> write(AudioBufferSourceNode data) => throw "Audio saving not yet implemented";
}

class MP3Format extends AudioFormat {
    @override
    String mimeType() => "audio/mpeg";

    @override
    String header() => null;
}

class OggFormat extends AudioFormat {
    @override
    String mimeType() => "audio/ogg";

    @override
    String header() => null;
}

// streamed versions, good for music and stuff where exact timings aren't 100% necessary

abstract class StreamedAudioFormat extends ElementFileFormat<AudioElement> {

    @override
    Future<AudioElement> read(String input) async {
        AudioElement element = new AudioElement(input);
        await element.onCanPlayThrough.first;
        return element;
    }

    @override
    Future<String> write(AudioElement data) => throw "Audio write not implemented";
}

class StreamedMP3Format extends StreamedAudioFormat {
    @override
    String mimeType() => "audio/mpeg";
}

class StreamedOggFormat extends StreamedAudioFormat {
    @override
    String mimeType() => "audio/ogg";
}