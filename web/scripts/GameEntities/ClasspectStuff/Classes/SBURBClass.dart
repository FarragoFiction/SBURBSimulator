import "../../../SBURBSim.dart";
import "Bard.dart";
import "Grace.dart";
import "Guide.dart";
import "Heir.dart";
import "Knight.dart";
import "Mage.dart";
import "Maid.dart";
import "Page.dart";
import "Prince.dart";
import "Rogue.dart";
import "Sage.dart";
import "Scout.dart";
import "Scribe.dart";
import "Seer.dart";
import "Sylph.dart";
import "Smith.dart";
import "Thief.dart";
import "Waste.dart";
import "Witch.dart";
import "Muse.dart";
import "Lord.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class SBURBClassManager {
    static SBURBClass KNIGHT;
    static SBURBClass SEER;
    static SBURBClass BARD;
    static SBURBClass HEIR;
    static SBURBClass MAID;
    static SBURBClass ROGUE;
    static SBURBClass PAGE;
    static SBURBClass THIEF;
    static SBURBClass SYLPH;
    static SBURBClass PRINCE;
    static SBURBClass WITCH;
    static SBURBClass MAGE;
    static SBURBClass WASTE;
    static SBURBClass SCOUT;
    static SBURBClass SAGE;
    static SBURBClass SCRIBE;
    static SBURBClass GUIDE;
    static SBURBClass GRACE;
    static SBURBClass NULL;
    static SBURBClass MUSE;
    static SBURBClass LORD;
    static SBURBClass SMITH;

    //did you know that static attributes are lazy loaded, and so you can't access them until
    //you interact with the class? Yes, this IS bullshit, thanks for asking!
    static void init() {
        KNIGHT = new Knight();
        SEER = new Seer();
        BARD = new Bard();
        HEIR = new Heir();
        MAID = new Maid();
        ROGUE = new Rogue();
        PAGE = new Page();
        THIEF = new Thief();
        SYLPH = new Sylph();
        PRINCE = new Prince();
        WITCH = new Witch();
        MAGE = new Mage();
        WASTE = new Waste();
        SCOUT = new Scout();
        SCRIBE = new Scribe();
        SAGE = new Sage();
        GUIDE = new Guide();
        GRACE = new Grace();
        MUSE = new Muse();
        LORD = new Lord();
        SMITH = new Smith();

        NULL = new SBURBClass("Null", 255, false, isInternal:true);
    }


    static Map<int, SBURBClass> _classes = <int, SBURBClass>{}; // gets filled by class constrcutor
    static Iterable<SBURBClass> get canon => _classes.values.where((SBURBClass c) => c.isCanon);

    static Iterable<SBURBClass> get fanon => _classes.values.where((SBURBClass c) => !c.isCanon);

    static List<String> get allClassNames {
        List<String> ret = new List<String>();
        for (SBURBClass c in _classes.values) {
            ret.add(c.name); //in ruby i'd map one list to another, not sure what dart equivalent without forloop is
        }
        return ret;
    }

    static void addClass(SBURBClass c) {
        if (_classes.containsKey(c.id)) {
            throw "Duplicate class id for $c: ${c.id} is already registered for ${_classes[c.id]}.";
        }
        _classes[c.id] = c;
    }

    static Iterable<SBURBClass> get all => _classes.values.where((SBURBClass c) => !c.isInternal);

    static SBURBClass findClassWithID(num id) {
        if (_classes.isEmpty) init();
        if (_classes.containsKey(id)) {
            return _classes[id];
        }
        return NULL; // return the NULL aspect instead of null
    }

    static SBURBClass stringToSBURBClass(String id) {
        if (_classes.isEmpty) init();
        for (SBURBClass c in _classes.values) {
            if (c.name == id) return c;
        }
        return NULL;
    }
    
    static List<SBURBClass> playersToClasses(List<Player> players) {
        return new List<SBURBClass>.from(players.map((Player p) => p.class_name));
    }

}

//instantiatable for Null classes.
class SBURBClass {

    String sauceTitle = "Glitch";
    //what sort of quests rewards do I get?
    double itemWeight = 0.01;
    double fraymotifWeight = 0.01;
    double companionWeight = 0.01;

    List<String> bureaucraticBullshit = new List<String>();

    List<String> associatedScenes = <String>[];

    //difficulty of class + aspect results in odds of getting yaldobooger/abraxus equivlent.
    //.5 is normal. .5 + .5 = 1.0, equals 5% chance of  getting either (>95 or < 5)
    double difficulty = 0.5;
    String name = "Null";
    //based on strength of association.
    Map<Theme, double> themes = new Map<Theme, double>();
    String savedName;  //for AB restoring an aspects name after a hope player fucks it up
    FAQFile faqFile;
    int id = 256; //for classNameToInt
    bool isCanon = false; //you gotta earn canon, baby.
    bool isInternal = false; //if you're an internal aspect or class you shouldn't show up in lists.

    //for quests and shit, assume canon classes pick ONE of these and fanon can pick two
    bool isProtective = false;
    bool isSmart = false;
    bool isSneaky = false;
    bool isMagical = false;
    bool isDestructive = false;
    bool isHelpful = false;

    //starting items, quest rewards, etc.
    WeightedList<Item> items = new WeightedList<Item>();


    SBURBClass(this.name, this.id, this.isCanon,{ this.isInternal = false}) {
        this.savedName = name;
        faqFile = new FAQFile("Classes/$name.xml");
        //;
        initializeItems();
        initializeThemes();
        SBURBClassManager.addClass(this);
    }

    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Perfectly Generic Object",<ItemTrait>[],shogunDesc: "Green Version of Those Sweet Yellow Candies I Loved"));
    }

    void processCard() {

    }


    List<String> levels = <String>["SNOWMAN SAVIOR", "NOBODY NOWHERE", "NULLZILLA"];
    List<String> quests = <String>["definitely doing class related quests", "solving consorts problems in a class themed manner", "absolutely not goofing off"];
    List<String> postDenizenQuests = <String>["cleaning up after their Denizen in a class approrpiate fashion", "absolutly not goofing off instead of cleaing up after their Denizen", "vaguely sweeping up rubble"];
    List<String> handles = <String>["nothing", "never", "mysterious", "nebulous", "null", "missing", "negative"];

    ///none by default.  and in fact only sburblore should be here.
    List<AssociatedStat> stats = <AssociatedStat>[];


    void addTheme(Theme t, double weight) {
        themes[t] = weight;
    }

    /// Perma-buffs for modifying stat growth and distribution - page growth curve etc.
    List<Buff> statModifiers = <Buff>[];

    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    bool hasInteractionEffect() {
        return false;
    }

    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        Relationship r = me.getRelationshipWith(target);
        //only time clones or similar should have no relationships
        if(r == null && target is Player) return "The ${me.htmlTitle()} is kind of weirded out being around their clone.";
        if(r == null) return "";
        if(r.value >= 0 ) {
            return "The ${me.htmlTitle()} appears to be getting even closer to the  ${target.htmlTitle()}.";
        }else {
            return "The ${me.htmlTitle()} appears to be finding new and exciting things to hate about the  ${target.htmlTitle()}.";
        }
    }

    //players version of this method will just call class_name.method(this, target, stat);
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        //do nothing.
    }

    /// Multiplier for Player.increasePower. e.g. Pages get 5.0.
    double powerBoostMultiplier = 1.0;

    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost; //does nothing.
    }

    //These three are called by players getPVPModifier.
    double getAttackerModifier() {
        return 1.0;
    }

    double getMurderousModifier() {
        return 1.0;
    }

    double getDefenderModifier() {
        return 1.0;
    }

    bool highHinit() {
        return false;
    }

    /// Sets up associated stats for this SBURBClass.
    /// Prefer to override [stats] instead.
    void initAssociatedStats(Player player) {
        for (AssociatedStat stat in stats) {
            stat.applyToPlayer(player);
        }
    }

    //don't need to customize for classes, they already handle this shit because of their quests.
    String getQuest(Random rand, bool postDenizen) {
        if (!postDenizen) return rand.pickFrom(quests);
        return rand.pickFrom(postDenizenQuests);
    }


    void initializeThemes() {
        addTheme(new Theme(<String>["Decay","Rot","Death"])
            ..addFeature(FeatureFactory.ROTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Revive the Consorts", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s are dead. This is....really depressing, actually. "),
                new Quest("The ${Quest.PLAYER1} has found a series of intriguing block puzzles and symbols. What could it all mean? "),
                new Quest("With a satisfying CLICK, the ${Quest.PLAYER1} has solved the final block puzzle.  A wave of energy overtakes the land. There is an immediate chorus of ${Quest.CONSORTSOUND}ing.  The ${Quest.CONSORT}s are alive again!  "),
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
        addTheme(new Theme(<String>["Factories", "Manufacture", "Assembly Lines"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Produce the Goods", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have a severe shortage of gears and cogs. It is up to the ${Quest.PLAYER1} to get the assembly lines up and running again. "),
                new Quest("The ${Quest.PLAYER1} is running around and fixing all the broken down equipment. This sure is tiring! "),
                new Quest("The ${Quest.PLAYER1} is training the local ${Quest.CONSORT}s to operate the manufacturing equipment. There is ${Quest.CONSORTSOUND}ing and chaos everywhere. "),
                new Quest("The ${Quest.PLAYER1} manages to get the factories working at peak efficiency.  The gear and cog shortage is over! The ${Quest.CONSORT}s name a national holiday after the ${Quest.PLAYER1}. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PostDenizenQuestChain("Do the Teamwork", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have a severe shortage of gears and cogs. It is up to the ${Quest.PLAYER1} to get the assembly lines up and running again. "),
                new Quest("The ${Quest.PLAYER1} notices that all of the ${Quest.CONSORT}s are stepping on each others toes while working in the factory, sometimes literally. They need to learn the meaning of Teamwork! "),
                new Quest("The ${Quest.PLAYER1} grabs the ${Quest.PLAYER2} and demonstrates some simple teamwork techniques. The ${Quest.CONSORT}s begin ${Quest.CONSORTSOUND}ing in amazement. The factory is saved! "),
            ], new RandomReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)
            , Theme.MEDIUM);

        addTheme(new Theme(<String>["Peace","Tranquility","Rest"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Relax the Consorts According to Prophecy", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have been too stressed about an impending famine to relax. They vow to help however they can."),
                new Quest("The ${Quest.PLAYER1} fluffs more pillows than any other Player ever has before them. Huh, what is this ${Quest.CONSORT} ${Quest.CONSORTSOUND}ing about? A prophecy?  "),
                new Quest("The ${Quest.PLAYER1} finds the foretold RELAXING MIX TAPE and plays it for all the local ${Quest.CONSORT}s, who become so chill they do not even ${Quest.CONSORTSOUND} once. ")
            ], new RandomReward(), QuestChainFeature.playerIsFateAspect), Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Relax the Consorts", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have been too stressed about an impending famine to relax. They vow to help however they can."),
                new Quest("The ${Quest.PLAYER1} fluffs more pillows than any other Player ever has before them. "),
                new Quest("The ${Quest.PLAYER1} teaches the local ${Quest.CONSORT}s to find their chill. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.MEDIUM); // end theme
    }

    @override
    String toString() => this.name;
}