import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Grace extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.01;

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
    void initializeItems() {
        items = new WeightedList<Item>()
        //things that take only a nudge to ruin everything.
            ..add(new Item("How to Teach Your Friends to Hack SBURB",<ItemTrait>[ItemTraitFactory.BOOK, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.PAPER, ItemTraitFactory.LEGENDARY, ItemTraitFactory.SMARTPHONE],abDesc:"Oh sure, it's bad enough that WASTES fuck around in my shit, but at least they somewhat know what they are doing. SURE, let's have GRACES teach the WHOLE FUCKING PARTY to do it."))
            ..add(new Item("Unstable Domino",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.DOOMED],shogunDesc: "Broken Knocker Over Maths Thing",abDesc:"Fucking Graces can't leave well enough alone."))
            ..add(new Item("Exposed Thread",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.DOOMED],shogunDesc: "Indecent String",abDesc:"Fucking Graces can't leave well enough alone."))
            ..add(new Item("Teetering Plate",<ItemTrait>[ItemTraitFactory.PORCELAIN, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.DOOMED],shogunDesc: "Impending Drop Dish",abDesc:"Fucking Graces can't leave well enough alone."));
    }



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

            ..addFeature(new DenizenQuestChain("I'm So Meta, Even This Acronym", [
                new Quest("An excited ${Quest.CONSORT} runs up to the ${Quest.PLAYER1} and starts to ${Quest.CONSORTSOUND} about a certain series. They tell ${Quest.PLAYER1} that the game they're playing with their friends is just like the one in the series. The ${Quest.PLAYER1} gets curious and starts looking for other ${Quest.CONSORT}s who know about this. By listening in on ${Quest.CONSORT}s ${Quest.CONSORTSOUND}ing, the ${Quest.PLAYER1} learns that the series is called '${Quest.MCGUFFIN}stuck'. What does that mean? The ${Quest.PLAYER1} decides to use ${Quest.CONSORT} technology to find this series directly."),
                new Quest("Now ${Quest.MCGUFFIN}stuck makes sense to the ${Quest.PLAYER1}. It is a show about some ${Quest.CONSORT}s who play S${Quest.CONSORTSOUND} and must create a universe with a special ${Quest.PHYSICALMCGUFFIN}. Apparently the  ${Quest.CONSORT}s have television here!  So, after watching some short episodes, the ${Quest.PLAYER1} finds that it's just like the situation all their coplayers are in! Well... almost. They don't quite know what this universe ${Quest.PHYSICALMCGUFFIN} is..."),
                new Quest("The ${Quest.PLAYER1} has watched a couple of episodes of ${Quest.MCGUFFIN}stuck, including the one where one of the ${Quest.CONSORT}s is the last to defeat their denizen, ${Quest.DENIZEN}... Hold on, that's the ${Quest.PLAYER1}'s denizen! Maybe it is their duty to defeat their ${Quest.DENIZEN}, in order to make it official. But would it ruin the fictional feeling of ${Quest.MCGUFFIN}stuck? They don't really want to find out, but they feel they must do it anyway."),
                new DenizenFightQuest("Now the ${Quest.PLAYER1} is facing the REAL ${Quest.DENIZEN}, who was actually expecting the  ${Quest.PLAYER1} to arrive earlier. Maybe it really IS their duty to defeat ${Quest.DENIZEN}!", "${Quest.DENIZEN} has been slain by the ${Quest.PLAYER1}! Many ${Quest.CONSORT} arrive at the denizen's palace, ${Quest.CONSORTSOUND}ing so loudly and thanking ${Quest.PLAYER1} for doing what they were supposed to do. The ${Quest.PLAYER1} is so happy, that instead of feeling that ${Quest.PHYSICALMCGUFFIN}stuck is ruined, they feel like it was a true story! They tell their friends AAAALLLLLLLL about ${Quest.PHYSICALMCGUFFIN}stuck, and the friends listen eagerly.","The ${Quest.PLAYER1} was not strong enough for ${Quest.DENIZEN}, much like the second ${Quest.CONSORT}, who nearly died. They are reminded again of the feeling they had earlier, that ${Quest.PHYSICALMCGUFFIN}stuck would not be as fun to watch after this. For the while, they cherish the fact that ${Quest.DENIZEN} is still living.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Cooking with Petrol", [
                new Quest("The ${Quest.PLAYER1} wanders the countryside looking for any quests still active after the defeat of the ${Quest.DENIZEN}. After defeating a boringly easy dungeon, it rumbles and descends into the ground. The ground rumbles ominously. "),
                new Quest("The ${Quest.PLAYER1} is wandering around in areas better left alone. You wonder what 'SBURB GAME DISC' means?  They figure out they can use it to hack their land to move around trees and villages and everything. Wow, it is way more convinient to just brings everything to them rather than trekking all the way out there. The ground rumbles ominously with each modification to the landscape."),
                new Quest("The ground rumbles ominously. What the hell, the ${Quest.PLAYER1} didn't even do anything! Oh fuck, an Avalanche has started. Looks like all that fuckery has finally caught up with the ${Quest.PLAYER1}. Several ${Quest.CONSORT} villages are wiped off the map. The ${Quest.PLAYER1} pretends really hard that it was a tragic accident that definitly nobody caused. ")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Stop the Meta", [
                new Quest("Now that the ${Quest.CONSORT}s are free from the reign of ${Quest.DENIZEN}, they are free to continue their normal lives. Wait a second... is that ${Quest.CONSORT} carrying the ${Quest.PLAYER1}'s copy of the SBURB discs? This can't be good."),
                new Quest("The ${Quest.PLAYER1} follows the ${Quest.CONSORT} with the SBURB discs into the local ${Quest.CONSORTSOUND} club. Apparently, this ${Quest.CONSORT} has more than one copy of SBURB, and they hand out the other discs to their fellow ${Quest.CONSORTSOUND} enthusiasts. The ${Quest.PLAYER1} panics, and makes a plot to steal all of the discs."),
                new Quest("Clever as a fox, the ${Quest.PLAYER1} steals the SBURB discs from each ${Quest.CONSORT} and replaces them with copies of the recently released 'Super ${Quest.MCGUFFIN} Quest Online: The ${Quest.PHYSICALMCGUFFIN} of ${Quest.CONSORTSOUND}'. now the ${Quest.CONSORT}s have a game they can play together that WON'T kill everything!")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

        //space player near guaranteed to do this.
            ..addFeature(new PostDenizenFrogChain("Allow Others to Meta a Universe", [
                new Quest("The ${Quest.DENIZEN} has released the frogs from their icy prisons. The land melts and warms and just generally becomes a lot nicer. The ${Quest.PLAYER1} shows the ${Quest.CONSORT}s how to check the code to find out where the frogs are. They sit back and allow the frogs to come rolling in. "),
                new Quest("The ${Quest.PLAYER1} sets up an automatic frog breeding system. Just about every possible variety of frog is produced from it."),
                new Quest("A series of incredibly unlikely events transpire such that the ${Quest.PLAYER1} almost steps on the Final Frog. Luckily, a ${Quest.CONSORT} ${Quest.CONSORTSOUND}s in time to stop them.    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)
            ,  Theme.MEDIUM);
    }


}