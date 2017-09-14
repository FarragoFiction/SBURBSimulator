import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
/// just has a bunch of static references for features, created in a static initalizer
class FeatureFactory {
    //TODO obviously will have more of all this shit, this is just for testing

    //////////////////////CONSORTS////////////////////////
    //TODO also have skeletal versions of some consorts. not a flag, say Salamander, cuz is different and doesn't preclude living salamanders
    static ConsortFeature SALAMANDERCONSORT;
    static ConsortFeature CROCODILECONSORT;
    static ConsortFeature IGUANACONSORT;
    static ConsortFeature TURTLECONSORT;
    static ConsortFeature SKELETONCONSORT;
    static ConsortFeature ROBOTCONSORT;


    /////////////////////SMELLS////////////////////////
    static SmellFeature SPICYSMELL;
    static SmellFeature BAKEDBREADSMELL;
    static SmellFeature ROTSMELL;
    static SmellFeature OILSMELL;
    static SmellFeature NATURESMELL;

    ////////////////////FEELINGS//////////////////////
    static AmbianceFeature CREEPYFEELING;
    static AmbianceFeature  CALMFEELING;
    static AmbianceFeature FRANTICFEELING;
    static AmbianceFeature ENERGIZINGFEELING;


    ///////////////////SOUNDS////////////////////////
    static SoundFeature CLANKINGSOUND;
    static SoundFeature CHILDRENLAUGHINGSOUND;
    static SoundFeature RUSTLINGSOUND;
    static SoundFeature SCREAMSSOUND;  //combined with feelings this gets p interesting.  filled with the sound of screams that feels calm? energizing?

    static init() {
        initializeConsorts();
        iniatlizeSmells();
        initializeFeelings();
        initializeSounds();
    }

    static initializeConsorts() {
        SALAMANDERCONSORT = new ConsortFeature("Salamander", "GLUB");
        CROCODILECONSORT = new ConsortFeature("Crocodile", "NAK");
        IGUANACONSORT = new ConsortFeature("Iguana", "thip");
        TURTLECONSORT = new ConsortFeature("Turtle", "...");
        SKELETONCONSORT = new ConsortFeature("Skeleton", "rattle");
        ROBOTCONSORT = new ConsortFeature("Robot", "BEEP");
    }

    static iniatlizeSmells() {
        SPICYSMELL = new SmellFeature("spices");
        BAKEDBREADSMELL = new SmellFeature("fresh baked bread");
        NATURESMELL = new SmellFeature("nature");
        ROTSMELL = new SmellFeature("rot", false);
        OILSMELL = new SmellFeature("oil", false);

    }

    //feelings effect sanity. rip eridan
    static initializeFeelings() {
        CREEPYFEELING = new AmbianceFeature(<String>["creepy", "unsettling", "disturbing"],false);
        CALMFEELING = new AmbianceFeature(<String>["peaceful", "calm", "restful"]);
        FRANTICFEELING = new AmbianceFeature(<String>["frantic", "chaotic", "crazy"],false);
        ENERGIZINGFEELING = new AmbianceFeature(<String>["energizing", "interesting", "amazing"]);
    }

    //most sounds are bad sounds
    static initializeSounds() {
        CLANKINGSOUND = new SoundFeature("clanking");
        CHILDRENLAUGHINGSOUND = new SoundFeature("children lauging");
        RUSTLINGSOUND = new SoundFeature("rustling", true);
        SCREAMSSOUND = new SoundFeature("screams");
    }
}