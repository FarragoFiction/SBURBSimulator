import "../../../SBURBSim.dart";
import "SBURBClass.dart";

class Scribe extends SBURBClass {
    Scribe() : super("Scribe", 15, false);
    @override
    List<String> levels = ["MIDNIGHT BURNER", "WRITER WATCHER", "DIARY DEAREST"];
    @override
    List<String> quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts", "playing typing themed mini games.", "saving an important piece of a riddle from a crumbling building"];
    @override
    List<String> postDenizenQuests = ["documenting the various Consorts lost to the Denizen.", "writing up a recovery plan for the Local Consorts", "figuring out the best way to explain how to recover from the ravages of Denizen"];
    @override
    List<String> handles = ["serious", "sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.5, false)
    ]);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }

}