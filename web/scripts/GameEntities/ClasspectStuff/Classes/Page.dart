import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Page extends SBURBClass {
    @override
    double difficulty = 0.0;
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

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Desert","Sand", "Pyramids", "Camels","Tombs"])
            ..addFeature(FeatureFactory.OVERHEATED, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SNAKECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LIZARDCONSORT, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Help Breed the Frogs", [
                new Quest("The ${Quest.DENIZEN} has allowed water to flow once more. The croaking of frogs fills the air as pools begin to form. The ${Quest.PLAYER1} asks the ${Quest.CONSORT}s to help them collect frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} shows them how to do it right, and soon everybody is helping out. "),
                new Quest("A ${Quest.CONSORT} child has tripped over the final frog. They cry and ${Quest.CONSORTSOUND} at their skinned knee, but their pain is quickly forgotten when the ${Quest.PLAYER1} praises them for finding the frog.  Together, they combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Become The Best", [
                new Quest("The ${Quest.PLAYER1} was about to walk through a patch of incongruous tall grass when a quirky ${Quest.CONSORT} named Professor ${Quest.CONSORTSOUND} halts them. apparently, it's not safe to travel without trusty ${Quest.PHYSICALMCGUFFIN} by their side. The professor also makes some side comments about the ${Quest.PHYSICALMCGUFFIN} League. If the ${Quest.PLAYER1} can assemble a team strong enough to beat the gym leaders, they might have a shot at becoming the ${Quest.PHYSICALMCGUFFIN} League Champion!"),
                new Quest("The ${Quest.PLAYER1} wanders about their land, learning how to use their ${Quest.PHYSICALMCGUFFIN} effectively and taking down the ${Quest.PHYSICALMCGUFFIN} gym leaders. Along the way, they hear rumors that the dastardly Team ${Quest.CONSORTSOUND}, led by ${Quest.DENIZEN}, plans to interfere with the league. The ${Quest.PLAYER1} will not stand for this."),
                new Quest("After an intense round of ${Quest.PHYSICALMCGUFFIN} battling, the ${Quest.PLAYER1} finally defeats the last gym leader of the ${Quest.PHYSICALMCGUFFIN} league. Turns out, the ${Quest.PHYSICALMCGUFFIN} they used was super effective! they can now challenge the ${Quest.PHYSICALMCGUFFIN} League. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has finally almost completed the ${Quest.PHYSICALMCGUFFIN} League. Much to their suprise, the Champion they must defeat in order to claim the title is none other than ${Quest.DENIZEN}!!! Will they succeed? STRIFE!","The ${Quest.PLAYER1} is now the ${Quest.PHYSICALMCGUFFIN} League champion. ${Quest.DENIZEN} remains alive just long enough to walk them to the hall of fame, which is suprisingly filled with grist!","The ${Quest.PLAYER1} whited out...")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Explore the Tombs", [
                new Quest("Now that the ${Quest.DENIZEN} is finally out of the way, some of the previously sealed tombs have opened up. It is time for the ${Quest.PLAYER1} to desecrate the fuck out of some tombs."),
                new Quest("In a twist that is shocking only to the ${Quest.PLAYER1}, they are now inflicted with a Mummy's Curse. There is a REASON you don't desecrate random tombs. A local ${Quest.CONSORT} explains that they will have to find a ${Quest.PLAYER1} champion to face the Mummy, for anyone cursed by it will surely perish should they face it in a strife."),
                new Quest("The ${Quest.PLAYER1} finds a competent enough Warrior ${Quest.CONSORT} to help them fight the Mummy. While they can't fight directly, the ${Quest.PLAYER1} can at least give them some ${Quest.MCGUFFIN} buffs. With a deafening ${Quest.CONSORTSOUND}, the Warrior ${Quest.CONSORT} wins the day! The curse is lifted! ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }
}