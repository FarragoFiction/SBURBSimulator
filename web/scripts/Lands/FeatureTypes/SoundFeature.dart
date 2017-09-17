import "../Feature.dart";

class SoundFeature extends Feature {
    ///flavor text, "is getting really tired of the sound of $soundsLike"
    /// a single string, not a list since sound is very specific
    /// p self explanatory.


    //most sounds are p annoying, lets face it
    SoundFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);
}