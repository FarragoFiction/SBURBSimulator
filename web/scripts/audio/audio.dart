import "dart:async";
import "dart:html";
import "dart:web_audio";

import "../loader/loader.dart";

abstract class Audio {
    static bool _checkedFormats = false;
    static bool canPlayMP3 = false;
    static bool canPlayOgg = false;

    static final AudioContext context = new AudioContext();
    static final AudioDestinationNode output = context.destination;

    static void checkFormats() {
        if (_checkedFormats) { return; }
        _checkedFormats = true;

        AudioElement testElement = new AudioElement();

        canPlayMP3 = testElement.canPlayType("audio/mpeg") != "";
        canPlayOgg = testElement.canPlayType("audio/ogg") != "";
    }

    static Future<AudioElement> load(String path) {
        checkFormats();

        if (canPlayOgg) {
            return Loader.getResource("$path.ogg");
        } else if (canPlayMP3) {
            return Loader.getResource("$path.mp3");
        }
        throw "Browser does not support ogg or mp3, somehow?!";
    }

    static MediaElementAudioSourceNode node(AudioElement element) => context.createMediaElementSource(element);
}