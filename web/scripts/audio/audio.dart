import "dart:async";
import "dart:html";
import "dart:web_audio";

import '../formats/Formats.dart';
import "../loader/loader.dart";

export "muffleEffect.dart";

abstract class Audio {
    static bool _checkedFormats = false;
    static bool canPlayMP3 = false;
    static bool canPlayOgg = false;

    static final AudioContext context = new AudioContext();
    static final GainNode output = context.createGain()..connectNode(context.destination);
    static final AudioParam masterVolume = output.gain;

    static void checkFormats() {
        if (_checkedFormats) { return; }
        _checkedFormats = true;

        AudioElement testElement = new AudioElement();

        canPlayMP3 = testElement.canPlayType("audio/mpeg") != "";
        canPlayOgg = testElement.canPlayType("audio/ogg") != "";
    }

    static Future<AudioBufferSourceNode> load(String path) {
        checkFormats();

        if (canPlayOgg) {
            return Loader.getResource("$path.ogg");
        } else if (canPlayMP3) {
            return Loader.getResource("$path.mp3");
        }
        throw "Browser does not support ogg or mp3, somehow?!";
    }

    static Future<AudioElement> loadStreamed(String path) {
        checkFormats();

        if (canPlayOgg) {
            return Loader.getResource("$path.ogg", format: Formats.oggStreamed);
        } else if (canPlayMP3) {
            return Loader.getResource("$path.mp3", format: Formats.mp3Streamed);
        }
        throw "Browser does not support ogg or mp3, somehow?!";
    }

    static MediaElementAudioSourceNode node(AudioElement element) => context.createMediaElementSource(element);

    static InputElement slider(dynamic param, [double min = 0.0, double max = 1.0, double increment = 0.01]) {
        if (!(param is AudioParam || param is AudioEffect )) {
            throw "Unsupported type for Audio.slider, should be an AudioParam or AudioEffect";
        }

        InputElement s = new RangeInputElement()
            ..min = min.toString()
            ..max = max.toString()
            ..step = increment.toString()
            ..valueAsNumber = param.value.clamp(min,max);

        s.onInput.listen((Event e) {
            param.value = s.valueAsNumber.toDouble();
        });
        s.onChange.listen((Event e) {
            param.value = s.valueAsNumber.toDouble();
        });

        return s;
    }
}

abstract class AudioEffect {
    double value;
}
