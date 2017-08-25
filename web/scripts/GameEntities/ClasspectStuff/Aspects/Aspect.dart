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
import "Spark.dart";
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
    static Aspect SPARK;

    static Aspect NULL;

    static void init() {
        SPACE = new Space(0);
        TIME = new Time(1);
        BREATH = new Breath(2);
        DOOM = new Doom(3);
        BLOOD = new Blood(4);
        HEART = new Heart(5);
        MIND = new Mind(6);
        LIGHT = new Light(7);
        VOID = new Void(8);
        RAGE = new Rage(9);
        HOPE = new Hope(10);
        LIFE = new Life(11);
        SPARK = new Spark(12);

        NULL = new Aspect(255, "Null");
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
        if (_aspects.isEmpty) init();
        if (_aspects.containsKey(id)) {
            return _aspects[id];
        }
        return NULL; // return the NULL aspect instead of null
    }

    static Aspect getByName(String name) {
        if (_aspects.isEmpty) init();
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

    static Aspect stringToAspect(String id) {
        List<Aspect> values = new List<Aspect>.from(_aspects.values);
        for (Aspect a in values) {
            if (a.name == id) return a;
        }
        return NULL;
    }
}

// ####################################################################################################################################

class Aspect {
    /// Used for OCData save/load.
    final int id;
    FAQFile faqFile;

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

    /// Do god-tier trolls of this aspect have wings?
    bool trollWings = true;

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

    AspectPalette palette = new AspectPalette()
        ..accent = '#FF9B00'
        ..aspect_light = '#FF9B00'
        ..aspect_dark = '#FF8700'
        ..shoe_light = '#7F7F7F'
        ..shoe_dark = '#727272'
        ..cloak_light = '#A3A3A3'
        ..cloak_mid = '#999999'
        ..cloak_dark = '#898989'
        ..shirt_light = '#EFEFEF'
        ..shirt_dark = '#DBDBDB'
        ..pants_light = '#C6C6C6'
        ..pants_dark = '#ADADAD';

    // ##################################################################################################
    // Lists

    //TODO maybe eventually quest lines are in charge of levels, so two pages of breath with the same interest don't have exact same ladder?
    List<String> levels = new List<String>.unmodifiable(<String>[
        "SNOWMAN SAVIOR",
        "NOBODY NOWHERE",
        "NULLZILLA"
    ]);
    List<String> denizenNames = new List<String>.unmodifiable(<String>[
        "ERROR 404: DENIZEN NOT FOUND"
    ]);
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>[
        "Blank",
        "Null",
        "Boring",
        "Error"
    ]);
    List<String> landNames = new List<String>.unmodifiable(<String>[
        "Blank",
        "Null",
        "Boring",
        "Error"
    ]);
    String denizenSongTitle = "Song";
    String denizenSongDesc = "A static sound is heard. It is the one Forgetfulness uses to cover the lacunae. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And there's nothing else to say on the matter. ";
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "definitely doing class related quests",
        "solving consorts problems in a class themed manner",
        "absolutely not goofing off"
    ]);
    List<String> handles = new List<String>.unmodifiable(
        <String>["Null", "Nothing", "Mystery"]);
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "cleaning up after their Denizen in a class approrpiate fashion",
        "absolutly not goofing off instead of cleaing up after their Denizen",
        "vaguely sweeping up rubble"
    ]);

    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "learning of how the Denizen destroyed their land",
        "begining to oppose the damage the Denizen has done to the land",
        "preparing to challeng their Denizen to prevent future damage"
    ]);

    /// DO NOT transfer these directly to a Player - they may not be valid for use and require processing!
    /// Use initAssociatedStats for adding stats to a Player!
    List<AssociatedStat> stats = <AssociatedStat>[];

    // ##################################################################################################
    // Constructor

    Aspect(int this.id, String this.name, {this.isCanon = false}) {
        faqFile = new FAQFile("Aspects/${name}.xml");
        Aspects.register(this);
    }

    // ##################################################################################################
    // Methods

    /// Sets up associated stats for this Aspect
    /// Prefer to override [stats] instead.
    void initAssociatedStats(Player player) {
        for (AssociatedStat stat in stats) {
            stat.applyToPlayer(player);
        }
    }

    /// Executed when a player with this aspect dies.
    /// e.g. Doom prophecies
    void onDeath(Player player) {}

    String getRandomQuest(Random rand, bool denizenDefeated) {
        return rand.pickFrom(denizenDefeated ? this.postDenizenQuests : this.preDenizenQuests);
    }

    String getDenizenQuest(Player player) {
        if (player.denizen_index > this.denizenQuests.length) {
            throw("${player.title()} denizen index too high: ${player.session.session_id}");
        }
        String quest = this.denizenQuests[player.denizen_index];
        player.denizen_index ++;
        return quest;
    }

    /// Returns an opening font tag with the class text colour.
    String fontTag() {
        return "<font color='${this.palette.text.toStyleString()}'> ";
    }

    // ##################################################################################################
    // Utility

    @override
    String toString() => this.name;
}

/// Convenience class for getting/setting aspect palettes
class AspectPalette extends Palette {
    static String _ACCENT = "accent";
    static String _ASPECT_LIGHT = "aspect1";
    static String _ASPECT_DARK = "aspect2";
    static String _SHOE_LIGHT = "shoe1";
    static String _SHOE_DARK = "shoe2";
    static String _CLOAK_LIGHT = "cloak1";
    static String _CLOAK_MID = "cloak2";
    static String _CLOAK_DARK = "cloak3";
    static String _SHIRT_LIGHT = "shirt1";
    static String _SHIRT_DARK = "shirt2";
    static String _PANTS_LIGHT = "pants1";
    static String _PANTS_DARK = "pants2";

    static Colour _handleInput(Object input) {
        if (input is Colour) {
            return input;
        }
        if (input is int) {
            return new Colour.fromHex(input, input
                .toRadixString(16)
                .padLeft(6, "0")
                .length > 6);
        }
        if (input is String) {
            if (input.startsWith("#")) {
                return new Colour.fromStyleString(input);
            } else {
                return new Colour.fromHexString(input);
            }
        }
        throw "Invalid AspectPalette input: colour must be a Colour object, a valid colour int, or valid hex string (with or without leading #)";
    }

    Colour get text => this[_ACCENT];

    Colour get accent => this[_ACCENT];

    void set accent(dynamic c) => this.add(_ACCENT, _handleInput(c), true);

    Colour get aspect_light => this[_ASPECT_LIGHT];

    void set aspect_light(dynamic c) => this.add(_ASPECT_LIGHT, _handleInput(c), true);

    Colour get aspect_dark => this[_ASPECT_DARK];

    void set aspect_dark(dynamic c) => this.add(_ASPECT_DARK, _handleInput(c), true);

    Colour get shoe_light => this[_SHOE_LIGHT];

    void set shoe_light(dynamic c) => this.add(_SHOE_LIGHT, _handleInput(c), true);

    Colour get shoe_dark => this[_SHOE_DARK];

    void set shoe_dark(dynamic c) => this.add(_SHOE_DARK, _handleInput(c), true);

    Colour get cloak_light => this[_CLOAK_LIGHT];

    void set cloak_light(dynamic c) => this.add(_CLOAK_LIGHT, _handleInput(c), true);

    Colour get cloak_mid => this[_CLOAK_MID];

    void set cloak_mid(dynamic c) => this.add(_CLOAK_MID, _handleInput(c), true);

    Colour get cloak_dark => this[_CLOAK_DARK];

    void set cloak_dark(dynamic c) => this.add(_CLOAK_DARK, _handleInput(c), true);

    Colour get shirt_light => this[_SHIRT_LIGHT];

    void set shirt_light(dynamic c) => this.add(_SHIRT_LIGHT, _handleInput(c), true);

    Colour get shirt_dark => this[_SHIRT_DARK];

    void set shirt_dark(dynamic c) => this.add(_SHIRT_DARK, _handleInput(c), true);

    Colour get pants_light => this[_PANTS_LIGHT];

    void set pants_light(dynamic c) => this.add(_PANTS_LIGHT, _handleInput(c), true);

    Colour get pants_dark => this[_PANTS_DARK];

    void set pants_dark(dynamic c) => this.add(_PANTS_DARK, _handleInput(c), true);
}