import "../Feature.dart";

class AmbianceFeature extends Feature {
    ///flavor text, "you don't get it, my land feels really $feelsLike"  creepy, unsettling, vs peaceful, calm,
    /// is a list because different feelings can be p similar.
    List<String> feelsLike;
    /// places that feel good give you + sanity, places that don't give you - sanity
    int quality;

    AmbianceFeature(this.feelsLike, [this.quality= 0]);
}