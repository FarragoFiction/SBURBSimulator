import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Smith extends SBURBClass {

    @override
    String sauceTitle = "Sculptor";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.51;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.01;
    
    @override
    List<String> associatedScenes = <String>[
        "Smith I:___ N4IgdghgtgpiBcIDKUCWAXAFgAgJIgBoQAzAGwgDcB7AJwBUYAPdBEAHgCMA+JXAEQCiARQCqApHXhsA9N2x1MMbEgDCAgHICA+gHkA6poBKW9QEEAsgOyoAztnQQbAaxgATbAHcMOAMZUwNug0AK4+6KhgAObYENhQjugwNAAOqDA+SsE2EdE2VLDYVMT2inFUgdgcqABeEDQ0SvGJNKgQpHao8ZEREBykMAB02KbEzdiRVDnjDRDo2P1RWHboVDE+AI7BqA3YNhCo7k1Jre0EJUqqGtr6RiYWVrbYyfsBDk45pACe2D51MMTBUj2VbxFy7YI7LCPeKBJKpdJKR5Fc7YTCoSKKCqbNoYT5DPgwGypRIxUhArAwbbYf7EWjoM4U5RqTS6AwCYxmSzYVxUQlgADkc0iMDmUFCOCowTmyKhdmyrhgm0JcwgoySKJhzXhGWsdj8UGS-USQwAmiLsC0MegAWTvnkGaVLiybuy7lzHsRUGS3J5vDFdjAAkpkRAfPrDbZMLAwHNaTQfjNwlF-ZFE55aE4BgAdMCcGhcPNcQggBw0YXoHRgOCIILBOBEILo4U0FT+VwYVD+GwAGVQFByrAA2sAsyBOsk6RAY3paK5R-BR+ppKZRwRFzo6PPR8Q2jYYKvRwA1Qy4JAAaRXCG3u-3hFHkFgW5AuBsSBgpGIB7HBsnMdwMafAAGUcAF8zhHb8JxoBxp1nJ8l0vNcQHUDcnx3dpbyQ49TwvNCby-B9bwXZ8bFMUg+0w0dx1-dB-3QIDQPAqif2gqd0BnGg5yvZDly-FDN242tKJAbDz0vYj0L3AjoCI0cXwAcSoVw6DSGgv2o1i-wA7jgJAMDsAgjSYPYuDuIABVIUInHkKgXDAeAtEc7B1AAFlwSJXAxSJ0EiVIACEfFwUwLw4UwyxNDx1BNUwgvWUwAE5SAAK3klRTD4IRIj8qAzwEUwOEiIQBAAVhcjxTBgUxu26HQkHkxhTA8HQIoAJgqug-MYARSBUFRIj4HQfBUKAPBNPzu1pXAxswUwoFMWaMHKABmJALCodB1jPDwAFo6EieSAEZIlMAAJQwVDPKhTD8wCIAADg8UKdHWcx0FcABqE6xs+UwzKEUxIjAAAtJxtpsAApFyzMgJBzCSlRME8vy4oEK6nH6i91FwTAVHUAAxJAbAoE7IkAk6StwFQwCQCA6FMKhSFMEQdGqSJPmCDgVEskRVvSr7TAoKAhBc9AKCBnRu0wPzgiiaoYHBk0TqBk0kD897xEAxh3pgJBwfWIHgYoUhDGKxhxaEGwVAO0gkBNdQID8vHTAO7biD0Pgkp8QDSAAdlW1wqpoIabHWdZ5I2gA2d6oD8+T3oOoGlrxvgVBEUg+FMO2ktWvzUBS8xkjAcwAA0WpciglveyJwb8k0zJawDUEwE7eb41DBJCYTRNw7jJOEwinxOxwkAyKt1JY4y6IYvSmMgmiOK44iELbgSJPwu8RJPMS8Iw6TH24l9DCnHkoHHqDJ+04ilqW0CAF1i0bSJm1bMB23CLtu2Pod76IGl0nQGweNaC9n7FEIchkJ5sQXk+GmYBcR71kiABGU5hTmE+EgBw9EN7d3EteXeG8jJsXUMEKAHAkhPm2gdG+M8DLMXPlA0yxFzAQEYJ0Eh2BuxWQQU+ZBUQYBoIwbML8OCd5SQIZAmMxDSHkO4lQxitC56aRMpxJ8FkrI2Tsg5Jyrl3KeUwN5XyqAApBRCmFSIEUooxVMHFRKKU0oZSyjlPKBUiqlXKpVaqqBar1Uas1DwbUYAdS6j1PqA0hojTGhNKgU0-IzTmgtFYNgVprQ2ltXa+0jqnXOpda6t0HpPRem9T631fr-UBiDMGkNoYQFhvDRGWUUZowxqYLGON8aE2JqTcmxVKbU1pvTRmzNWbs05tzXmfB+aC2FqLcWktpay3lorZWqt1ZIE1trXW+tDbG1NubS21tbb20ds7V27tPbez9qYAO3Yg4qBDmHSO0dY7x0TsnVO6dM7qGztdPO8kC5F1LuXSu1da710bs3VuG8B7cXkhRUwYROxgGEVvHuxEhJnxolIshakdJ32LH-MIgDgHHxsN-PSQA",
        "Smith II:___ N4IgdghgtgpiBcIDKUCWAXAFgAgJK5ABoQAzAGwgDcB7AJwBUYAPdBEAHgCMA+JXAEQCiARQCqgpPXjsA9D2z1MMbEgDCggHKCA+gHkA6loBK2jQEEAsoOwAHAK7oAzthiUYtAJ7ZqdsAGNlahJsP1oYCHRUNxcwdwBzL04YR3RqAHcYABNsOxtqMGwsGChsTi8i1FpsCEcbGD90bFQwVJCwiOa46qgIAC9O7B6U9zS6AGtHADoFJQ8AcjDsMGpGiDAPLAG7RxgSOzJCJepDzgc28MiwLqKdwZr0EfHnNIwcIuwlMhtvYIqqmrqDSaz0wEUKShU6i0ekMghM5is2Ey1GSpWS6GmuEaqGcmHS4JgXj2ZBIqDIZAJlRcTEB6A6+WcNWqKjQWEmAB0wFxaNxudwiCA6bQ4jB0LpYmx0LQ7HBiFLUHERbRVPlMhhUAyADJRTpsADawHZIFQUDytDpLX0dEyRvgRo0MjMRsI9t09FtRpIEDIO2dRoAakZcEgANJOhCe72+ohGyCwD0gXCOJAwEl+42mugW9C4FoJgAMRoAvodDRmzdmrbQbRGQA7wy6626E16fTB04Hg2GW1H2zHwNA+3bE44zGQon3GyaK2sc3na4WQCXsGXp1nZ1Wa8P6+mNM3a63o43O6Hw8PD5PY4OE0mAOLUTL0VDudNr82z3PoAvF0tGt+V60EwABTIOw-DGBRqDGGAwHgbR4OwDQABZcDiTI4kwOJ0DiGxUAAIT8XAzDDTgzGFABNNINHIswiIARzMABOMgACtb1UMx+GEOI8KgENBDMTg4mEQQAFYkLSMwYDMTU4lQXQkFvJgzDSXRKIAJik+g8KYQQyFUVQ4n4XQ-FUKA0nIvDNRIahcEszAzCgMxHIwahHAAZiQSwVjokM0gAWnoOJbwARjiMwAAkjFUENqDMPD8wgAAONJSN0OiLHQTIAGoIssjwzCA4QzDiMAAC0xn8xwACkkKAyAkAsFjVEwdC8IYwQ4rGIyww0XBMFUDQADEkEcSgIrifMIrE3BVDAJAIHoMxqDIMxRF0XoEjsThVFA0QvM4vKzEoKBhCQ9BKDK3RNUwPDfDiXoYGq8iIrK8ikDw7KJHzJhspgJBqrosrysoMgjFEpgruERxVBCsgkHIjQIDwoazBC-ySH0fgWL8fMyAAdi8zIZNoUzHDoujb3QOiADZsqgPDb2ykKyvcob+FUUQyH4MxEZYry8NQNiLBsMALAADXUpDKHc7K4mqvDyKA9T81QTAIoO3d92HKUZQ7INTx7Nt0zjIcjQimokACWJX0zd8Wk-b8l1-ct10tQDax3fs93dA9e31rsz0jY3+1Nm9HCMNZkSgW2Zwd+dhxpmniwAXQFeVFXcFUwDVSItSj-U0+IXYSHqJwhrobVKF1RADT-O2AOrBMFrADAPBN69axatYRQsDwkDpL9+xPbs-ZDqcG9nDQ7CgJJaATfyQvcxdl1XSf3ab2sLAgJgTRn7BNTAsYO-jLvQSuGA+4HiIA8Nsej3ruP0Gn2eX1rJeV5d-8Nw94cQKPyC0FYLwW0IhFCaEMJYRwvhQixFBJkTiJRaitEzAMWYmxDiXEeJ8QEkJES4lJLSVkvJRSylVIaS0jpPSBkjImTMhZKyNk7J4Qck5FyqQPJeQsD5PygVgphUitFWK8VEopTShlLKuV8qFWKqVCqVVar1QgI1ZqrUeIdS6j1MwfUBrDVGuNSa01RKzXmotZaq11qbQ8NtXadh9rOX4EdE6Z0LpXRundK4j1nqvXep9b6v1-qA2BmVUG4NIa6GhrDeGiNkao3RpjbGuMCZExJmTCmVNab00ZszVm7NObc15hofm8Uha3hFmLSW0tZby0VsrVW6tNah07sOW8E4zANA1GAW+o8dbSkvK7e2z8Z5zydkWIuIAS5l0cBXWgmoo6OELkuIAA"
];
    
    @override
    List<String> levels = ["HAMMER HONCHO", "BICEP BEEFCAKE", "ACCOMPLISHED ARTIST"];
     @override
    List<String> handles = ["silver","silver","skillful","standard","symbolic", "snarky", "scheming", "shifty", "stylish", "serendipitous", "shallow", "saucy","stimulating"];

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
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, -0.1, false),
        new AssociatedStat(Stats.ALCHEMY, 1.0, false)

    ]);

    Smith() : super("Smith", 20, false);


    @override
    bool highHinit() {
        return false;
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
    double getAttackerModifier() {
        return 0.5;
    }

    @override
    double getDefenderModifier() {
        return 1.5;
    }

    @override
    double getMurderousModifier() {
        return 1.0;
    }

    @override
    bool hasInteractionEffect() {
        return false;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")


        */

        //smiths are about extending plots and literally forging things.
        addTheme(new Theme(<String>["Villages","Forges", "Smiths", "Anvils","Hammers","Horseshoes","Nails","Jewelers"])
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)

            ..addFeature(new PostDenizenFrogChain("Forge the Frogs", [
                new Quest("The defeat of the ${Quest.DENIZEN} has somehow caused the Forge to go quiescent again? What the hell? The ${Quest.PLAYER1} has to start stoking it all over again. "),
                new Quest("The ${Quest.PLAYER1} breeds one frog only for it to somehow cause half their work to be undone. They have the feeling they will be here for awhile."),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  Wait. No. False alarm. Looks like there's one more step.    "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  They wait several moments to see if SBURB is going to throw yet another bullshit set back their way to draw the plot out, but nope. It looks like they are actually, finally, done.     "),

            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Supply the Consorts", [
                new Quest("Now that the ${Quest.DENIZEN} has been taken care of, the ${Quest.PLAYER1} finds a long line of ${Quest.CONSORT}s who lack the things they need to live their lives. The ${Quest.PLAYER1} gets to work alchemizing them."),
                new Quest("The ${Quest.PLAYER1} sits in a small room, creating tablewear, blankets, clothes, bookshelves, anything the demanding ${Quest.CONSORT} might need.  The work is strangely soothing."),
                new Quest(" The ${Quest.CONSORT} finally have the basic necessities taken care of.  The local ${Quest.CONSORT}s dedicate a new Blacksmith Forger in the  ${Quest.PLAYER1}'s honor and vow to make their own goods from now on.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
