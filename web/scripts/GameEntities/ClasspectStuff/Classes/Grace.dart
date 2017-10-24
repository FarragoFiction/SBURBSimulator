import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Grace extends SBURBClass {
    @override
    List<String> levels = <String>["KNEEHIGH ROBINHOOD", "DASHING DARTABOUT", "COMMUNIST COMMANDER"];
    @override
    List<String> handles = <String>["graceful", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    Grace() : super("Grace", 17, false);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 3.0, false) //basically all Wastes have.
    ]);


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.isFromAspect || stat.stat != Stats.SBURB_LORE) {
            powerBoost = powerBoost * 0; //wasted aspect
        } else {
            powerBoost = powerBoost * 1;
        }
        return powerBoost;
    }

    //graces are a slow, poisonous disaster. passive counterpart to wastes.
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Ice","Tundra", "Snow", "Frost","Flurries","Avalanches"])
            ..addFeature(FeatureFactory.WOLFCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Cooking with Petrol", [
                new Quest("The ${Quest.PLAYER1} wanders the countryside looking for any quests still active after the defeat of the ${Quest.DENIZEN}. After defeating a boringly easy dungeon, it rumbles and descends into the ground. The ground rumbles ominously. "),
                new Quest("The ${Quest.PLAYER1} is wandering around in areas better left alone. You wonder what 'SBURB GAME DISC' means?  They figure out they can use it to hack their land to move around trees and villages and everything. Wow, it is way more convinient to just brings to them rather than trekking all the way out there. The ground rumbles ominously with each modification to the landscape."),
                new Quest("The ground rumbles ominously. What the hell, the ${Quest.PLAYER1} didn't even do anything! Oh fuck, an Avalanche has started. Looks like all that fuckery has finally caught up with the ${Quest.PLAYER1}. Several ${Quest.CONSORT} villages are wiped off the map. The ${Quest.PLAYER1} pretends really hard that it was a tragic accident that definitly nobody caused. ")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}