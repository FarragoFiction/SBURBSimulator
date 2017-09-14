import "../Feature.dart";

class SoundFeature extends Feature {
    ///flavor text, "is getting really tired of the sound of $soundsLike"
    /// a single string, not a list since sound is very specific
    String soundsLike;
    /// p self explanatory.
    bool goodSound;

    //most sounds are p annoying, lets face it
    SoundFeature(this.soundsLike, [this.goodSound = false]);
}