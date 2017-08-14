import "../../../SBURBSim.dart";

import "Blood.dart";
import "Breath.dart";
import "Doom.dart";
import "Heart.dart";
import "Hope.dart";
import "Life.dart";
import "Light.dart";
import "Mind.dart";
import "Rage.dart";
import "Space.dart";
import "Time.dart";
import "Void.dart";

abstract class Aspects {
    static Aspect SPACE;
    static Aspect TIME;
    static Aspect BREATH;
    static Aspect DOOM;
    static Aspect BLOOD;
    static Aspect HEART;
    static Aspect MIND;
    static Aspect LIGHT;
    static Aspect VOID;
    static Aspect RAGE;
    static Aspect HOPE;
    static Aspect LIFE;

    static Aspect NULL;

    static void init() {
        SPACE  = new Space(0);
        TIME   = new Time(1);
        BREATH = new Breath(2);
        DOOM   = new Doom(3);
        BLOOD  = new Blood(4);
        HEART  = new Heart(5);
        MIND   = new Mind(6);
        LIGHT  = new Light(7);
        VOID   = new Void(8);
        RAGE   = new Rage(9);
        HOPE   = new Hope(10);
        LIFE   = new Life(11);

        NULL   = new Aspect(256, "Null");
    }

    // ##################################################################################################

    static Map<int, Aspect> _aspects = <int, Aspect>{};

    static void register(Aspect aspect) {
        if (_aspects.containsKey(aspect.id)) {
            throw "Duplicate aspect id for $aspect: ${aspect.id} is already registered for ${_aspects[aspect.id]}.";
        }
        _aspects[aspect.id] = aspect;
    }

    static Aspect get(int id) {
        if (_aspects.containsKey(id)) {
            return _aspects[id];
        }
        return NULL; // return the NULL aspect instead of null
    }

    static Aspect getByName(String name) {
        for (Aspect aspect in _aspects.values) {
            if (aspect.name == name) {
                return aspect;
            }
        }
        return NULL;
    }

    static Iterable<Aspect> get all => _aspects.values;
    static Iterable<Aspect> get canon => _aspects.values.where((Aspect a) => a.isCanon);
    static Iterable<Aspect> get fanon => _aspects.values.where((Aspect a) => !a.isCanon);

    static Iterable<int> get ids => _aspects.keys;
    static Iterable<String> get names => _aspects.values.map((Aspect a) => a.name);
}

// ####################################################################################################################################

class Aspect {
    /// Used for OCData save/load.
    final int id;
    /// Used for string representations of the aspect.
    final String name;
    /// Only canon aspects will appear in random sessions.
    final bool isCanon;

    // ##################################################################################################
    // Tags

    /// Deadpan aspects are mentally immune to trickster mode. Heart style.
    /// true prevents a player with this aspect receiving massive relationship boosts in trickster mode.
    bool deadpan = false;
    /// ULTIMATE deadpan aspects are immune to physical trickster foolery! Doom style.
    /// true prevents a player with this aspect getting stat boosts or graphics changes in trickster mode.
    /// Should set deadpan true when setting this true or they'll still start macking on everyone!
    bool ultimateDeadpan = false;

    // ##################################################################################################
    // Values

    /// Checked against a Random.nextDouble() to determine if a quest should be aspect related.
    /// Values <= 0.0 yield no aspect quests.
    /// Values >= 1.0 yield only aspect quests.
    double aspectQuestChance = 0.5;

    /// Multiplier to Player.increasePower magnitude.
    double powerBoostMultiplier = 1.0;

    // ##################################################################################################
    // Colours

    Colour textColour = new Colour();

    // ##################################################################################################
    // Lists

    List<String> denizenNames = new List<String>.unmodifiable(<String>["ERROR 404: DENIZEN NOT FOUND"]);

    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[]);
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[]);

    List<String> denizenQuests = new List<String>.unmodifiable(<String>[]);

    // ##################################################################################################
    // Constructor

    Aspect(int this.id, String this.name, {this.isCanon = false}) {
        Aspects.register(this);
    }

    // ##################################################################################################
    // Methods

    /// Executed when a player with this aspect dies.
    /// e.g. Doom prophecies
    void onDeath(Player player) {}

    String getRandomQuest(Random rand, bool denizenDefeated) {
        return rand.pickFrom(denizenDefeated ? this.postDenizenQuests : this.preDenizenQuests);
    }

    String getDenizenQuest(Player player) {
        if(player.denizen_index > this.denizenQuests.length ){
            throw("${player.title()} denizen index too high: ${player.session.session_id}");
        }
        String quest = this.denizenQuests[player.denizen_index];
        player.denizen_index ++;
        return quest;
    }

    /// Returns an opening font tag with the class text colour.
    String fontTag() {
        return "<font color='${this.textColour.toStyleString()}'> ";
    }

    // ##################################################################################################
    // Utility

    @override
    String get toString => this.name;
}