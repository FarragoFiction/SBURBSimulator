import "../Feature.dart";

class SmellFeature extends Feature {
    ///flavor text, "the smell of $smellsLike permeates the air"
    /// a single string, not a list since smell is very specific
    String smellsLike;
    /// p self explanatory.
    int quality;

    SmellFeature(this.smellsLike, [this.quality = 0]);
}