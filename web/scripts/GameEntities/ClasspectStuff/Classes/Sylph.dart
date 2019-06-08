import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Sylph extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 1.01;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "Sylph I:___ N4IgdghgtgpiBcIDKBPANgBwBYAICSIANCAGZoQBuA9gE4AqMAHgC4IgA8ARgHxJ4AiAUQCKAVUFI68dgHoeOOlhg4kAYUEA5QQH0A8gHUtAJW0aAggFlBOAJYBnHEsw2wAcxxUArsxwBHTzB2Pq42FDA0Di44YDAwACYeJDh2VLBUMQDkDlAQIQDGOMxeeViEOBBgCcxKKupaeoaCJuZWtg4AVp5BhTU0Nq5YPhjhKWA4JLQ9yu1UnAB0OABC3jh9Az4QJMzhOBjezC7uMGE0KNWHtmMY5HkwZTYbaGjjEE8OEBgQNMwLAApULmYaECdgA-DgAGrhFALZYbHzAiDdarKNSaHQGYymSzWEixNAONA2ADWyhRKAyYRwiJoMQSKVg5zccwAOmAuDRuBzuEQQMwvq4YMxdDE2MwaAFeeL+oKaKp0nEHjZ0nYADKhQ5sADawBZIBsUAwtH5YGY+locT18D1GhkZj1hBtujoVr1JFedhgDr1EKMeCQAGl7Qg3R6vUQ9ZBYK6QHg7EgYGgSN79YbjRVmHhTTGAAx6gC+ZV1qaN3wz5polpDIFtwcdNedMfdBPD9d9-qDTbDKaj4etsbsZiJYRTBtLJsz2ereZAhZwxbH6dNFar-drKY0jer4oCKfbgeD-ebnp70D7erjAHEqHE6DZwqO02XTVnmLmC0W9Yvn2aLTHfmgnh5MSChUKSYDwNoUE4BoAAseCuHEAyuMwrgYDYix5HgZhBpwZg0K4ACaADuGiEWY2G+GYACcaDtJeqhmPwwiuIsUABoIZicK4wiCAArLBxFmDAZiqiEuhIJejBmMRugkQATMJdCLIwghoKoqiuPwuh5KoUDEYRiyqhMeCGVgZhQGYFkPFQdgAMxIJYVDML4AbEQAtHQriXgAjK4ZgABJGKoAZUGYiw5hAAAcxF4bovgWMwcQANQBYZKBmL8whmK4YAAFrEu5dgAFKwb8kBIBY7SqFgSGLFRghhcSWlBhoeBYKoGgAGJIHYFABa4OYBfxeCqGASAQHQZhUGgZiiLoABergoJ4nCqIBoiOUxaVmBQUDCLBzAUHluiqlgyxuAtMDFYRAV5YRSCLMlEg5owyUwEgxW+Hl+UUGgRh8YwJ3CHYqg+WgSCERoECLF1Zg+e5JD6Pw7R5DmaAAOyOXEok0Lpdi+L4l4uQAbMlUCLJeyU+XldldfwqiiGg-BmFD7SOYsNj0RYGBgBYAAa8mwRQdnJa4xWLIRvzyTmNhYAFW0blu-Y7q2Pp+geXYtqe0bVgFSJILcMSPuOGavu+s6fiWS6-pWMbrhGDYutWx5qyA+6di73aO72MZxkYFRxKkJs2+b1Z2XZBYALpSmssrypUSoqqqgfajHxAwCQeJ5MwdhdbQ6oUJqiA6l+T4TiuMYWLMNhEswKA6+eIA1RUgoWCgSD8m+jse4eoba4734ThonhQJwD7Vu5PmR5b85l6by5-tWXU0LEOD6LXaCNzGLduDA7edxA3dthrntHt79ZDxmI9jxP-bTx+c-Wz+lfVgBQEgXQYEwBBUHaDB8FELIVQuhTC2FcL4SIqRcilEaJ0QYkxFibEOJcR4vxQSwlRLiUktJWSCklIqTUhpLSOk9IGSMiZMyFkrJQBsvZRy1cXJuU8t5PygVgqhXCpFGKcUEpJVSulTK2VcoFSKqVcqEBKrVVqqxBqTUWpmDah1bqvV+qDWGnxUa41JrTVmvNJaK01obS2vwHae0DpHROmdC6rgro3Tug9J6L03ofS+j9PKf0AZA10CDMGEMoYwzhgjJGKM0aY2xrjfGhNia+DJhTKmNM6YMyZizNmHMuaXh5nzQWwtRbi0ltLWW8tFY+zPDGS8oQRI52VGAPcp8+58glG7K+pob7jxoBbfM6cQCZ2zrnfONAU6VDsGnWcQA",
        "Sylph II:___ N4IgdghgtgpiBcIDKBPANgBwBYAICSeIANCAGZoQBuA9gE4AqMAHgC4IgA8ARgHxJ4ARAKIBFAKpCk9eBwD0vHPSwwcSAMJCAckID6AeQDq2gEo7NAQQCyQnABMAlgGcMMMI5iOctCA4DGENBwoCABze18cAFcwFmocahZlWk8ITwwIWhZ40hwIHEd7WxgAR0iPFgA6RWV7Wly0NHsPXNoVGCgMagB3GFbbHC4UHESVdS1dQxMzKyEAchTnGF8siDB+yPcceyzYnF8sVZCVEZwuujR+jOpo-pGoIlzfX2oOxscsezAQ4Zq6kOoAo4qgAhIYBNDdT7fBJJTy7FhdJw7ZSnc7rApfH4wWq5RbLB4nMbafRGISmCzWIIwGAsOEo1qlWrtVy07IDbGYvKoTBYCoAHTA3FoPCFPGIIBYGSOLD0YDgiBYtDK4sV9hCR1oamoa229m1jgAMvZKFD2ABtYB8kD2Dp0SUxAx0WxW+BWzSycxWohuvT0F1W0iAmBeq0ANWMeCQAGlPQgA0GQ+BoMG4yA8I4kDA0KREzbOplViw8DF-SAAAxWgC+D0t1ttBYdTtL7tj3pAml9pcDaHcifDkZjXYTxCtkFgpfT5kalBTbbzdsLxZYpYrIGrOFr84bLEdtGdqZbiY7ftT3d7I5A-ejsddZGHbbHKdv6YA4tRbPQmrRc-X7UWS6mq7rpuv6Fru+63gACmgkS+AA1oo1Bwa48A6GhOCaAALHgIS2CEWAhCwIQYPYwK+Hg5gxlw5i0CEACaXSaHR5gUcU5gAJxoAAVi+ajmAIIghMCUBRkI5hcCEIhCAArJhXTmDA5gGmEehIC+TDmF0egMQATAp9DAkwQhoGoaghAIei+GoUBdHRwIGqQ1B4HZWDmFA5huds1COAAzEgVgJMUUZdAAtPQIQvgAjCE5gABLGGoUbUOYwJlhAAAcXTUXoxSWCwtgANSxXZKDmJBIjmCEYAAFpwSFjgAFKYZBkBIJYXFqFgeHAmxQjJXB5kxpoeBYGomgAGJII4lCxSEZaxTJeBqGASAQPQ5jUGg5hiHoABeIQoJEXBqDBYj+fxxXmJQUAiJhLCUNVegGlgwLRCEu0wA1dGxdVdFIMCBWSGWTAFTASANcU1U1ZQaDGNJTCPSIjhqJFaBIHRmgQMC43mJFIWkAYAhcb4ZZoAA7P5thKbQVmOMUxQviwxQAGwFVAwIvgVkXVT540CGoYhoAI5gY1x-nAvYPGWBgYCWAAGjpmGUD5BUhA1wJ0ZBOllvYWCxedR6dqmiplH2EbXkOPazqOyalrFqRIL4rjW3W+Z-kuK5VjWVpbn+4HNh6hsnreZ4u1eg6nveNvjqm6bGKstgvD+buLgBt7M8zVYALoqrQaoalqOosHqbgGgn5o5yQMCkKQSy0uNdBGiaXzmiBKeNnupaWNQXD2I0LAoImj6lp1hwwJYKBIJKy4XuHN7xlbycLjEmiRFAXC9KWIWRT5QHe67y87k2qbja0KgGH3aBD7bqaj184+T9PZsDvPd6LxevuFqv6+b6mO97xuH2oEO4QStNBWCCF6BIRQmhHQGFsK4XwoRYipFyKUXEjReijFmKsQ4txXi-FBLCVEuJSSMk5IKSUipNSGktK6X0oZYyplzKWWsrZeyjlnLAlcu5TysRfL+W7kzYKYUIrRTiglJKKU0qZWyrlfKRUSplQqlVWq9UmotQgG1DqXUhK9X6oNcww1RoTSmjNOaC1pJLRWmtDaW0dr7UOsdU650BCXWurde6j1nqvS+B9L6P0-oAyBiDMGEMobVRhnDBGegkYozRhjLGOM8YEyJiTcmlNqa03pozFmbMOZcx5nzAWQsRaaDFilSWL5paywVkrFWasNZax1nrA2F5h6phfMaRSywS7PwtsbJULtP4rzXhvb8gFs7imrrXZYjgG60DLmsRwFc1xAA"
];
    
    @override
    List<String> levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN", "FAE FLEDGLING"];
    @override
    List<String> quests = ["restoring a consort city to its former glory", "preserving the legacy of a doomed people", "providing psychological counseling to homeless consorts"];
    @override
    List<String> postDenizenQuests = ["beginning to heal the vast psychological damage their consorts have endured from the denizens ravages", "setting up counseling booths around their land and staffing them with well trained consort professionals", "bugging and fussing and meddling with the consorts, but now using their NEW FOUND POWERS", "realizing that maybe their bugging and fussing and meddling isnt always the best way to deal with things"];
    @override
    List<String> handles = ["serious", "surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

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

    Sylph() : super("Sylph", 5, true);


    @override
    bool highHinit() {
        return true;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Meddler's Guide",<ItemTrait>[ItemTraitFactory.BOOK, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.PAPER, ItemTraitFactory.ENRAGING,ItemTraitFactory.LEGENDARY,ItemTraitFactory.HEALING],abDesc:"Meddling meddlers gotta meddle. "))
            ..add(new Item("First Aid Kit",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.HEALING],shogunDesc: "Anti-Pain Box",abDesc:"Heals here."))
            ..add(new Item("Cloud in a Bottle",<ItemTrait>[ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.CALMING],shogunDesc: "Fart In a Jar",abDesc:"Fucking sylphs man. How do they work?"))
            ..add(new Item("Fairy Wings",<ItemTrait>[ItemTraitFactory.MAGICAL, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.GLOWING, ItemTraitFactory.PRETTY, ItemTraitFactory.PAPER],shogunDesc: "Wings Cut Straight From a God Tier Troll", abDesc: "I GUESS Sylphs in myths are kinda fairy shit, right?"));
    }


    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
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
    double getAttackerModifier() {
        return 1.0;
    }

    @override
    double getDefenderModifier() {
        return 1.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be feeling more helpful after being around the ${target.htmlTitle()}. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify other.
        target.modifyAssociatedStat(powerBoost, stat);
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //seers are blind, get it?
        addTheme(new Theme(<String>["Springs","Water", "Pools", "Reflection","Contemplation","Fountains","Wellsprings","Geysers"])
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.AXOLOTLCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.MEDIUM)

            ..addFeature(new PostDenizenQuestChain("Heal the Timeline", [
                new Quest("The ${Quest.PLAYER1} decides to take a break after defeating ${Quest.DENIZEN} and returns home. Immediately after opening the front door, they’re buried in an avalanche of ${Quest.CONSORT}s. Crawling their way out, the ${Quest.PLAYER1} sees the ${Quest.CONSORT}s are all using a copy of the ${Quest.PLAYER1}‘s time travel device and more of them are popping in and out from other points in time. If left unchecked, they’ll probably create way too many unstable time loops to be good for the session."),
                new Quest("The ${Quest.PLAYER1} does some time traveling to investigate when the ${Quest.CONSORT}s get time machines to stop any more ${Quest.CONSORT}s from getting them. They find a time when their house is suddenly filled to the brim with ${Quest.CONSORT}s and then later they all seemingly vanish with no evidence of time traveling ${Quest.CONSORT}s at any other time. The ${Quest.PLAYER1} realizes that means the ${Quest.CONSORT}s are getting their time machines in the same timeframe as when they are popping in and out of time. Which means if the ${Quest.PLAYER1} wants to stop the ${Quest.CONSORT}s from causing time travel messes, they’ll need to squeeze their way through the ${Quest.CONSORT} filled house."),
                new Quest("Traveling back to the time they were originally in, the ${Quest.PLAYER1} gets ready to take the plunge into a fuckton of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. They slowly crawl and squeeze their way through; cursing the dumb shit they have to do to fix time problems. After a couple of agonizing minutes, they finally make their way to their alchemiter, where they find a bunch of ${Quest.CONSORT}s are wasting grist making copies of the ${Quest.PLAYER1}‘s time machine. The ${Quest.PLAYER1} chases them away from the alchemiter, and then spends the next four hours slowly going through the house, confiscating time machines while also making sure they don’t accidently confiscate a time machine they already confiscated and create a time paradox. Eventually all the time machines are taken and all the ${Quest.CONSORT} s have been given a stern talking to. The ${Quest.PLAYER1} is more than done with their ‘break’."),
            ], new RandomReward(), QuestChainFeature.timePlayer), Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Be The Sylph", [
                new Quest("A handsome ${Quest.CONSORT} is scheduled to be wed to a beautiful maiden. Instead, he keeps seeing visions of an ethereal ${Quest.CONSORT}, and runs away to be with her a clearing in the woods filled with bubbling springs.  The ${Quest.PLAYER1} is unimpressed. "),
                new Quest("The ${Quest.PLAYER1} alchemizes 'The Sylph's Scarf'. Huh. Apparently it's a reference to some sort of ballet? A ${Quest.CONSORT} crone assures the ${Quest.PLAYER1} that it will stop the handsome ${Quest.CONSORT} from seeing weird visions that make him run into the woods, though."),
                new Quest("The ${Quest.PLAYER1} gives the handsome ${Quest.CONSORT} the 'Sylph's Scarf'. He immediately begins weeping that the ethereal ${Quest.CONSORT} is dead. He is inconsolable. Holy shit, ballets about Sylphs are kinda dark.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Relax the Consorts", [
                new Quest("The ${Quest.CONSORT}s are so stressed after all that shit with the ${Quest.DENIZEN}. They are yelling and ${Quest.CONSORTSOUND} at each other over the slightest of insults. The ${Quest.PLAYER1} decides that what they really need is to chill the fuck out. "),
                new Quest("The ${Quest.PLAYER1} organizes a spa day for the ${Quest.CONSORT}s in one of the land's many, many bodies of water. The sound of the water is so relaxing, it's like it melts the worries right off."),
                new Quest("The ${Quest.CONSORT}s are back to their normal selves.  Only one fight breaks out all week, and really, that asshole ${Quest.CONSORT} deserved what was coming to him. Everything is doing pretty good, thanks to the ${Quest.PLAYER1}. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenFrogChain("Purify the Frogs", [
                new Quest("The ${Quest.DENIZEN} has allowed the water to recede enough to form shallow pools for the frogs. The water is muddy and silty until the ${Quest.PLAYER1} purifies the pools "),
                new Quest("The ${Quest.CONSORT}s are ectobiologizing....VERY wrong frogs. The ${Quest.PLAYER1} goes after them and heals the deformities, then shows the ${Quest.CONSORT}s how to do it right. "),
                new Quest("By the time the final frog is found, it is dead.   Calmly, the ${Quest.PLAYER1} uses the ectobiological equipment to access it in the past, and alchemizes it's offspring. the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Purify the Water", [
                new Quest("The defeat of the ${Quest.DENIZEN} has some unforseen consequences, including the tainting of the water for the majority of the land. The ${Quest.CONSORT}s seem to have figured out a solution in the short term, but the ${Quest.PLAYER1} resolves to bug and fuss and meddle until things are fixed the right way. "),
                new Quest("So far, the ${Quest.PLAYER1} hasn't had much luck getting ${Quest.CONSORT}s to build a water purifying facility.  They are content just boiling their water. 'It's not hard', they say. It's so frustrating that the ${Quest.PLAYER1} knows they can help them but the ${Quest.CONSORT}s just will NOT cooperate. "),
                new Quest("The ${Quest.PLAYER1} has finally accepted that some people just don't want to be helped. As they make peace with this, a mysterious glow emerges from their chest.  The water of the land matches this glow, and the water is purified through the power of ${Quest.MCGUFFIN}. Huh. Okay then.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
