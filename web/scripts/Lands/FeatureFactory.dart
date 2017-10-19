import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "../random.dart";
import "Feature.dart";
import "FeatureHolder.dart";
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
    static ConsortFeature DRAGONCONSORT;
    static ConsortFeature SKELETONCONSORT;
    static ConsortFeature BIRDCONSORT;
    static ConsortFeature WOLFCONSORT;
    static ConsortFeature ROBOTCONSORT;
    static CarapaceFeature PROSPITIANCARAPACE;
    static CarapaceFeature DERSECARAPACE;

    static Iterable<ConsortFeature> RANDOM_CONSORTS;

    /////////////////////SMELLS////////////////////////
    static SmellFeature SPICYSMELL;
    static SmellFeature BAKEDBREADSMELL;
    static SmellFeature SWEETSMELL;
    static SmellFeature ROTSMELL;
    static SmellFeature OILSMELL;
    static SmellFeature SALTSMELL;
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
    static AmbianceFeature CONTEMPLATATIVEFEELING;
    static AmbianceFeature FRANTICFEELING;
    static AmbianceFeature NOTHINGFEELING;
    static AmbianceFeature ENERGIZINGFEELING;
    static AmbianceFeature HAPPYFEELING;
    static AmbianceFeature DANGEROUSFEELING;
    static AmbianceFeature CREATIVEFEELING;
    static AmbianceFeature GLAMOROUSFEELING;
    static AmbianceFeature HEROICFEELING;
    static AmbianceFeature CONFUSINGFEELING;
    static AmbianceFeature STUPIDFEELING;
    static AmbianceFeature ROMANTICFEELING;
    static AmbianceFeature LUCKYFEELING;
    static AmbianceFeature ANGRYFEELING;


    ///////////////////SOUNDS////////////////////////
    static SoundFeature CLANKINGSOUND;
    static SoundFeature LAUGHINGSOUND;
    static SoundFeature RUSTLINGSOUND;
    static SoundFeature BEEPINGSOUND;
    static SoundFeature JAZZSOUND;
    static SoundFeature ROARINGSOUND;
    static SoundFeature ECHOSOUND;
    static SoundFeature DRUMSOUND;
    static SoundFeature DISCOSOUND;
    static SoundFeature MUSICSOUND;
    static SoundFeature SINGINGSOUND;
    static SoundFeature CHANTINGSOUND;
    static SoundFeature WHISPERSOUND;
    static SoundFeature CLACKINGSOUND;
    static SoundFeature CLAPPINGSOUND;
    static SoundFeature SILENCE;
    static SoundFeature NATURESOUND;
    static SoundFeature WHISTLINGGSOUND;
    static SoundFeature CROAKINGSOUND;
    static SoundFeature PULSINGSOUND;
    static SoundFeature TICKINGSOUND;
    static SoundFeature FOOTSTEPSOUND;
    static SoundFeature GUNFIRESOUND;
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
        BIRDCONSORT = new ConsortFeature("Bird", "tweet");
        WOLFCONSORT = new ConsortFeature("Wolf", "growl");
        NEWTCONSORT = new ConsortFeature("Newt", "skitter");
        SPIDERCONSORT = new ConsortFeature("Spider", "skitter");
        CUPIDCONSORT = new ConsortFeature("Cupid", "flappa");
        DRAGONCONSORT = new ConsortFeature("Dragon", "roar");
        PROSPITIANCARAPACE = new CarapaceFeature("Prospitian", "murmur");
        DERSECARAPACE = new CarapaceFeature("Dersite", "mutter");

        RANDOM_CONSORTS = <ConsortFeature>[SNAKECONSORT, ALLIGATORCONSORT, NEWTCONSORT, SALAMANDERCONSORT, IGUANACONSORT, CROCODILECONSORT, TURTLECONSORT, CHAMELEONCONSORT, AXOLOTLCONSORT, LIZARDCONSORT];
    }

    static void iniatlizeSmells() {
        SPICYSMELL = new SmellFeature("spices");
        BAKEDBREADSMELL = new SmellFeature("fresh baked bread",Feature.GOOD);
        SWEETSMELL = new SmellFeature("sweetness",Feature.GOOD);
        NATURESMELL = new SmellFeature("nature",Feature.GOOD);
        SALTSMELL = new SmellFeature("salt");
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
        CREATIVEFEELING = new AmbianceFeature("creative",Feature.GOOD);
        LUCKYFEELING = new AmbianceFeature("lucky");
        HAPPYFEELING = new AmbianceFeature("happy");
        HEROICFEELING = new AmbianceFeature("heroic");
        STUPIDFEELING = new AmbianceFeature("stupid", Feature.BAD);
        LUCKYFEELING = new AmbianceFeature("lucky");
        CONFUSINGFEELING = new AmbianceFeature("confusing", Feature.BAD);
        CONTEMPLATATIVEFEELING = new AmbianceFeature("contemplatative");
    }

    //most sounds are bad sounds
    static void initializeSounds() {
        CLANKINGSOUND = new SoundFeature("clanking");
        LAUGHINGSOUND = new SoundFeature("laughing");
        RUSTLINGSOUND = new SoundFeature("rustling", Feature.GOOD);
        SCREAMSSOUND = new SoundFeature("screaming",Feature.BAD);
        FOOTSTEPSOUND = new SoundFeature("foot steps",Feature.BAD);
        BEEPINGSOUND = new SoundFeature("beeping",Feature.BAD);
        WHISPERSOUND = new SoundFeature("whispering",Feature.BAD);
        CLACKINGSOUND = new SoundFeature("clacking");
        CLAPPINGSOUND = new SoundFeature("applause");
        JAZZSOUND = new SoundFeature("jazz");
        DISCOSOUND = new SoundFeature("disco");
        DRUMSOUND = new SoundFeature("drums");
        ECHOSOUND = new SoundFeature("echoing");
        ROARINGSOUND = new SoundFeature("roaring", Feature.BAD);
        GUNFIRESOUND = new SoundFeature("gunfire", Feature.BAD);
        MUSICSOUND = new SoundFeature("music");
        SINGINGSOUND = new SoundFeature("singing");
        CHANTINGSOUND = new SoundFeature("chanting");
        WHISTLINGGSOUND = new SoundFeature("whistling");
        NATURESOUND = new SoundFeature("nature", Feature.GOOD);
        CROAKINGSOUND = new SoundFeature("croaking");
        SILENCE = new SoundFeature("silence");
        PULSINGSOUND = new SoundFeature("pulsing");
        TICKINGSOUND = new SoundFeature("ticking");
    }

    //if no consort is specified, pick something totally illegal
    static ConsortFeature getRandomConsortFeature(Random rand) {
        return rand.pickFrom(<ConsortFeature>[SNAKECONSORT, ALLIGATORCONSORT, NEWTCONSORT, SALAMANDERCONSORT, IGUANACONSORT, CROCODILECONSORT, TURTLECONSORT, CHAMELEONCONSORT, AXOLOTLCONSORT, LIZARDCONSORT]);
    }
}

abstract class FeatureCategories {
    static FeatureTypeSubset<SmellFeature> SMELL = new FeatureTypeSubset<SmellFeature>("smell", _addIfEmpty(FeatureFactory.NOTHINGSMELL));
    static FeatureTypeSubset<SoundFeature> SOUND = new FeatureTypeSubset<SoundFeature>("sound", _addIfEmpty(FeatureFactory.SILENCE));
    static FeatureTypeSubset<AmbianceFeature> AMBIANCE = new FeatureTypeSubset<AmbianceFeature>("ambiance", _addIfEmpty(FeatureFactory.NOTHINGFEELING));
    static FeatureTypeSubset<CorruptionFeature> CORRUPTION = new FeatureTypeSubset<CorruptionFeature>("corruption");
    static FeatureTypeSubset<ConsortFeature> CONSORT = new FeatureTypeSubset<ConsortFeature>("consort", _multi(<FeatureAdjustment>[_addRandomIfEmpty(FeatureFactory.RANDOM_CONSORTS), _onlyOne]));
    static FeatureTypeSubset<DenizenFeature> DENIZEN = new FeatureTypeSubset<DenizenFeature>("denizen");
    static FeatureTypeSubset<QuestChainFeature> QUEST_CHAIN = new FeatureTypeSubset<QuestChainFeature>("quest chain");
    static FeatureTypeSubset<PreDenizenQuestChain> PRE_DENIZEN_QUEST_CHAIN = new FeatureTypeSubset<PreDenizenQuestChain>("pre denizen quest chain");
    static FeatureTypeSubset<DenizenQuestChain> DENIZEN_QUEST_CHAIN = new FeatureTypeSubset<DenizenQuestChain>("denizen quest chain");
    static FeatureTypeSubset<PostDenizenQuestChain> POST_DENIZEN_QUEST_CHAIN = new FeatureTypeSubset<PostDenizenQuestChain>("post denizen quest chain");

    static FeatureTypeSubset<MoonQuestChainFeature> MOON_QUEST_CHAIN = new FeatureTypeSubset<MoonQuestChainFeature>("moon quest chain");

    // ################## utility methods - these keep things shorter

    static FeatureAdjustment _multi(Iterable<FeatureAdjustment> adjustments) {
        return (FeatureHolder holder, WeightedIterable<Feature> category, GameEntity owner, Session session, Random rand){
            for (FeatureAdjustment adjustment in adjustments) {
                adjustment(holder, category, owner, session, rand);
            }
        };
    }

    static FeatureAdjustment _addIfEmpty(Feature feature, [double weight = 1.0]) {
        return (FeatureHolder holder, WeightedIterable<Feature> category, GameEntity owner, Session session, Random rand){
            if (category.isEmpty) {
                holder.features.add(feature, weight);
            }
        };
    }

    static FeatureAdjustment _addRandomIfEmpty(Iterable<Feature> features, [double weight = 1.0]) {
        return (FeatureHolder holder, WeightedIterable<Feature> category, GameEntity owner, Session session, Random rand){
            if (category.isEmpty) {
                holder.features.add(rand.pickFrom(features), weight);
            }
        };
    }

    static void _onlyOne(FeatureHolder holder, WeightedIterable<Feature> category, GameEntity owner, Session session, Random rand){
        holder.reduceSubsetToRandomEntry(category, rand);
    }
}

abstract class FeatureTemplates {
    static FeatureTemplate QUALIA = new FeatureTemplate()
        ..addFeatureSet(FeatureCategories.SMELL)
        ..addFeatureSet(FeatureCategories.SOUND)
        ..addFeatureSet(FeatureCategories.AMBIANCE)
        ..addFeatureSet(FeatureCategories.CORRUPTION);

    static FeatureTemplate LAND = new FeatureTemplate.from(QUALIA)
        ..addFeatureSet(FeatureCategories.CONSORT)
        ..addFeatureSet(FeatureCategories.DENIZEN)
        ..addFeatureSet(FeatureCategories.QUEST_CHAIN)
        ..addFeatureSet(FeatureCategories.PRE_DENIZEN_QUEST_CHAIN)
        ..addFeatureSet(FeatureCategories.DENIZEN_QUEST_CHAIN)
        ..addFeatureSet(FeatureCategories.POST_DENIZEN_QUEST_CHAIN);

    static FeatureTemplate MOON = new FeatureTemplate.from(QUALIA)
        ..addFeatureSet(FeatureCategories.MOON_QUEST_CHAIN)
        ..addFeatureSet(FeatureCategories.CONSORT);
}