import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Muse extends SBURBClass {

    @override
    String sauceTitle = "Wayward";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 2.01;

    @override
    List<String> associatedScenes = <String>[
        "Muse I:___ N4IgdghgtgpiBcICyBXAzjABASRAGhADMAbCANwHsAnAFRgA8AXBEAHgCMA+AZWwBEAogEUAqgO414rAPRdMNABZZuAYQEA5AQH0A8gHVNAJS3qAgkgGZGEANYw0mCJjQBLACYwAjinuNMFMGIATysKTEIXMDdMFz9GMPYsAHcIVLSIEPiwtxdCCIBjFGI-QmorJShHOKVMAAcqexgwPygKWGaAOkwAMRgYYkiAc0wPQhgIRhg3PHLlNU1dAwFjMwtMACt0P1dGB0j-MCxa0nysCCjMFNi0Lu4UBswmihRBhRmIQkmqTAbGe7AhqFZphvL5MIMXGQYFQZowaqoNNp9EYTOZLDk0PkKFCqA40G0YAEsAoIA43ETgaC0CUynCYFBbkk+owAISYABCKD8sSs-wczz8SQUFBgOPKE0upNCFBsjmIxGBgwoFGixGVjBmxHGZEBdMwCIWyOWqLWSViCkwYAocMB7C5wIYtWhLiap38hEwWsYjEB9Qo7C1UDxFGIUNmQf6UJuAB0wBwqJx45x8CBrFRBjBGDpDixGFQfCm8y5BhmqCoAjkfQE0AAZSFDFgAbWA0ZALigtWo1maemoblb8Fb6mkplbeCHOhoA9bhAgxAwY9bADVDNhuABpUcIGdzhf4VuQWDTkDYNDcfqERdtjtd86MbDNY8ABlbAF8Zi3r52qN3GL2qP224gMOW7jsBk7HrO84wFeK5rpukG7jB+7gNAyGDieaCmAMUJXu236-g+jDPm+H6tvht49n2x4gVe6gQUBeY+LBq4bluGFQXuYGHuhrangA4iqNAulQeE3j+d5ESRIDvpgn4URJVEAceAAKxAoPkso0DKTTwFo+mYOoAAs2CDG4ryDIwgy1C47L5NgpibuwpjpgAmkk6iuaYDmeKYACcxDrPxKimHwQiDOyUDrgIpjsIMQgCAArEZSSmDApg1hCOjcPx9CmEkOjuQATGlNDsvQAjECoKiDHwOj5CoUBJK57I1qU2AtQophQKY3WxBQaAAMzcOY1qeOuSQALQ0IM-EAIyDKYAAShgqOuFCmOyT4QAAHEkzk6J4SCMG4ADUS0tUEpgqUIpiDGAABaNiTWgABSRkqZA3BIOsKgKOZ7K+QIG02LVm7qNgCgqOo3TcGgZBLYMT5LUl2AqGA3AQDQpghqYIg6AAXoMQQoOwKjqSII2hRdphkFAQhGYwZAPToNYKJyYCDATMCva5S0Pa53Dsqd4hPvQp0wNwr2eA9j1kMQhiJfQLNCGgKhzcQ3CueoEDst0phzZNhB6Hw6z5E+xAAOwjW4GVUA1aCeJ4-GMJ4ABsp1QOy-GnXND2Dd0fAqCIxB8KY2vrCN7IuEFSC1GASAABpFUZZCDadgyveyrkqUVT4uAoS1U3RDEYUxyFgXBbGIdBV48ceS2ktwpyHGJBGSY+QEvjJZFfpRf7UUBtEofRU5AZxFfLqxCHj0hddocep6GOc5JQG3-dSUBg2DW+AC6hZUMWpbllEsQuNWNYr02+8EDAeQwPkuzdNQdY6pzTbyeJv7-oBGFLeMxQFDzyPEBP65wMxICCNwawxEUJVxnhxOeKEFK-nUCgKAiRRJATmjvHuclyJfzvD-VS6lNLyB0mAPSBljKmXMgoSy1lbL2UcrFFygx3KeW8qYXyAUgohTChFKKMU4oJWSqldKmUXDZVyvlQqSQSowDKhVKqNU6oNSai1NqFAOrsi6j1Pq8QhojSQGNCa01ZoLWWqtdam1tp7QOkdE651LrXVuvdJ6L13qfQgN9X6-0IpAxBmDUwEMoYwzhgjJGKNEpowxljHGxA8aE2JqTcmKBKa9T4DTOmDMmYszZhzLmPM+YCyFiLbgYsJZSxlnLBWSsVZqw1lrHWesDZGxNmbC21tTC2xrPbFQjtnauw9l7H2fsA5BxDmHCOUcY78TjgnZOqd06Z2zrnfOhdi4oXrkBfikJ0qP3PmAFi8F2KtnLuvRSjA0EYOhNJV8N8QB3zGI-NAz8qCXyiGga+MkgA",
        "Muse II:___ N4IgdghgtgpiBcICyBXAzjABASWyANCAGYA2EAbgPYBOAKjAB4AuCIAPAEYB8AytgCIBRAIoBVQT1rw2Aem6ZaACyw8AwoIByggPoB5AOpaASto0BBJIMyKIaTGkqxMAB0oB3GNXyYOKJpiZlAE9MahgIEgBLAC8sQIh-QKxaMyMAcUFaUwsdXRNzSx5MABNKGDQwAHImADoFYMwAY0oUEmKXakoOCA4SEPQ45Uw1TVzDQXycyrtlEmc6gCEYSLAAc0wITFQMb3imacxGCEamPsw3G0Shka09ccnLEphGyOLygMoSynhMVeoIMD+BxOShEALKSLUTDuMAudyeD7g5KpDJZAq5B4SGoAHTAnGoXHxXAIICYEGoqxgTF0YDgiCY1BQcEIDMiq0p1FUlDAxUiTEi3LQABlIuQVqtWABtYDYkCRKCuahkwH6GjFWXwWUaGRmWX4LW6Wga2UMpl62UANSM2B4AGldQhZUQIhhzeBoDBjSBsGgeDASEQ3fLFcqmNhAV6AAyygC+3hlcoVNFDquo6sdIG1Dv1mcNXudJFdBEt1rtDs1xBdnuL7tgXp9Zii5GrOeDyYBYYjGejIDjmATbaVHdT6YrWbdGjzGYLRZzVpt9q9ppbssgdYzPrSlGKtEiniDSaHgPDTCjsfjssHKbVXoACiQUI0ANYKShPmBgeDab+YDQAFmwVZilWRRViYVZnEiBZGmwMx7Q4MwKQATTcDQkLMWCAEczAAThIAArNJVDMfhhFWBYoFtQQzA4VZhEEABWP83DMGAzCFVZIl0Hg0gYMw3F0FCACZWNoBYGEEEhVFUVZ+F0RpVCgNwkIWIUiEobAVMUMwoDMHS+UoNAAGYeAsSgmEw203AAWloVY0gARlWMwAAkjFUW1KDMBZIwgAAONwEN0TCkCYYoAGoXJUoIzFvYQzFWMAAC0n2stAACk-1vSAeCQfDVEUYCFmwwQvKfWT7Q0bBFFUDQADEeDQcgXNWSMXMY7BVDAHgIBSSgSDMURdGiVYghQDhVAfURTJIqKzHIKBhD-JhyCS3QhUUBYUDWWJ0qQlykqQngFnCiRIwYcKYB4dLMKS5LyBIIwGIYNbhDQVQHJIHgkI0CAFjqswHOsoh9H4fDGkjEgAHZTOKdjqAUtBMMwtILIANnCqAFjScKHKSoy6v4VRRBIfgzB+-DTIWSJCKQZwwCQAANIS-3IIzwtWdKFiQ28hMjSJFBcmaJynCtlzdecy3zKs3TXasKxc2weEaD8V0TEMOxPM9ewvdX2xVG8M3vR8X1oN8Py-H9-0A4DQPAyDoNg+DENWFC0IwsxsLwwjiNI8jKOo2j6KYli2I4rieL4gThNE8TJOk2T5MU5TVPUzSFm03T9KYQyTLMiyrNs+ynNc9zPO83yAqCkKwsi6LYvixKUrSzLsogXL8sK8iSrKiqzCqmr6sa5rWvahjOu63qzH6wbhtG8bJpQaa9P4OaFqWla1o2radpgPaDqOk6zouq6brupKHqel7dDej6vp+v6AaBkGwYh6HYfhxHkdRzCMaxnG8YEyJiTMmFMqY0zSHTBmzNWbs05tzXm-NBbCxrJOI004ZY1klouDM4saxyy9IrX0KtaQHg1seLsFYex9gHIea8aYvTjlQaLJ0mC5ylhwRWGcasCEbjQEYAEpQoBkP1p2U8GY0Zo3PP2S8dDhyGzHDqEW6CuFsJLAucsrDCw8I9PWNA94IBBH3DWK8mtKGymobrUxBsGEIDAK0EgOY0HS20RLDhmjKyuPwbojMSAgi6EgmAAUYBdBEFoOSSkYY0BpDCAkTwSgAQWgiGaExciKHiIrNZBisYAC6JJWTsk8FyHkfJgnCkEVKPJhAYBECIM8JgaA6o0BFGKNYUpaHkKYCOQh4QSCBFlj4isBUASUj8TwMk4j2EaJcbOWRnSNAoCgBwYxFYHJGUsTIvWR4ukKNlMbZ8r53yfm-NoX8AEgIgTAhBKCME4I0Rdm7dCWFcIESIiRMiFEqI0TooxZirF2KcW4rxfigk3AiRgGJCSUkZJyQUkpFSakNJaR0npKABljKmSQOZSyNk7KOWcm5DyXkfL+UCmYYKoUIpRQWDFOKCVkqpQyllHKeUCpFR7mYcq-BKrVVqg1JqLU2odS6j1PqA0hojTGhNKaM1V7oXXstVa61NrbVWLtfah1jqnR4OdS611br3Ues9V671PrfV+v9QGwNQbg0hjDMwcMhQI1UEjFG6NMbY1xvjQmxNSbkw0JTbyECoFMxZmzDmXMeZ8wFkLPSAz1wViMDAKAlBmxmBOMEtx0zcGMjVtYpgCylkrIsdIjpojulGwfAcs2RzLanOthcu21zHZ3IQshVCTzPYvJ9u8-2Xyg6-NDgCiOwLo5gtjlChOsLk4IrTsirOaKc4Yvzjiou+LS5EorqS6ulK640obvS5uTK24dzZd3MwpVOV9wHny4egqx4T1FdPcVc8pWL2XrNeVi1FVbxVbvfemqj46pPvq8+l9jU31NffC1T9rWvztR-J1X83W-w9QA71wC-VgKDbTemobYERoQdG5BcbvEJtlGkUUbEM3cizVLDBXjWxpILYs5Z1BtY0LmeW3ZmYlFkflrKYZawYABJWME0JSA1bYI8dwkR2zC1sa9Nk3sVSQA1LqScRpzTBFoEqb2IAA"
];
    
    @override
    List<String> levels = ["AMUSING AMATEUR", "SPOTLIGHT POINTER", "GREEK GOD"];
    @override
    List<String> quests = ["inspiring the consorts to produce great works of art", "causing events to transpire such that the consorts improve themselves", "avidly learning about consort history and art"];
    @override
    List<String> postDenizenQuests = ["inspiring the consorts to rebuild their land", "showing the consorts what strength through adversity means", "hanging back and watching the consorts rebuild", "making sure the recovery process is going as intended"];
    @override
    List<String> handles = ["magical", "musing", "majestic", "managerial"];

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
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Muse() : super("Muse", 18, false);

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Feather Pen",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSY, ItemTraitFactory.FEATHER],shogunDesc: "Feather Object to be Dipped in Black Liquid",abDesc:"Oh my god, did JR really not know how to spell 'Quill'?"))
            ..add(new Item("Half Finished Bust of Snoop Dog",<ItemTrait>[ItemTraitFactory.MARBLE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BUST, ItemTraitFactory.BLUNT, ItemTraitFactory.LEGENDARY],shogunDesc: "The Gods Refused to Let This Object Finish Completion",abDesc:"Meme Shit"))
            ..add(new Item("Book of Poetry",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSY, ItemTraitFactory.BOOK],shogunDesc: "Ocean Man Lyrics 50,000 Times: The Book",abDesc:"Hope it inspires you."));
    }


    @override
    bool highHinit() {
        return false;
    }
    //TODO okay i think i know what i want to do. have isActive take in an optional parameter of multiplier. if positive muse is passive, if negative muse is active
    //and vice versa for lord.
    @override
    bool isActive([double multiplier = 0.0]) {
        if(multiplier < 0) { //if no stat passed, act passive
           // ;
            return true; //muse applies it to self if bad.
        }
       // ;
        return false; //to others if good.
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost; //no change.
    }

    //you don't expect a muse to start shit
    @override
    double getAttackerModifier() {
        return 0.1;
    }

    @override
    double getDefenderModifier() {
        return 3.0;
    }

    @override
    double getMurderousModifier() {
        return 0.1;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} takes on the burdens of ${me.aspect.name} while leaving the blessings for ${target.htmlTitle()}. ";
    }

    //TODO using the existing framework, how would i make it so that regular things matter based on target, too? i want to be lazy here. prefer caring about land update.
    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;

        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //give bad to me and good to you.
        if(powerBoost <0) {
            p.modifyAssociatedStat(powerBoost, stat);
        }else {
            target.modifyAssociatedStat(powerBoost, stat);
        }
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Music","Dance", "Poetry", "Inspiration"])
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Inspire Frog Breeding", [
                new Quest("The ${Quest.DENIZEN} has allowed inspiration to flow once more. The frogs are no longer too depressed to croak, and are much more easy to find. The ${Quest.PLAYER1} asks the ${Quest.CONSORT}s to help them collect frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} cheers them on and soon everybody is working just a bit better. "),
                new Quest("A ${Quest.CONSORT} child has tripped over the final frog. They cry and ${Quest.CONSORTSOUND} at their skinned knee, but their pain is quickly forgotten when the ${Quest.PLAYER1} praises them for finding the frog.  Together,     "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.MEDIUM)


            ..addFeature(new PostDenizenQuestChain("Inspire the People", [
                new Quest("You'd think after the dramatic defeat of the ${Quest.DENIZEN} the ${Quest.CONSORT}s would be celebrating. Instead they are just kind of moping around. When pressed, they say they just don't feel like doing anything. "),
                new Quest("The ${Quest.PLAYER1} bugs and fusses and meddles until the ${Quest.CONSORT}s agree to put on a performance of the musical 'The Lonely ${Quest.PHYSICALMCGUFFIN}'. The ${Quest.PLAYER1} assigns parts that challenge each of them without seeming impossible."),
                new Quest("The performance of The Lonely ${Quest.PHYSICALMCGUFFIN} goes off without a hitch. The ${Quest.CONSORT}s recieve accolades and ALL the self esteems.  They are inspired to reach ever greater heights of acomplishments. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
