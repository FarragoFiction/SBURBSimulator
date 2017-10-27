import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Witch extends SBURBClass {
    @override
    List<String> levels = ["WESTWORD WORRYBITER", "BUBBLETROUBLER", "EYE OF GRINCH"];
    @override
    List<String> quests = ["performing elaborate punch card alchemy through the use of a novelty witch's cauldron", "deciding which way to go in a series of way-too-long mazes", "solving puzzles in ways that completely defy expectations"];
    @override
    List<String> postDenizenQuests = ["alchemizing a mind crushingly huge number of computers in various forms", "whizzing around their land like it's fucking christmas", "defeating a completely out of nowhere mini boss", "wondering if their sprite prototyping choice was the right one after all"];
    @override
    List<String> handles = ["wondering", "wonderful", "wacky", "withering", "worldly", "weighty"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Witch() : super("Witch", 11, true);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 0.5;
        } else {
            powerBoost = powerBoost * -0.5;
        }
        return powerBoost;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify self.
        p.modifyAssociatedStat(powerBoost, stat);
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be feeling more powerful after being around the ${target.htmlTitle()} ";
    }

    @override
    double getAttackerModifier() {
        return 2.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

    @override
    double getDefenderModifier() {
        return 1.0;
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Potions","Brews", "Cauldrons", "Toil","Trouble","Covens","Bubbles","Cackling"])
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROAKINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Brew the Frogs", [
                new Quest("The ${Quest.DENIZEN} explains that the frogs have all been turned into handsome ${Quest.CONSORT} consorts. It's up to the ${Quest.PLAYER1} to turn each of them back into a slimy, warty frog, whether it's through kisses or potions. "),
                new Quest("The former ${Quest.CONSORT}s hit buttons on the ectobiology machine at random, creating their own ectobiological tadpole children.  The ${Quest.PLAYER1} just sort of rides out the chaos. "),
                new Quest("The  ${Quest.DENIZEN}  reveals that the final frog is on the ${Quest.PLAYER1}'s destroyed home world. Huh. You guess it's a good thing ectobiological equipment can sample DNA across time and space.    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Twist All The Things", [
                new Quest("Even with the defeat of the ${Quest.DENIZEN}, there are still problems. There is flooding in one valley, giant underlings are rampaging in one ${Quest.CONSORT} settlement, and crops refuse to thrive at ${Quest.MCGUFFIN} Ranch. The ${Quest.CONSORT}s seem to have accepted everything as just how things are, but the ${Quest.PLAYER1} isn't going to give up until they show the status quo just how 'quo' it isn't!"), //dr horrible refrance
                new Quest("Alright, it turns out that through a mixture of Alchemy, game powers and pure elbow grease, the ${Quest.PLAYER1} has managed to make a river flow backwards.   Now instead of flooding, the valley is draining itself.  Progress!"),
                new Quest("The doesn't feel like KILLING the giant underlings rampaging in the ${Quest.CONSORT} settlement. What's the fun in that? They try a variety of techniques until the underlings are as calm and friendly as ${Quest.CONSORT}s themselves.   Now they are productive members of society! "),
                new Quest("The ${Quest.PLAYER1} twists how plants and soil and growth works until the crops at ${Quest.MCGUFFIN} Ranch are finally thriving. With that, they have finally kicked the former status quo to the curb!  ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Brew The Potion", [
                new Quest("A Mysterious ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. Apparently an alchemy recipe for a potion of Ultimate ${Quest.MCGUFFIN} was discovered amongst the ${Quest.DENIZEN}'s things. Maybe the ${Quest.PLAYER1} can figure out how to create it? "),
                new Quest("One potion makes you smaller. One makes you taller. A third doesn't do anything at all. Ugh! Why is it so hard for the ${Quest.PLAYER1} to get the potion of  Ultimate ${Quest.MCGUFFIN} right? "),
                new Quest("Careful now. Just....one....more drop. THERE.   The ${Quest.PLAYER1} is now the proud owner of a potion of Ultimate ${Quest.MCGUFFIN}. They immediately chug it, only for it to manifest a mirror showing the ${Quest.PLAYER1}'s own face. Oh. God DAMN it. It turns out the  Ultimate ${Quest.MCGUFFIN} was the ${Quest.PLAYER1} all along. They didn't need any silly potions. Worst. Quest. Ever.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Train the Apprentice", [
                new Quest("A young ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. They wish to learn how to be magical, too!  The ${Quest.PLAYER1} dubs them the ${Quest.MCGUFFIN}mancer and agrees to train them. "),
                new Quest("The ${Quest.PLAYER1} has barely begun to train the ${Quest.MCGUFFIN}mancer, but needs to head into town to fetch a few ingredients.   The ${Quest.MCGUFFIN}mancer promises to be good, and IMMEDIATELY starts fucking shit up on accident with magic. Oh god, why are all those ${Quest.PHYSICALMCGUFFIN}s suddenly alive?  When the ${Quest.PLAYER1} returns, they use this as an opportunity to teach the ${Quest.MCGUFFIN}mancer a valuable moral. "),
                new Quest("The ${Quest.MCGUFFIN}mancer is ready to show off their power to the other ${Quest.CONSORT}s. They ${Quest.CONSORTSOUND} in amazement to see the things the ${Quest.MCGUFFIN}mancer can do! The ${Quest.PLAYER1} was a good mentor.  ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ,  Theme.MEDIUM);
    }



}