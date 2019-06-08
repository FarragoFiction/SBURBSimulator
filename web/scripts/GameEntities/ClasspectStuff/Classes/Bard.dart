import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Bard extends SBURBClass {
    @override
    String sauceTitle = "Maestro";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 0.50;

    @override
    List<String> associatedScenes = <String>[
        "Bard I:___ N4IgdghgtgpiBcIBCEBOATABASRAGhADMAbCANwHtUAVGADwBcEQAeAIwD4BlbAEQFEAigFV+XavBYB6TpmoALGJi4BhfgDl+AfQDyAdU0AlLeoCCAWX6YAlgGdMtmAwbWwAc0wBXAA6YImNmsALzRUJUcGTApCTBgyGDAGe1cojBhUTAYKTCgIAGtwilgHa3QYAEdPGFtIgGMi72InJWskmGJCADpMPUUwP2JiG3tbCFK-MCx0CjAYPEzFBygKAsxaprRbeYhJhaVVDW19IxMLKxhYVDdqzEJUIr21+QgKF1rMAHcw2ryFiEiPhB7DNakoGItbKUKlUat0FDBrBkwoCMMNMOg7BBvN4KK4XO5iABPHIwCDXVDzNieSLg-ZqTS6Az8YxmSy3GDtexAhYUTxueR7YloJRgCgfAJOBjpByeVowLBZGxgMhy9HVBioTy1FwzT59GyRCDazwQQbE3LOdK2ToAHTA7FQHAdHHwIAYaGuDB0s2YGqqro11jc5JUMwxOrAtgAMtYVe5mABtYA2kDWKA41DuxJ6KjoFPwFPqKSmFN4Qs6aj5lOEU2OUspgBqhmwXAA0iWENXazB6+BoD3OyBsLYuO1CL20xmswxsIkqyAAAwpgC+82TqfTVGnOYw86LHbLIHUFfnNeIdfwjebbY7BaI3d7kFg8+HpmIsYHh8nW52M7ng6XEBV0wddv0zX8dzzQd917Y9K0HP1PyvFt21PB9Lz7Z9B2HABxCh0Goax0gnTdwMSWcGHnQDgNA0jt1zecAAViC1X5qBWBJ4C0bjMHUAAWbA3HQfk3AYNxvGsJBamwUx2zYUwrgATQ+dRFNMGTylMABOYgACscJUUxeEENwkCgVt+FMNg3EEfgAFY+I+UwYFMKM3GsHQuBwuhTA+HRlIAJmc6gkDofhiBUFQ3F4HRahUKAPkUpAo0IChsCS+RTCgUwstaChbAAZi4CxXnKVsPgAWmoNwcIARjcUwAAlDBUVsKFMJAFwgAAOD55J0cpzAYdAAGpGqSwlTEYwRTDcMAAC08gq2wACk+MYyAuHMXSVHkYSkE0-h2ryaL23UbB5BUdQADEuFsMhGrcBdGvs7AVDALgIGoUwKGIUxhB0II3EJTw2BUFjhGKozxtMMgoEEPiGDIeadCjeQkE8dwghgFbFMa+bFK4JARrEBc6BGmAuBW8p5oWshiEMOy6BRwRbBUWriC4RT1AgJBrtMWqKsIPReF02oF2IAB2Yr0Fc1A4tscpyhwhhygANhGqAkBwkbavmgrrt4FRhGIXhTG53TiqQax9PMbwwHMAANAK+LIAqRrcFakEUxiAoXax5EaqHYJPBDNSQkAmxQ28u3PCOnwHO9GqBLhQVmEip1-CiqJXNcUzA+jd2g4sQ-gu8zwvQ8o5vNC48ffsX1sQwdmmKAM5-cj-zvAqCpXABdANUCDEMw1aawZmjFvEwHggYEIQgYG1WxrqoGM4zcRNaMz7MGMHT6wFaQl66wu9dp2a5zEJLh3UojDq9QwcK4jgvf3UTwoDYYjBwq2re6AvONzbwYJBec10whKD0NYQYx9E4pjPu4GAl9r7-F7PfGO9464YRfokN+H8v53l-rnEC+c6IQV3neZirE5AcTAFxHi-FBLCXkKJcSklpKySsgpNwylVLqVMJpHS+lDLGVMuZSy1lbIOSci5NyHkvI+T8oFYKoVwqRWirFeKiVkqpXSkgTK2VcpZEKsVcwpVypVRqvVJqLU2odS6r1fqg1hpjQmlNGac1FrLTWhtCAW0dp7VModY6p1TDnUujdO6D0novTsm9D6X0fp-QBkDEGYMIZQ14DDOGCMkYozRhjLGOM8YEyJiTLgZMKZUxpnTBmTMWZsw5lzHmfMBZCxFmLCW0tTCyyjPLFQitlaqw1lrHWesDZGxNmbC2VsbY4Ttg7Z2rt3ae29r7f2gdg4YQTvOHCH5TDanHmAVB14H53kQu3MiDBcGf1QDnICM8QBzwXkvFeqAowt1sNPICQA",
        "Bard II:___ N4IgdghgtgpiBcIBCEBOATABASWyANCAGYA2EAbgPaoAqMAHgC4IgA8ARgHwDK2AIgFEAigFUB3GvFYB6LphoALGJm4BhAQDkBAfQDyAdS0AlbRoCCAWQGYADjFRFqUAM6YIYTAEswRb58bKYACuUOz2mJREmFDeQQFuAMaMnpRgzvheYOT+3gDmmOgwzoyoQUkpHqlumLmo7ljOCRAkMAB08krRnrkKjACebmBYNpQA7vZEQSSYRM3TEDZojJhBQ+GMnY6oCUURUQmUJGQ2zso2cZm2ZDuY7AMbymqaOgbGppYC7dyM9Xluyw9MDswAFUHtMIDCsVSuUqg8BgoKMpTstvNFKMlUhlAU8tHpDAITOYrJgYKE6jtXIDkowWuCUBhWgAdMAcVCcNmcAggH6oXIwRi6MBwRAlIJwQglbr81CqVLoHKpZwAGU82TAuRYAG1gEyQJ4oCNUD8QfpqOg9fA9RppGY9fhrboaJa9bMSKd7XqAGpGbDcADSdoQruaHoIesgsBdIGwzm4MBIRE9+sN1BNjGwIOjAAY9QBfDK6lNG9NmjDRm1Bh0gDRO6NusPVn1+wP10MwZORjvBmPOMwkNXd6sGkvuDNZnu5kAFzBFkdpsdli09yvJ2vOnsNofe30BoNW4jtzvQbsH2MAcUo6BonnsyfnxrHmcYOfzhb1D9L5ujAAUSGUAGt5EoACYDAeBtEgzANAAFmwXJ0B6XJGFyGxPCQBJsDMQN2DMPkAE1Rg0fCzCwgBHMwAE4SAAK3PVQzD4IRciQKB-QEMx2FyIQBAAVhg0YzBgMxlVyTxdG4c96DMUZdEIgAmISaCQegBBIVRVFyPhdASVQoFGfCkGVRxsEMhQzCgMwLP8ShnAAZm4SwMTI-1RgAWhoXJzwARlyMwAAkjFUf1KDMJBswgAAOUZcN0MiLEYdAAGp-MMvozB-IQzFyMAAC0ALc5wACkYJ-SBuAsGjVAURCkAogRQoArTAw0bAFFUDQADFuGcch-NybN-L47BVDAbgIBoMxDjMERdAAL1yPognYVR-xERzGNSsxyCgIQYMYchct0ZUFCQVZcjmmAivw-zcvw7gkCS8Rs3oJKYG4IqyNyvLyBIIxePoI6hGcVRvJIbh8I0CAkE6sxvLcoh9D4GiEmzEgAHZHPQETtlUZwyLI89GDIgA2JKoCQc8ku83K7M6vhVBEEg+DMSGaMcpBPDoiwbDACwAA15Jg8g7KS3IiqQfCf3k7NPAUfyNrXOsezFbcQGbPc23dNWu2jfyIDjYE1c-J8JwPKcZznVNH1Nb8V1tJWNwPLdkw11tNyPcNwBPaNYyMepKCge9rfTZ9oxJkn8wAXW5KVchlOUhkVNJlXqbUY8IGAiCIGAkmcTrqFVdVNUQHUPxDxc7YPcawH8PpjyjHtqvcfkLD6b4IBfL23f3ENteD0cQQ0EIwlQaM3O8uyLffYsF1t8se061AYGUfRPCOBvTz1ZuNRgNuO67ptd3d53PeHCuh5Hu8e0n6fZ3LwfGCXX9-wSICaBAsCIKg2D4MQhRkKoXQphbCnE8K5EIsRUiZgKLUTogxJiLE2IcS4jxfiglhKiXEpJaSskFJKRUmpDSWkdJ6QMkZEyZkLJWRiIwWyDknLE1ch5LyvkApBRCmFCK0VYrxUSilNKGUso5XyoVEqZUIAVSqjVFi9VGrNTMK1dqXUep9QGkNXiI0xoTSmiQGa81FrLVWkEdaVk+BbR2ntA6R0TpnQ1Jda6t17qPWeq9d6n1vq5V+v9QGuhgag3BpDaGsN4aI2RqjDGWMca6XxoTYmZMKZUxpnTBmTMWZsw5lzc8PM+aC2FqLcWktpay3lorL2useznkHGYWEYBXbH17jyUoxsL6MGHqEa+5to7cizjnPOBdUCpyGM4dO04gA"
    ];
    
    @override
    List<String> levels = ["SKAIA'S TOP IDOL", "POPSTAR BOPPER", "SONGSCUFFER"];
    @override
    List<String> quests = ["allowing events to transpire such that various quests complete themselves", "baiting various enemies into traps for an easy victory", "watching as their manipulations result in consorts rising up to defeat imps"];
    @override
    List<String> postDenizenQuests = ["musing on the nature of death as they wander from desolate consort graveyard to desolate consort graveyard", "staring vacantly into the middle distance as every challenge that rises before them falls away before it even has a chance to do anything", "putting on a performance for a huge crowd of awestruck consorts and underlings", "playing pranks and generally messing around with the most powerful enemies left in the game"];
    @override
    List<String> handles = ["bat","benign", "blissful", "boisterous", "bonkers", "broken", "bizarre", "barking"];

    List<String> bureaucraticBullshit = <String>["is posting bail after being in the wrong place in the wrong time.","was fined for being in the wrong place at a the wrong time.","was fined for causing 'a ruckus'. "];


    //for quests and shit
    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    Bard() : super("Bard", 9, true);

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * -0.5; //good things invert to bad.
        } else {
            powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
        }
        return powerBoost;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be destroying ${rand.pickFrom(me.aspect.symbolicMcguffins)} in everyone. ";
    }



    @override
    void initializeItems() {
        items = new WeightedList<Item>()
        //things that let you destroy yourself.
            ..add(new Item("Cod Piece",<ItemTrait>[ItemTraitFactory.CLOTH,ItemTraitFactory.LEGENDARY,ItemTraitFactory.FAKE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.WOOD],abDesc:"God damn it, MI. "))
            ..add(new Item("Poisoned Candy",<ItemTrait>[ItemTraitFactory.CANDY, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.POISON],shogunDesc: "Not So Sweet Treat",abDesc:"I guess CodTier is okay."))
            ..add(new Item("Cursed Lyre",<ItemTrait>[ItemTraitFactory.DOOMED,ItemTraitFactory.WOOD,ItemTraitFactory.CALMING, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.MUSICAL],shogunDesc: "I Don’t Know What This Is Normally",abDesc:"I guess CodTier is okay. Sort of."))
            ..add(new Item("Snare Trap",<ItemTrait>[ItemTraitFactory.CLOTH,ItemTraitFactory.DOOMED, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.RESTRAINING],shogunDesc: "The Perfect Trap",abDesc:"I guess CodTier is okay. But still. The actual codpiece. You fleshy meatbags and your weird shit."));
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        //modify others
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        target.modifyAssociatedStat(powerBoost, stat);
    }

    @override
    double getAttackerModifier() {
        return 2.0;
    }

    @override
    double getDefenderModifier() {
        return 0.5;
    }

    @override
    double getMurderousModifier() {
        return 3.0;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Festivals","Carnivals", "Parades", "Celebrations","Jamboree","Fairs","Amusements"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Celebrate the Win", [
                new Quest("After all the bullshit the ${Quest.DENIZEN} has put the native ${Quest.CONSORT}s through, the ${Quest.PLAYER1} figures they could use a break. They decide to revive a planet wide ${Quest.MCGUFFIN} Festival to get morale back up."),
                new Quest("A small ${Quest.CONSORT} is sobbing and ${Quest.CONSORTSOUND}ing after losing a carnival game. The ${Quest.PLAYER1} decides that this is not a day of losses, and begins rigging the games to have a higher pay out rate than normal. Soon the land is filled with the sound of happy ${Quest.CONSORTSOUND}s."),
                new Quest(" The ${Quest.CONSORT}s who were running the carnival games are now bankrupt. Their wailing and ${Quest.CONSORTSOUND}ing fills the air. Fuck.  Who knew actions have consequences? The ${Quest.PLAYER1} arranges 'anonymous' donations to them and decides that maybe they should just quit while they are ahead. ")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Lead the Parade", [
                new Quest("A group of jubilant ${Quest.CONSORT}s are following the ${Quest.PLAYER1} around. It's kind of flattering, but it sure is drawing a lot of attention!"),
                new Quest("Even more ${Quest.CONSORT} are following the ${Quest.PLAYER1} now, ${Quest.CONSORTSOUND}ing about how they defeated the ${Quest.DENIZEN}. Wow, this is actually kind of embarrasing. "),
                new Quest("Oh god, somehow there are PARADE FLOATS involved now? The line of ${Quest.CONSORT}s have drawn a huge crowd to watch and ${Quest.CONSORTSOUND}.  It looks like whole roads are being blocked off by the event, and nobody is getting any work done. The entire day's productivity is destroyed, and it isn't even the ${Quest.PLAYER1}'s fault. ")        ],
                new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            //front tail!!!  (seriously, daimidaler prince vs penguin empire was SO FUCKING WEIRD
            ..addFeature(new PostDenizenQuestChain("Behold the Glory of CodTier", [
                new Quest("The ${Quest.PLAYER1} hears tell of a legendary artifact, so beautiful, so sleak and aerodynamic that all who behold it are moved to tears. They need it. SO badly. That glorious front tail. Now that the ${Quest.DENIZEN} has been defeated, perhaps they can finally focus on finding it."),
                new Quest("The ${Quest.PLAYER1} has journeyed far and wide, going so far as to make pacts with the dead. Finally. They have it."),
            ], new CodReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            //space player near guaranteed to do this.
            ..addFeature(new PostDenizenFrogChain("Pull the Strings of a Universe", [
                new Quest("The ${Quest.DENIZEN} has released the frogs from their balloon prisons. The balloons sink and land all over the land, and the newly freed frogs happily hop out. The ${Quest.PLAYER1} organizes a huge festival for all the ${Quest.CONSORT}s themed around finding and collecting frogs. They sit back and allow events to transpire. "),
                new Quest("The ${Quest.PLAYER1} presides over a festival competition where ${Quest.CONSORT} contestants try to breed the best frogs."),
                new Quest("The ${Quest.PLAYER1} sets things up such that the final frog was always going to be right where it needed to be.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)
            ,  Theme.MEDIUM);
    }


}
