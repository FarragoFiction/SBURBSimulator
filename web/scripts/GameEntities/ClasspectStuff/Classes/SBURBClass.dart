import "../../../SBURBSim.dart";
import "Bard.dart";
import 'Dame.dart';
import "Grace.dart";
import "Guide.dart";
import "Heir.dart";
import "Knight.dart";
import "Mage.dart";
import "Maid.dart";
import 'Muse.dart';
import "Page.dart";
import "Prince.dart";
import "Reve.dart";
import "Rogue.dart";
import "Sage.dart";
import "Scout.dart";
import "Scribe.dart";
import "Seer.dart";
import "Sylph.dart";
import "Thief.dart";
import "Waste.dart";
import "Witch.dart";
import "Lord.dart";
import "Writ.dart";

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
    static SBURBClass LORD;
    static SBURBClass MUSE;
    static SBURBClass DAME;
    static SBURBClass REVE;
    static SBURBClass WRIT;

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
        REVE = new Reve();
        WRIT = new Writ();
        LORD = new Lord();
        MUSE = new Muse();
        DAME = new Dame();
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

    String name = "Null";
    //based on strength of association.
    Map<Theme, double> themes = new Map<Theme, double>();
    String savedName;  //for AB restoring an aspects name after a hope player fucks it up
    FAQFile faqFile;
    int id = 256; //for classNameToInt
    bool isCanon = false; //you gotta earn canon, baby.
    bool isInternal = false; //if you're an internal aspect or class you shouldn't show up in lists.


    SBURBClass(this.name, this.id, this.isCanon,{ this.isInternal = false}) {
        this.savedName = name;
        faqFile = new FAQFile("Classes/$name.xml");
        //print("Making a sburb class ${this.name}");
        initializeThemes();
        SBURBClassManager.addClass(this);
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

    bool isActive() {
        return false;
    }

    bool hasInteractionEffect() {
        return false;
    }

    String interactionFlavorText(GameEntity me, GameEntity target) {
        Relationship r = me.getRelationshipWith(target);
        //only time clones or similar should have no relationships
        if(r == null) return "The ${me.htmlTitle()} is kind of weirded out being around their clone.}.";
        if(r.value >= 0) {
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
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            , Theme.HIGH);
        addTheme(new Theme(<String>["Factories", "Manufacture", "Assembly Lines"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW),
            Theme.MEDIUM);

        addTheme(new Theme(<String>["Peace","Tranquility","Rest"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM),
            Theme.MEDIUM); // end theme
    }

    @override
    String toString() => this.name;
}