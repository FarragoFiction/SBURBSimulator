import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
/// just has a bunch of static references for features, created in a static initalizer
class FeatureFactory {
    //TODO obviously will have more of all this shit, this is just for testing

    //////////////////////CONSORTS////////////////////////
    //TODO also have skeletal versions of some consorts. not a flag, say Salamander, cuz is different and doesn't preclude living salamanders
    static ConsortFeature SALAMANDER;
    static ConsortFeature CROCODILE;
    static ConsortFeature IGUANA;
    static ConsortFeature TURTLE;
    static ConsortFeature SKELETON;


    /////////////////////SMELLS////////////////////////
    static SmellFeature SPICY;
    static SmellFeature BAKEDBREAD;
    static SmellFeature ROT;
    static SmellFeature OIL;


    ////////////////////FEELINGS//////////////////////
    static AmbianceFeature CREEPY;
    static AmbianceFeature  CALM;
    static AmbianceFeature FRANTIC;
    static AmbianceFeature ENERGIZING;


    ///////////////////SOUNDS////////////////////////
    static SoundFeature CLANKING;
    static SoundFeature CHILDRENLAUGHING;
    static SoundFeature RUSTLING;
    static SoundFeature SCREAMS;  //combined with feelings this gets p interesting.  filled with the sound of screams that feels calm? energizing?

    static init() {
        initializeConsorts();
        iniatlizeSmells();
        initializeFeelings();
        initializeSounds();
    }

    static initializeConsorts() {
        SALAMANDER = new ConsortFeature("Salamander", "GLUB");
        CROCODILE = new ConsortFeature("Crocodile", "NAK");
        IGUANA = new ConsortFeature("Iguana", "thip");
        TURTLE = new ConsortFeature("Turtle", "...");
        SKELETON = new ConsortFeature("Skeleton", "rattle");
    }

    static iniatlizeSmells() {
        SPICY = new SmellFeature("spices");
        BAKEDBREAD = new SmellFeature("fresh baked bread");
        ROT = new SmellFeature("rot", false);
        OIL = new SmellFeature("oil", false);

    }

    //feelings effect sanity. rip eridan
    static initializeFeelings() {
        CREEPY = new AmbianceFeature(<String>["creepy", "unsettling", "disturbing"],false);
        CALM = new AmbianceFeature(<String>["peaceful", "calm", "restful"]);
        FRANTIC = new AmbianceFeature(<String>["frantic", "chaotic", "crazy"],false);
        ENERGIZING = new AmbianceFeature(<String>["energizing", "interesting", "amazing"]);
    }

    //most sounds are bad sounds
    static initializeSounds() {
        CLANKING = new SoundFeature("clanking");
        CHILDRENLAUGHING = new SoundFeature("children lauging");
        RUSTLING = new SoundFeature("rustling", true);
        SCREAMS = new SoundFeature("screams");
    }
}