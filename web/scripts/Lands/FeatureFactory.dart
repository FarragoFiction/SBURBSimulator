import "FeatureTypes/ConsortFeature.dart";
/// just has a bunch of static references for features, created in a static initalizer
class FeatureFactory {
    //TODO also have skeletal versions of some consorts. not a flag, say Salamander, cuz is different and doesn't preclude living salamanders
    static ConsortFeature SALAMANDER;
    static ConsortFeature CROCODILE;
    static ConsortFeature IGUANA;
    static ConsortFeature TURTLE;

    static initializeFeatures() {
        SALAMANDER = new ConsortFeature("Salamander", "GLUB");
        CROCODILE = new ConsortFeature("Crocodile", "NAK");
        IGUANA = new ConsortFeature("Iguana", "thip");
        TURTLE = new ConsortFeature("Turtle", "...");
    }
}