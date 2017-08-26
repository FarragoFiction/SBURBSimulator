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
import "Thief.dart";
import "Waste.dart";
import "Witch.dart";

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
        NULL = new SBURBClass("Null", 255, false);
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

    static Iterable<SBURBClass> get all => _classes.values;

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

}

//instantiatable for Null classes.
class SBURBClass {

    String name = "Null";
    FAQFile faqFile;
    int id = 256; //for classNameToInt
    bool isCanon = false; //you gotta earn canon, baby.


    SBURBClass(this.name, this.id, this.isCanon) {
        faqFile = new FAQFile("Classes/$name.xml");
        print("Making a sburb class ${this.name}");
        SBURBClassManager.addClass(this);
    }

    List<String> levels = <String>["SNOWMAN SAVIOR", "NOBODY NOWHERE", "NULLZILLA"];
    List<String> quests = <String>["definitely doing class related quests", "solving consorts problems in a class themed manner", "absolutely not goofing off"];
    List<String> postDenizenQuests = <String>["cleaning up after their Denizen in a class approrpiate fashion", "absolutly not goofing off instead of cleaing up after their Denizen", "vaguely sweeping up rubble"];
    List<String> handles = <String>["nothing", "never", "mysterious", "nebulous", "null", "missing", "negative"];

    ///none by default.  and in fact only sburblore should be here.
    List<AssociatedStat> stats = <AssociatedStat>[];

    bool isActive() {
        return false;
    }

    bool hasInteractionEffect() {
        return false;
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

    @override
    String toString() => this.name;
}