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
    String sauceTitle = "Warlock";

    //what sort of quests rewards do I get?
    //witches have familiars, spells and potions
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.51;
    @override
    double companionWeight = 0.51;

    @override
    List<String> associatedScenes = <String>[
        "Witch I:___ N4IgdghgtgpiBcIDqBLALgYwBYAICSIANCAGYA2EAbgPYBOAKjAB5oIgA8ARgHwDKeAEQCiARQCqQ3vXjsA9Dxz0sMHLwDCQgHJCA+gHkk2gEo7NAQQCyQnCgDOOACbUUYAOY4IOWygcwAjgCuMLZoHmAOjjAYPsE4aNQ4rgkY1FAADmQwaDBkAJ441CQkcco4tBAoZLaEOFAQANYu7jCUMLS5aFhNOClgNGQB2REkdDhgCbQwEGRlU7bUYDULeXEJJC4R1IMlEKHTM527ODBFdKEA7hD2I7Rj1J1NAHSKpepaugbGppbWrln241m01ml1om06bR2YBKKnq43OmQcfwKxSw1HOq1qDRUDzc9nOMBQYJs0IhOBIgwCk0eAB0wFxaNwGdwiCA0BBaH80HowHBEGhaEFWQKUK4-rQ1AsHOgUAtbAAZFCUJpsADawBpIBQ6TOEDAaCQdAcmvgms0sjMmsIZr09BNmpI01sMCtmoAakY8LwANKWhAOp0uoiayCwe0gPC2Xg5EiurU62js-V4fXhgAMmoAvjUNfG0rr9YaweHzX7rSBNLbw46qkHyx6vb7q4G46Gg6aI7YzGQlXXNdr84m9WgU2h01mc-2E0mDUaSxa45W7f62YK+yAGz6-R2a87W9B25rIwBxagOegoNpxgcFkeplcZkDZnC5m9DwtzlcABQGGHqimoeoYDAeAdDAnBNAAFjwVwkSwVw0FcNIUAAIQwPAzF9TgzE5ABNc5NFwswML8MwAE4yAAK2PNQzAEERXBQqBvSEMxOFcEQhAAVkg84zBgMx5VcFA9F4Y8mDMc49HwgAmfj6BQpghDINQ1FcAQ9AwNQoHOXCUPlEY8D0rAzCgMxTPQahbAAZl4Sx7j8b1zgAWnoVxjwARlcMwAAkjDUb1qDMFC0wgAAOc5sL0PwLDQBwAGofL03IzC-EQzFcMAAC16mc2wAClIK-SBeAsSi1CwJEUNIoQgvqdTfU0PAsDUTQADFeFsSgfNcNMfO4vA1DAXgIHoMxqDIMwxD0AAvVxcgCTg1AGMQ7LopKzEoKAREgtBKCyvR5SwFCAjcGaYHy3CfKy3DeBQ+LJDTJh4pgXh8r8LLssoMgjC4pgDpEWw1A8sheFwzQIBQtqzA85ySCQARKIwNMyAAdjshxBNoLTbD8PxjzQPwADZ4qgFDj3ijysustqBDUMQyAEMxwcouyUJQaiLDSMALAADRkyDKGs+LXHylDcK-GS0xQLAfLWxcqxXAUgjjTcmxXXd1zbcMfKuXgMGA9c3xnUdxyfSc81vItjRXUsFeXHcW2DDdPS3Zta33MMV0jIw9ScKBr2nYdTZXazrKzABdYVaFFcVJXCGU5XlP21Sj4gThIKI0FsNq6EVZU3DVV8g4-YsVwsahOEqdBck9w8QAqvU-gsXJeHZMdnbV7cAw953jeHTQAigTgrxXZyPPD82XynQcZ2t8M2smFRUDIMg6-DRu3BgFu292VXXfVx3e-Lfv9UH4fR47CeJ2ny331nMuOx-AI-wAoCQLAnQIOg2DXHgxDkJoQwlhHCrh8KEWImYUiFFqK0XooxZirF2KcR4nxASQkRJiQklJWS8lFLKVUupTS2ldL6UMsZUy5koCWRsnZCuhMnKuXcl5Xy-lArBVChFKKMU4qJWSqldKmUcp5UKsVCApVyqVUYjVOqDUzBNRau1Tq3Ver9S4oNYao1xqTWmnNBaS0VprQEBtLaO09oHSOidM6F0ro3Tug9XgT0XpvQ+l9H6f0AZAxBmDCGUMYZwwRkjFG6MzCY3lNjNQuN8aExJmTCmVMaZ0wZkzFmbMObHi5jzfmgthai3FpLaWst5bO21iuY8vYzAYDQLKMA+9Gzd1XCrPuJc0DnxHrQM2mY04gAzlnHOec-a2FTk+IAA",
        "Witch II:___ N4IgdghgtgpiBcIDqBLALgYwBYAICSeIANCAGYA2EAbgPYBOAKjAB5oIgA8ARgHwDKeACIBRAIoBVYXwbwOAel44GWGDj4BhYQDlhAfQDySHQCVdWgIIBZYTgw0oAB3Iw0McgE8cAExh0IKcgBnHAB3LAhXKl8cQJQfAEcAVxhAtBw0FU8Q31UaMCJ0kJRUlDAAcxx0HETY8vSVFDocCECHGAw0xLA0AMq0rnb7FJihjNKKqHpVQMT0GC8cUnp6mEacMBh5wIA6JRU1TR0DI2FTC2tK4JgwDBb50PRcDNUy8hoQnBpSZtb2tE8oBAyigMN5EnRxiscA46DQMCkdjhBDRIWNghByG8QsFngdtHpDCYzFYbGgaDhyCgotUHOlybiemhnJ9vqhMFhtgAdMDcOg8Xk8YggNAQOhlFz6DbsNB0ZJCmUoMriujqPJedAoPKBAAyVPG7AA2sBOSAUI56CLukh6F4TfATVo5OYTUQHfoGHaTaQMYEYC6TQA1Yx4PgAaWdCC9Pr9xBNkFgnpAeECfDcpH9pvNdEtaDw3UTAAYTQBfArGzMOC0QK02xOOiOukBad2J71BGONoMh8Ot6MZ+Mx+1JwLmSlRDNmyvZ6u5-ORkBFkClnDlydVmt0W3z+sZ5se+dt30ZrthiNDw8duPQQcm5MAcRoXgYKF8E6zObzaELJbLJrX043LchwABXIRIMAAayUGgIOueBdAQnAtAAFjwMovDKLAyjQMoHBQAAhDA8HMcMuHMMUAE0Qi0CjzGI+JzAATnIAArO91HMQRRDKfCoFDYRzC4MpRGEABWZCQnMGBzG1YF9D4O9mHMEJ9CogAmKSGHw5hhHIdR1DKQR9AwdQoBCCj8O1JY8AsrBzCgcx7PQGhAgAZj4KwaDQeJQxCABaBgyjvABGMpzAACWMdRQxocx8ILCAAA4QjI-R4ksNAvAAanCiz3HMYDRHMMowAALQgvzAgAKWQ4DID4SwWPULAMPwhjhFiiDDPDLQ8CwdQtAAMT4QIqHCsoC3CsS8HUMA+AgBhzBochzHEfQAC8yncRIuHUMDxA8zjcvMKgoFEZC0CoUr9G1LB8K6Mp1pgKqKPC0qKL4fCsqkAtmCymA+Cq+JSrKqhyGMUTmGu0RAnUYLyD4CitAgfDBvMYK-NIJBBBYjAC3IAB2DyvBkugTMCeJ4jvbyADYsqgfC7yy4LStcwbBHUcRyEEcwkZYjz8JQNjLAcMBLAADTU5CqFcrKyiq-CKOAtSCxQLBwsO3cW3nGVkmPYNT17dt+2vRNwpaPh4Q2N8pw-Och0XZdV3fGdrU3OsnS1-dzz7WMQBPHsD19xsB0TZNjGrLx7Bt9dZy-ecaZpksAF15QhJVfFVMB1R6LVtUjw1U5IGBSFIP5AkG+hdSofVECNP8XcAxNLBoLgAnQdwTYTedmurcVLHcPgRXjzsDcDn3jb9-8cy0RIoAGOhEz84LXMd38K1jt2gJNQa6E2HBUExLubxAXvyhgAeh4ifXuzPKNJ8baeZ1n+fX3nFe15XBvbdd2t51A8CUEGAwTgghXQSFULoUwthXCBEiIkUEuRMoVEaJ0XMAxZibEOJcR4nxASQkRLiUktJWSKB5KKWUqpEIGkYBaR0npAyRkTJmQslZGgNl8J2Qck5MkbkPIt28r5AKQVQoRSijFOKCVkqpXSplHKeUCpFRKuVSqNU6oQAak1FqPF2qdW6uYXq-UhojTGhNKaokZpzQWktFaa1NrbV2vtQ6ghjqnXOpda6t17rlCei9N6H0vo-T+gDIGINSpgwhlDfQMM4YIyRijNGGMsY4zxoTYmpNyaU2pvEOmDMmYszZhzLmPM+YCyFneEWYtJbS1lvLRWytVbq01n7UO847xUmkh0TUYAb6Gx1rKS8G8AJoBfgvb8S4i4gBLmXDoFcq6R0CIXJcQA"
];

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
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Cauldron",<ItemTrait>[ItemTraitFactory.LEAD, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.MAGICAL],shogunDesc: "Bell But For Liquids",abDesc:"Surprisingly literal."))
            ..add(new Item("Flying Broom",<ItemTrait>[ItemTraitFactory.BROOM,ItemTraitFactory.STICK, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.WOOD,ItemTraitFactory.MAGICAL],shogunDesc: "Bell But For Liquids",abDesc:"WHY ARE THERE SO MANY FUCKING BROOMS IN THIS GAME."))
            ..add(new Item("Warped Mirror",<ItemTrait>[ItemTraitFactory.MIRROR, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.MAGICAL, ItemTraitFactory.OBSCURING, ItemTraitFactory.LEGENDARY],shogunDesc: "Mirror from The Shoguns Dresser",abDesc:"I guess Witches warp shit and stuff."));
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
                new Quest("The ${Quest.PLAYER1} doesn't feel like KILLING the giant underlings rampaging in the ${Quest.CONSORT} settlement. What's the fun in that? They try a variety of techniques until the underlings are as calm and friendly as ${Quest.CONSORT}s themselves.   Now they are productive members of society! "),
                new Quest("The ${Quest.PLAYER1} twists how plants and soil and growth works until the crops at ${Quest.MCGUFFIN} Ranch are finally thriving. With that, they have finally kicked the former status quo to the curb!  ")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Brew The Potion", [
                new Quest("A Mysterious ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. Apparently an alchemy recipe for a potion of Ultimate ${Quest.MCGUFFIN} was discovered amongst the ${Quest.DENIZEN}'s things. Maybe the ${Quest.PLAYER1} can figure out how to create it? "),
                new Quest("One potion makes you smaller. One makes you taller. A third doesn't do anything at all. Ugh! Why is it so hard for the ${Quest.PLAYER1} to get the potion of  Ultimate ${Quest.MCGUFFIN} right? "),
                new Quest("Careful now. Just....one....more drop. THERE.   The ${Quest.PLAYER1} is now the proud owner of a potion of Ultimate ${Quest.MCGUFFIN}. They immediately chug it, only for it to manifest a mirror showing the ${Quest.PLAYER1}'s own face. Oh. God DAMN it. It turns out the  Ultimate ${Quest.MCGUFFIN} was the ${Quest.PLAYER1} all along. They didn't need any silly potions. Worst. Quest. Ever.")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Train the Apprentice", [
                new Quest("A young ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. They wish to learn how to be magical, too!  The ${Quest.PLAYER1} dubs them the ${Quest.MCGUFFIN}mancer and agrees to train them. "),
                new Quest("The ${Quest.PLAYER1} has barely begun to train the ${Quest.MCGUFFIN}mancer, but needs to head into town to fetch a few ingredients.   The ${Quest.MCGUFFIN}mancer promises to be good, and IMMEDIATELY starts fucking shit up on accident with magic. Oh god, why are all those ${Quest.PHYSICALMCGUFFIN}s suddenly alive?  When the ${Quest.PLAYER1} returns, they use this as an opportunity to teach the ${Quest.MCGUFFIN}mancer a valuable moral. "),
                new Quest("The ${Quest.MCGUFFIN}mancer is ready to show off their power to the other ${Quest.CONSORT}s. They ${Quest.CONSORTSOUND} in amazement to see the things the ${Quest.MCGUFFIN}mancer can do! The ${Quest.PLAYER1} was a good mentor.  ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ,  Theme.MEDIUM);
    }



}
