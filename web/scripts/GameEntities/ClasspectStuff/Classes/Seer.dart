import "../../../SBURBSim.dart";
import "SBURBClass.dart";

class Seer extends SBURBClass {
    @override
    List<String> levels = ["SEEING iDOG", "PIPSQUEAK PROGNOSTICATOR", "SCAMPERVIEWER 5000"];
    @override
    List<String> quests = ["making the various bullshit rules of SBURB part of their personal mythos", "collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go", "suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't"];
    @override
    List<String> postDenizenQuests = ["casting their sight around the land to find the causes of their land’s devastation", "taking a consort under their wing and teaching it the craft of magic", "predicting hundreds of thousands of variant future possibilities, only to realize that the future is too chaotic to exactly systemize", "alchemizing more and more complex seer aids, such as crystal balls or space-specs"];
    @override
    List<String> handles = ["sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

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
    bool isHelpful = false;

    Seer() : super("Seer", 6, true);


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.4, false)
    ]);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 2;
        } else {
            powerBoost = powerBoost * 2.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 0.67;
    }

    @override
    double getDefenderModifier() {
        return 0.67;
    }

    @override
    double getMurderousModifier() {
        return 1.0;
    }

}