import "../../GameEntity.dart";
import "SBURBClass.dart";

class Page extends SBURBClass {
    Page() : super("Page", 1, true);
    @override
    List<String> levels = ["APPRENTICE ANKLEBITER", "JOURNEYING JUNIOR", "OUTFOXED BUCKAROO"];
    @override
    List<String> quests = ["going on various quests of self discovery and confidence building", "partnering with a local consort hero to do great deeds and slay evil foes", "learning to deal with disapointment after dungeon after dungeon proves to have all the enemies, and none of the treasure"];
    @override
    List<String> postDenizenQuests = ["learning to control their newfound prowess, accidentally wiping out a consort village or two", "getting all mopey about their new powers, because apparently actually being competent is too much for them", "finishing the ‘legendary’ tests of valor with a never before seen aplomb", "accepting the role Sburb has placed upon them. They are themselves, and that is all that needs be said on the matter"];
    @override
    List<String> handles =  ["passionate","patient","peaceful","perfect","perceptive", "practical", "pathetic"];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 2;
        } else {
            powerBoost = powerBoost * 0.5;
        }
        return powerBoost;
    }

    @override
    double powerBoostMultiplier = 2.0; //they don't have many quests, but once they get going they are hard to stop.
}