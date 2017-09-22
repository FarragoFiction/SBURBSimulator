import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "../random.dart";
import "Feature.dart";
import "FeatureTypes/DenizenFeature.dart";
/// just has a bunch of static references for features, created in a static initalizer
class FeatureFactory {
    //TODO obviously will have more of all this shit, this is just for testing

    //////////////////////CONSORTS////////////////////////
    //TODO also have skeletal versions of some consorts. not a flag, say Salamander, cuz is different and doesn't preclude living salamanders
    static ConsortFeature SALAMANDERCONSORT;
    static ConsortFeature CROCODILECONSORT;
    static ConsortFeature IGUANACONSORT;
    static ConsortFeature TURTLECONSORT;
    static ConsortFeature CHAMELEONCONSORT;
    static ConsortFeature AXOLOTLCONSORT;
    static ConsortFeature LIZARDCONSORT;
    static ConsortFeature SNAKECONSORT;
    static ConsortFeature ALLIGATORCONSORT;
    static ConsortFeature NEWTCONSORT;
    static ConsortFeature SKELETONCONSORT;
    static ConsortFeature ROBOTCONSORT;

    static DenizenFeature YALDABAOTHDENIZEN;


    /////////////////////SMELLS////////////////////////
    static SmellFeature SPICYSMELL;
    static SmellFeature BAKEDBREADSMELL;
    static SmellFeature ROTSMELL;
    static SmellFeature OILSMELL;
    static SmellFeature NATURESMELL;
    static SmellFeature CHLORINESMELL; //LIKE A POOL
    static SmellFeature NOTHINGSMELL; //absence.
    static SmellFeature GUNPOWDERSMELL;
    static SmellFeature FEETSMELL;
    static SmellFeature MUSTSMELL;
    static SmellFeature ZOOSMELL;

    ////////////////////FEELINGS//////////////////////
    static AmbianceFeature CREEPYFEELING;
    static AmbianceFeature  CALMFEELING;
    static AmbianceFeature  STUDIOUSFEELING;
    static AmbianceFeature FRANTICFEELING;
    static AmbianceFeature NOTHINGFEELING;
    static AmbianceFeature ENERGIZINGFEELING;


    ///////////////////SOUNDS////////////////////////
    static SoundFeature CLANKINGSOUND;
    static SoundFeature CHILDRENLAUGHINGSOUND;
    static SoundFeature RUSTLINGSOUND;
    static SoundFeature BEEPINGSOUND;
    static SoundFeature CLACKINGSOUND;
    static SoundFeature SILENCE;
    static SoundFeature NATURESOUND;
    static SoundFeature SCREAMSSOUND;  //combined with feelings this gets p interesting.  filled with the sound of screams that feels calm? energizing?

    static CorruptionFeature Corruption;

    static void init() {
        initializeConsorts();
        iniatlizeSmells();
        initializeFeelings();
        initializeSounds();
        initializeDenizens();
    }

    static void initializeDenizens() {
        YALDABAOTHDENIZEN = new DenizenFeature("Yaldabaoth", 13);
    }

    static void initializeConsorts() {
        SALAMANDERCONSORT = new ConsortFeature("Salamander", "GLUB");
        CROCODILECONSORT = new ConsortFeature("Crocodile", "NAK");
        IGUANACONSORT = new ConsortFeature("Iguana", "thip");
        TURTLECONSORT = new ConsortFeature("Turtle", "...");
        SKELETONCONSORT = new ConsortFeature("Skeleton", "rattle");
        ROBOTCONSORT = new ConsortFeature("Robot", "BEEP");
        CHAMELEONCONSORT = new ConsortFeature("Chameleon", "BLEP");
        AXOLOTLCONSORT = new ConsortFeature("Axolotl", "BARP");
        LIZARDCONSORT = new ConsortFeature("Lizard", "bleb");
        SNAKECONSORT = new ConsortFeature("Snake", "hiss");
        ALLIGATORCONSORT = new ConsortFeature("Alligator", "nak");
        NEWTCONSORT = new ConsortFeature("Newt", "skitter");
    }

    static void iniatlizeSmells() {
        SPICYSMELL = new SmellFeature("spices");
        BAKEDBREADSMELL = new SmellFeature("fresh baked bread",Feature.GOOD);
        NATURESMELL = new SmellFeature("nature",Feature.GOOD);
        ROTSMELL = new SmellFeature("rot", Feature.BAD);
        FEETSMELL = new SmellFeature("feet", Feature.BAD);
        OILSMELL = new SmellFeature("oil");
        CHLORINESMELL = new SmellFeature("chlorine");
        NOTHINGSMELL = new SmellFeature("nothing in particular");
        GUNPOWDERSMELL = new SmellFeature("gunpowder");
        MUSTSMELL = new SmellFeature("must");
        ZOOSMELL = new SmellFeature("zoo animals", Feature.GOOD);//do you get the joke

    }

    //feelings effect sanity. rip eridan
    static void initializeFeelings() {
        CREEPYFEELING = new AmbianceFeature("creepy",Feature.BAD);
        CALMFEELING = new AmbianceFeature("calm",Feature.GOOD);
        FRANTICFEELING = new AmbianceFeature("frantic", Feature.BAD);
        NOTHINGFEELING = new AmbianceFeature("like nothing");
        ENERGIZINGFEELING = new AmbianceFeature("energizing",Feature.GOOD);
        STUDIOUSFEELING = new AmbianceFeature("studious");
    }

    //most sounds are bad sounds
    static void initializeSounds() {
        CLANKINGSOUND = new SoundFeature("clanking");
        CHILDRENLAUGHINGSOUND = new SoundFeature("children lauging");
        RUSTLINGSOUND = new SoundFeature("rustling", Feature.GOOD);
        SCREAMSSOUND = new SoundFeature("screaming",Feature.BAD);
        BEEPINGSOUND = new SoundFeature("beeping",Feature.BAD);
        CLACKINGSOUND = new SoundFeature("clacking");
        NATURESOUND = new SoundFeature("nature", Feature.GOOD);
        SILENCE = new SoundFeature("silence");
    }

    //if no consort is specified, pick something totally illegal
    static ConsortFeature getRandomConsortFeature(Random rand) {
        return rand.pickFrom(<ConsortFeature>[SNAKECONSORT, ALLIGATORCONSORT, NEWTCONSORT, SALAMANDERCONSORT, IGUANACONSORT, CROCODILECONSORT, TURTLECONSORT, CHAMELEONCONSORT, AXOLOTLCONSORT, LIZARDCONSORT]);
    }
}