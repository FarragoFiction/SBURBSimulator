import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "../random.dart";
import "Feature.dart";
import "../SBURBSim.dart";
import "FeatureTypes/EnemyFeature.dart";
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
    static ConsortFeature CUPIDCONSORT;
    static ConsortFeature ALLIGATORCONSORT;
    static ConsortFeature NEWTCONSORT;
    static ConsortFeature SPIDERCONSORT;
    static ConsortFeature SKELETONCONSORT;
    static ConsortFeature ROBOTCONSORT;
    static CarapaceFeature PROSPITIANCARAPACE;
    static CarapaceFeature DERSECARAPACE;

    /////////////////////SMELLS////////////////////////
    static SmellFeature SPICYSMELL;
    static SmellFeature BAKEDBREADSMELL;
    static SmellFeature SWEETSMELL;
    static SmellFeature ROTSMELL;
    static SmellFeature OILSMELL;
    static SmellFeature NATURESMELL;
    static SmellFeature DECEITSMELL;
    static SmellFeature CHLORINESMELL; //LIKE A POOL
    static SmellFeature NOTHINGSMELL; //absence.
    static SmellFeature GUNPOWDERSMELL;
    static SmellFeature FEETSMELL;
    static SmellFeature MUSTSMELL;
    static SmellFeature ZOOSMELL;
    static SmellFeature SWEATSMELL;
    static SmellFeature OZONESMELL;
    static SmellFeature BLOODSMELL;

    ////////////////////FEELINGS//////////////////////
    static AmbianceFeature CREEPYFEELING;
    static AmbianceFeature  CALMFEELING;
    static AmbianceFeature  STUDIOUSFEELING;
    static AmbianceFeature FRANTICFEELING;
    static AmbianceFeature NOTHINGFEELING;
    static AmbianceFeature ENERGIZINGFEELING;
    static AmbianceFeature HAPPYFEELING;
    static AmbianceFeature DANGEROUSFEELING;
    static AmbianceFeature GLAMOROUSFEELING;
    static AmbianceFeature ROMANTICFEELING;


    ///////////////////SOUNDS////////////////////////
    static SoundFeature CLANKINGSOUND;
    static SoundFeature LAUGHINGSOUND;
    static SoundFeature RUSTLINGSOUND;
    static SoundFeature BEEPINGSOUND;
    static SoundFeature JAZZSOUND;
    static SoundFeature ROARINGSOUND;
    static SoundFeature DISCOSOUND;
    static SoundFeature MUSICSOUND;
    static SoundFeature WHISPERSOUND;
    static SoundFeature CLACKINGSOUND;
    static SoundFeature CLAPPINGSOUND;
    static SoundFeature SILENCE;
    static SoundFeature NATURESOUND;
    static SoundFeature WHISTLINGGSOUND;
    static SoundFeature CROAKINGSOUND;
    static SoundFeature PULSINGSOUND;
    static SoundFeature SCREAMSSOUND;  //combined with feelings this gets p interesting.  filled with the sound of screams that feels calm? energizing?

    static CorruptionFeature Corruption;

    static void init() {
        initializeConsorts();
        iniatlizeSmells();
        initializeFeelings();
        initializeSounds();
    }


    static void initializeConsorts() {
        SALAMANDERCONSORT = new ConsortFeature("Salamander", "GLUB");
        CROCODILECONSORT = new ConsortFeature("Crocodile", "NAK");
        IGUANACONSORT = new ConsortFeature("Iguana", "thip");
        TURTLECONSORT = new ConsortFeature("Turtle", "click");
        SKELETONCONSORT = new ConsortFeature("Skeleton", "rattle");
        ROBOTCONSORT = new ConsortFeature("Robot", "BEEP");
        CHAMELEONCONSORT = new ConsortFeature("Chameleon", "BLEP");
        AXOLOTLCONSORT = new ConsortFeature("Axolotl", "BARP");
        LIZARDCONSORT = new ConsortFeature("Lizard", "bleb");
        SNAKECONSORT = new ConsortFeature("Snake", "hiss");
        ALLIGATORCONSORT = new ConsortFeature("Alligator", "nak");
        NEWTCONSORT = new ConsortFeature("Newt", "skitter");
        SPIDERCONSORT = new ConsortFeature("Spider", "skitter");
        CUPIDCONSORT = new ConsortFeature("Cupid", "flappa");
        PROSPITIANCARAPACE = new CarapaceFeature("Prospitian", "murmur");
        DERSECARAPACE = new CarapaceFeature("Dersite", "mutter");
    }

    static void iniatlizeSmells() {
        SPICYSMELL = new SmellFeature("spices");
        BAKEDBREADSMELL = new SmellFeature("fresh baked bread",Feature.GOOD);
        SWEETSMELL = new SmellFeature("sweetness",Feature.GOOD);
        NATURESMELL = new SmellFeature("nature",Feature.GOOD);
        ROTSMELL = new SmellFeature("rot", Feature.BAD);
        FEETSMELL = new SmellFeature("feet", Feature.BAD);
        OILSMELL = new SmellFeature("oil");
        CHLORINESMELL = new SmellFeature("chlorine");
        NOTHINGSMELL = new SmellFeature("nothing in particular");
        GUNPOWDERSMELL = new SmellFeature("gunpowder");
        MUSTSMELL = new SmellFeature("must");
        ZOOSMELL = new SmellFeature("zoo animals", Feature.GOOD);//do you get the joke
        SWEATSMELL = new SmellFeature("sweat", Feature.BAD);
        OZONESMELL = new SmellFeature("ozone");
        DECEITSMELL = new SmellFeature("deceit");//senator lemonsnout, how COULD you?
        BLOODSMELL = new SmellFeature("blood", Feature.BAD);

    }

    //feelings effect sanity. rip eridan
    static void initializeFeelings() {
        CREEPYFEELING = new AmbianceFeature("creepy",Feature.BAD);
        CALMFEELING = new AmbianceFeature("calm",Feature.GOOD);
        FRANTICFEELING = new AmbianceFeature("frantic", Feature.BAD);
        NOTHINGFEELING = new AmbianceFeature("like nothing");
        ENERGIZINGFEELING = new AmbianceFeature("energizing",Feature.GOOD);
        STUDIOUSFEELING = new AmbianceFeature("studious");
        DANGEROUSFEELING = new AmbianceFeature("dangerous");
        GLAMOROUSFEELING = new AmbianceFeature("glamorous");
        ROMANTICFEELING = new AmbianceFeature("romantic");
        HAPPYFEELING = new AmbianceFeature("happy");
    }

    //most sounds are bad sounds
    static void initializeSounds() {
        CLANKINGSOUND = new SoundFeature("clanking");
        LAUGHINGSOUND = new SoundFeature("lauging");
        RUSTLINGSOUND = new SoundFeature("rustling", Feature.GOOD);
        SCREAMSSOUND = new SoundFeature("screaming",Feature.BAD);
        BEEPINGSOUND = new SoundFeature("beeping",Feature.BAD);
        WHISPERSOUND = new SoundFeature("whispering",Feature.BAD);
        CLACKINGSOUND = new SoundFeature("clacking");
        CLAPPINGSOUND = new SoundFeature("applause");
        JAZZSOUND = new SoundFeature("jazz");
        DISCOSOUND = new SoundFeature("disco");
        ROARINGSOUND = new SoundFeature("roaring", Feature.BAD);
        MUSICSOUND = new SoundFeature("music");
        WHISTLINGGSOUND = new SoundFeature("whistling");
        NATURESOUND = new SoundFeature("nature", Feature.GOOD);
        CROAKINGSOUND = new SoundFeature("croaking");
        SILENCE = new SoundFeature("silence");
        PULSINGSOUND = new SoundFeature("pulsing");
    }

    //if no consort is specified, pick something totally illegal
    static ConsortFeature getRandomConsortFeature(Random rand) {
        return rand.pickFrom(<ConsortFeature>[SNAKECONSORT, ALLIGATORCONSORT, NEWTCONSORT, SALAMANDERCONSORT, IGUANACONSORT, CROCODILECONSORT, TURTLECONSORT, CHAMELEONCONSORT, AXOLOTLCONSORT, LIZARDCONSORT]);
    }
}