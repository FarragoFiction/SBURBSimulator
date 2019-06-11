import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Lord extends SBURBClass {

    @override
    String sauceTitle = "Shogun";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 2.01;

    @override
    List<String> associatedScenes = <String>[
        "Lord I:___ N4IgdghgtgpiBcIAyB7ATgEwAQEkQBoQAzAGwgDd0AVGADwBcEQAeAIwD4BlHAEQFEAigFU+nKvGYB6DlioALGFk4BhPgDk+AfQDyAdQ0AlTWoCCAWT5YAxiihQIYDAGcsELE-skSWAOZoUAK4ADlgoRFhQAJZgkShgLvQo1rZBJDD0im5OkRgwAI4BME70WEToWPQKUAB0SgFoMPgVCkqqGjr6fEamFskBJNhyFIoYcYqVECXZuQVFJZUwUE4wJERNrAElAO4KYFgAnoFYQ+SZWCQo+xDefoEhYaUoXihbMGhOTTv7WKwoC2gAflkLRU6i0ekMxnMfAA5C4ojE4i4GkF0CVWBArABrLBbSKVdwQbBgGBbJzwZqKab5QrFLAYHJgGElBrXEjfE6ZLzNSYRAJWOQVJIoU5oLDRCpvJahcINLYQTBOWomEppCB0hYRaKxeLuGCLLBBOT7bJWNnfFBYiD7WryRSg9oQrpQ3rXJxJIj6kguNwkfH0NIRdCKCUChU+RQit6UqA8vasGBlBrVAA6YDYaHYGfYBBA9HD6W0JKY9DQhVzpciPgjaGUcQZ9B1TiQkXI0R8TAA2sAUyBIlBUWh82B6Lp0Bhe-Be2pJCZe-hp9oqJPe0Q3TB572AGoGHCcADSc4Qq-Xm-A0A3x5AOCcnBWRDP-cHw-oOBHK5AAAZewBfJo9vsBzRBxR3HD8ZyPBcQDUJcPzXb1Lygnc90PODTwIXtIFgD8bxMP1TkfIChxAt96A-b8QD-LAAKfYCRzHTBwNnM8YOXK9S0KM9kIPI8p2IdCoKwy8+JvABxFAMCoSI3kI58SPfK8KKomiiJfBiJyvAAFEh+RxKhLRgMB4E0EysDUAAWHAfAwHw5B8egfCCSIACErBwExD1YEw0B8ABNLY1F8kx3LyEwAE4SAAK1E5QTB4AQfGcqB9z4ExWB8AQ+AAVnMrYTBgEwkB8SJtE4UTaBMLZtH8gAmfKqGc2g+BIZRlB8HhtCsZQoC2XznKQMocD6uQTCgExRvxFAnAAZk4cw-jyfctgAWioHxRIARh8EwAAkDGUfcUBMZzPwgAAOLYvO0PIzHoDAAGodr6-YTE0gQTB8MAAC0sWWpwAClzM0yBODMSLlDkGznNCvgjqxdrDzUHA5GUNQADFOCccgdp8T8duynBlDATgICoEwnhMIRtAALx8fYAlYZQdKEOa4qekxyCgARzPocgvu0JA5GcgIwB8amYH+3ydq+3zOGc+7RE-Wh7pgTh-ryL7vvIEgDCy2h+YEJxlA2khOF8tQIGctGTA25aiF0HhIqsT8SAAdjmjBCrQLqnDyPJRPoPIADZ7qgZzRPujavumtGeGUIQSB4ExzciubnMiaKzCCMAzAADRq8zyGm+6fH+5zfM0mrP0iOQdtZljYPYstEO3XceLQhCzyEj8dvVTgrEMlvALkkdSPI39-17WjiPosCrwghu2L4+Dli4tvUKvFeh+7q8bwMBxRigWS6NfBS+Om6bfwAXQrNAqxrOtHHxJskAPrsb8IRNPSsegnDR9AWxtlFl2FSI9QKMS0i8GSGFzzYSvBDBwEYzD7E4PmMiMDuIb2XgJKeqkQJqACFABMaAPwbUvpRSew8T7qQ-NpXSsgDJGRMpoMyllrK2Xso5FybkPJpW8n5AKQUQrhSijFOKCUkopTShlbKuV8qFWKqVcqlVqpbDqjABqTUWptQ6l1HqfUBooCGs5EaY0JqJBmnNMwC0lqrXWltXa+1DrHVOhdK6N07qPWeq9d6n0fp-UBsDCAoNwaQ0SjDOGCMTBIxRujTG2Ncb4yyoTYmpNyYkEpjTOmDMmYBBZuNHg7NObc15vzQWwtRbi0ltLWW8tFbK1VurTWX1ta631toQ2xtTbm0ttbW29tHbOzdh7L2Ps-YB2DqHcOkdo6x3jonZOahU7HQzqJLOOd86F2LqXculdq613rjAnefFRKtgKj-HUa8UK8V7BxIe08XwEKIdAviSkP4gC-jAH+f8AEHycO-SiQA",
        "Lord II:___ N4IgdghgtgpiBcIAyB7ATgEwAQEkcgBoQAzAGwgDd0AVGADwBcEQAeAIwD4BlHAEQFEAigFV+XavBYB6TlmoALGFi4BhfgDl+AfQDyAdU0AlLeoCCAWX5YMKGAGcwAcgZZSASwDWShvIgufSnKmhgDi-NQmFto6xmaWXFi+dlgADigA7jBoWBBg2AEAntYoTgwAdHKKymqaugb8sVFYbskBWCVKbmBYAMa+aADmSopoMAQ5xAxZOaSkFQowRQwQXr0lDGgopO3EWG3UwWERcdGN8Y7JaZloFaaT0xCz4z5+F1jpvi5uLrC5rShYNhKCBYVCYMoAHTA7DQHBhHEIIGWgxgDB0YDgiA2AFc4EQNm4BkM0CoShhvm4SnYkG4KF0BswANrACEgNxQNJoZZgBh6dAYVnwVnqKSmVkEYU6aiC1k4mDi1kANUMOC4AGkxQhWcRHnZ5YRWZBYDKQDg7FwYKRiAq2Rz0NyGDgeSaAAysgC+4xZts5Dr5mBNIs1EpA6ilJp1pD1NuVqo1Ed1+pDRv1QtNdlM7goSdZ7N9uUdzq1IDdIE9WG9eftBf9AuLQZtYelxcj0YNIFj6s1ablNpTJrNIRQGGobiyNqrXILToYro9XtzdqnPNrJoACqRsT0PHIUF4wPAtEesOoACw4AYYAbyAYMAYpNwAIR6OFMGrYpkGAE10uov6ZXwAR1MABOUgACsQhUUxeEEAZHygNV+FMNgBkEfgAFZT3SUwYFMJABjcHQuBCOhTHSHQfwAJlw6hHzofhSBUFQBl4HQehUKB0i-R8kGIFAcB4+RTCgUwRO+FA7AAZi4CwUAYQC1XSABaagBhCABGAZTAACUMFQ1RQUxHxdCAAA50g-HRAPMBgMAAah0niClMNdBFMAYwAALQ8ZS7AAKVPNdIC4cxwJUeQr0fYD+CMjxWI1dQcHkFR1AAMS4OwKB0gYXR0zCcBUMAuAgA4tlMYQdAALwGApsTYFRN2EWSYKc0wKCgQRTwYCgvJ0JB5EfbEwAGKqYH8r8dK8r8uEfeyxBdOh7JgLh-MArzvIoUhDAwug+sEOwVA00guC-dQIEfNLTA05TiD0XhwJ6F1SAAdlkjB8LQDi7EAwCQgUgA2eyoEfEJ7I0rypLS3gVGEUheFMM7wNkx83Eg8wUjAcwAA0qNPCgpPsgZ-MfL81yol03HkHSWsbcMW0TGMVS7BMoxzcBoFTVkdIgc0ehgDEJyXB0ZznMsFx9asV35ddN23Xd90PY8zwvK8bzvB9n1fd9PwGH8-wA0xgLAyDoNg+DEOQ1D0KwnC8IIoiSLIijqNo+jGOY1j2M47jeP4wTH2E0TxIYSSZLkhSlNU9StN0-TDOM0yLKsmy7Mc5zXPczyfL8wLgogULwsi+CYrihLTCSlL0sy7LcvyjDCuK0rTHKyqarqhqmpa3g2o6rqer6gahpGsaJqmma5oWpaVrWjavK2na9p0A6jpOs6Lqum67oep7Xvez7vt+-7AKBkGwYhqGYbhhGkZRtGQgxrHcfxwnidJ8nKep2n2ybVm2xDTs8YGZsz7JzE0PM+YC3ZpOEWRY0ylnLJWYWNYZb1lFHTZsaZWzs0Ad2bUjN2z9mLGaQwuQbBQCFvmHkotiwAwBvOCsi4qG8lQWmBsP96ZYIIQA5mQCuEgMIWA4hdgNwQAKOOdsMDpxwNZAgiWUjpYBgQGAbETxJSYNlGgXETM4x4JINww0Qi0zmAKDoB8YBKRgB0MQagEAUSOjsCEUYfgsgKFyIqR42jJHIOoTIkAGkEEAF1EQEiJFkUkeQKRUiQGQpkwSiAwGIMQGAPQGB2DSugGkdIRpMiQcw1cxY1wZAkcmIxrIIq5CGCYrgyxZztlwX-aBPiGDqGxFAIEaATQaSknIxhktlwsKUWmDcW4dzUD3ALJWWgTznkvNeW894nwvjfChXW+t-xAVAhBKCME4IISQihNCmFsK4XwoRYipFyKUXSDRGAdEGJMRYmxDiXEeJ8QEkJESYkoASWkrJcw8lFIqTUppbSekDJGRMuZSyphrK2Qck5R8Lk3IeW8r5AKQUQphQilFUuph4q8ESslVKGUso5TygVIqJUyqkAqtVWq9VGrYmamJHu-4+7dV6v1Qaw1RrjUmtNWa80uCLWWqtdam1tq7X2odY6p1zqXWurde6j1npvVMB9JAX0VA-T+oDYGoNwaQ2hrDeGiN1DI2MvfR+OM8YEyJiTMmFMqY0zEqA40xZDAwCgCgbMphUmWJ0SzYB-8mFSxaW0jpYtEFhoGQU4ZcsxkTIPEeaZKs5nq0WVrFZH5vy-g2UbLZptdkWwOdbY5dszmO0uS7G5bsHme2eT7N5-tPnBx+aHP5EcgXR1BXHCFidoUp3henJFmdUU5wxfnQuOKS6mFivi8ulcSU13JfXRu1KW60rbgyzuzLu6906pywePKR78vHkKqeYrZ6SsXjK1e8qN5Ku3qqveGqD46qPvqs+RrL6mpvhau+6NMa2pfg69+zqv5usER6tMIRaR4QDSUINfDNFeJDAoiN7SJHwIYXk8N8bhToJg1zEAFSRowDMV0Sx1jzA4N4Xo7BlDw2tOw504sykAkeniSARJyTUnpMyWQuwcSyxAA"
];
    
    @override
    List<String> bureaucraticBullshit = <String>["needs to file some proclamations.","has some laws to put into place.","needs some decrees to be filed in triplicate"];

    @override
    double difficulty = 2.0;
    @override
    List<String> levels = ["LORDLING", "DELEGATION DELIVERER", "BUFFER THAN KR"];
    @override
    List<String> quests = ["inspiring the consorts to produce great works of art", "causing events to transpire such that the consorts improve themselves", "avidly learning about consort history and art"];
    @override
    List<String> postDenizenQuests = ["inspiring the consorts to rebuild their land", "showing the consorts what strength through adversity means", "hanging back and watching the consorts rebuild", "making sure the recovery process is going as intended"];
    @override
    List<String> handles = ["lording", "leaderly", "laughing", "laughsassin","lawful", "lordly", "legendary", "legionnaires", "lacerating", "lactate", "legislacerator"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;
    WeightedList<Item> duttonItems = new WeightedList<Item>();


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Lord() : super("Lord", 19, false);


    @override
    bool highHinit() {
        return true;
    }

    @override
    void initializeItems() {
        duttonItems.add((new Item("Dream Bubbles Book",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSY, ItemTraitFactory.BOOK, ItemTraitFactory.DUTTON])));

        items = new WeightedList<Item>()

            ..add(new Item("Deck of Uno Cards",<ItemTrait>[ItemTraitFactory.CARD, ItemTraitFactory.PLYWOOD, ItemTraitFactory.CLASSY],shogunDesc: "Shoguns Card",abDesc:"Some kind of memey bullshit."))
            ..add(new Item("Lord's Cape",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSY],shogunDesc: "Shoguns Cape",abDesc:"Lord Shit"))
            ..add(new Item("Drawing Tablet",<ItemTrait>[ItemTraitFactory.SMARTPHONE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSY],shogunDesc: "Shitpost Etching Table",abDesc:"Have fun drawing grids."))
            ..add(new Item("How to Make Friends And Influence People",<ItemTrait>[ItemTraitFactory.LEGENDARY,ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.ENRAGING, ItemTraitFactory.BOOK],shogunDesc: "Book for Nerds",abDesc:"Good luck with that. You'll need it, asshole."));
    }


    @override
    bool isActive([double multiplier = 0.0]) {
        if(multiplier >= 0) { //if no stat passed, act active
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
        return 3.1;
    }

    @override
    double getDefenderModifier() {
        return 0.1; //john pounds the living daylights outta calliborn, AW points out
    }

    @override
    double getMurderousModifier() {
        return 3.1;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} hoards the benefits of  ${me.aspect.name} while having  ${target.htmlTitle()} shoulder the burdens. ";
    }

    //TODO using the existing framework, how would i make it so that regular things matter based on target, too? i want to be lazy here. prefer caring about land update.
    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;

        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //give bad to me and good to you.
        if(powerBoost >=0) {
            p.modifyAssociatedStat(powerBoost, stat);
        }else {
            target.modifyAssociatedStat(powerBoost, stat);
        }
    }

    //rule, control, delegate
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Castles","Keeps", "Fortresses", "Nobility","Forts","Moats","Dungeons"])
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Command Minions to Breed Frogs", [
                new Quest("The ${Quest.DENIZEN} has been subjugated, their hoard of frogs released. Across the land castles and dungeons suddenly are accessible, and filled with croaking. The ${Quest.PLAYER1} comands that the ${Quest.CONSORT}s collect the frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} sits back and enjoys a tropical drink. The frogs will be ready eventually. "),
                new Quest("A ${Quest.CONSORT} minion has finally found the final frog. The ${Quest.PLAYER1} rewards them, and punishes everyone else for failing. "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Conquer Everything", [
                new Quest("As soon as the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s disolve into civil wars and infighting. It will take a strong leader to unite the land, and the ${Quest.PLAYER1} is up to the task.  "),
                new Quest("The ${Quest.PLAYER1} has subjugated/assimilated about half of the ${Quest.CONSORT} factions, at this point. They are surprisingly good at following commands, and everything is running with clock work efficiencey."),
                new Quest("The final ${Quest.CONSORT} commander surrenders. The ${Quest.PLAYER1} controls everything now. They are the Lord of all they survey. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)


            ,  Theme.MEDIUM);

        addTheme(new Theme(<String>["Dutton", "Charles","Fathers","Prophets","Dew"])
            ..addFeature(FeatureFactory.DUTTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Command Minions to Breed Frogs", [
                new Quest("The ${Quest.DENIZEN} has been subjugated, their hoard of frogs released. Across the land castles and dungeons suddenly are accessible, and filled with croaking. The ${Quest.PLAYER1} comands that the ${Quest.CONSORT}s collect the frogs in the name of Lord Dutton. The ${Quest.CONSORT}s agree with confused, yet enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} sits back and enjoys a tropical drink. The frogs will be ready eventually. "),
                new Quest("A ${Quest.CONSORT} minion has finally found the final frog. The ${Quest.PLAYER1} rewards them, and punishes everyone else for failing. "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Praise Dutton", [
                new Quest("As soon as the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s disolve into chaotic shitposting. It will take a strong leader and a glorious Cult to unite the land, and the ${Quest.PLAYER1} and their fervant belief in Lord Dutton is up to the task.  "),
                new Quest("The ${Quest.PLAYER1} has spread the word of Lord Charles Dutton to about half of the ${Quest.CONSORT} factions, at this point. The Cult of Dutton unites the chaotic shitposting landscape."),
                new Quest("The final ${Quest.CONSORT} shitposter surrenders. The ${Quest.PLAYER1} controls everything now. They are the Lord of all they survey. ")
            ], new ItemReward(duttonItems), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
