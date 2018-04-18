import "dart:web_audio";

import "../SBURBSim.dart";

class MuffleEffect implements AudioEffect {
    final AudioNode input = Audio.context.createGain();
    final AudioNode output = Audio.context.createGain();

    double _power = 1.0;

    GainNode _clean;
    GainNode _muffled;

    MuffleEffect([double power = 1.0]) {
        _power = power.clamp(0.0, 1.0);

        _clean = Audio.context.createGain()
            ..connectNode(output);
        input.connectNode(_clean);

        _muffled = Audio.context.createGain()
            ..connectNode(output);

        this.value = power;

        GainNode boost = Audio.context.createGain()..gain.value = 1.65..connectNode(_muffled);
        BiquadFilterNode lp1 = Audio.context.createBiquadFilter()..type="lowpass"..connectNode(boost);
        BiquadFilterNode lp2 = Audio.context.createBiquadFilter()..type="lowpass"..connectNode(lp1);
        BiquadFilterNode lp3 = Audio.context.createBiquadFilter()..type="lowpass"..connectNode(lp2);
        input.connectNode(lp3);
    }

    @override
    double get value => _power;
    @override
    void set value(double val) {
        _power = val;

        double clamped = val.clamp(0.0, 1.0);
        double c = 1.0 - clamped;

        double linearity = 0.3;
        double curved = ((1.0 - (c*c)) * (1.0 - linearity)) + (clamped * linearity);

        _muffled.gain.value = curved;
        _clean.gain.value = (1-curved);
    }
}