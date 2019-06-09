import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Scribe extends SBURBClass {

    @override
    String sauceTitle = "Archwright";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "Scribe I:___ N4IgdghgtgpiBcIDKBjATgSwEYwAQEkQAaEAMwBsIA3AezQBUYAPAFwRAB4sA+JfAEQCiARQCqgpPXgcA9D1z0AFniQBhQQDlBAfQDyAdS0AlbRoCCAWUG4AJjHJUYAZ1swYAB1wYwLGrgi4ihg2dmD+aDAQRLjkNE4suL6JGLDRAK5gkWgsQWAA5v6JEFjkMAk0pP5gKBgwPrgA1mA0AO6lNnkwAHS4ou40YXYoNDbeBRgsLsM+dZPROTAAnrYYTsOOaF4JSTi4zTljuFB0eDkQYQu4ETXup35ONLBVNbO406QwKCwYAzBoiz0zGAbFsivFnP4WqQ0uRAdtlLgNstShB4vMEWpNDoDMZTJZrIpUTEspkQQFyBMWKUjid-FgaGkEi1CQkJkdImAXDs8AFUJgcF0ADpgLhobii7jEEAsCBoTosXSZdgsNBpOAkFUYPKdNCqAajb4DJwAGQwVDG7AA2sBBSAUv1sucWPo6DZbfBbRoZGZbURPbp6O7baQIOQnDBfbaAGpGfBIADSPoQwdD4cj4GgEeTIHwTiQ9lI6ftdBlPnwPiDIAADLaAL7RG12qAO0vO12Vr1Jv0gDQByshsNZ7sxuOJ-upoe2yCwSu5swUxxF5slp3lliVmsgeu4RvFx0+F1oN3Zzvp3uB7MqtXpkcJpMesgT9PTrMP3MAcRG9FqaCXLdXFbZpu267su+5tkelYAArkGkKANAoNANHU8DaGhuAaAALPgeQdIoeQsHk7gYAAQig+BmImWBmHKACaLQaLRZgUQAjmYACc5AAFbvqoZj8MIeQkVA8aCGYWB5MIggAKyYS0ZgwGYxp5BguhIO+TBmC0uj0QATAp9AkUwgjkKoqh5PwugoKoUAtLRJHGqQND4PZihmFAZjuRMcQAMxIJYNAsCx8YtAAtPQeTvgAjHkZgABJGKo8Y0GYJFVhAAAcLTUboLEWCwNgANRxfZixmFBwhmHkYAAFoNKFTgAFKYVBkBIBYXGqIoHQkWxggpQ0FmJho+CKKoGgAGJIE4VBxXkVZxTJ+CqGASAQPQZg0OQZiiLoABeeSLGkWCqLBoj+fxJVmFQUDCJhLBUDVujGooJEZHke0wI1tFxTVtFICRhUSFWTCFTASCNSxNW1VQ5BGNJTBPcITiqFF5BILRGgQCRE1mFFoWkPo-BcSgVbkAA7P5NhKWg1lOCxLHvkFABshVQCR76FVFNU+RN-CqKI5D8GYmNcf5JEYDxFjuGAFgABq6ZhVA+YVeSNSRtFQbpVYYIocUXWefaXqqk4gLeY7ZgOabEFOmaVnFqKoHUpt7q2a4bnWDa2q7TqHseD6njbPZGw+Vum+b94poOz529muZGOcNiPH+K5loBD4+T5dYALpSpq2p-HqwITD8nLGonVq5yQMCkB8XxOBNdCmua+RWqB-4Hu22YWN4KRpFAuDGnBDQxzO2ZdecnQWIsSAyuuQcR+O0dBz7PgaP3OC-tmoVRVnW5e02HcQf7tprWAEyLKPr62hP+QwNPs8QPPw6xneS-W92q8sOvUCb5Wu+ex3N7MCrY-bQVgvBRCyEwCoXQlhHCeECJEVIuRSi4kaJ5HooxZiZg2KcR4nxASQkRJiQklJWS8lFLKVUupTS2k9IGSMiZMyFkrI2Tsg5JyLkSJuQ8l5XwTg-IBSCiFcKkUYrxUSslVK6Uso5TygVYqpVyqVWqnVBqzVWoQHap1bqQk+oDSGmYEaY1JrTVmvNRa0llqrXWptbau0DpHROmdC6-Aro3Tug9J6L03r5E+t9X6-1AbA1BuDSG0Maqw3hojXQyNUbo0xtjXG+NCbE1JhTKmNM6YMyZixVm7NObc15vzQWwtRbi0lu+aWssFZKxVmrDWWsdZ6wNkHF8lZ3xmkUl8UuN5X4WwfFeF2ICnQ-z-kBHOUoa510mI3NA5dgROErluIAA",
        "Scribe II:___ N4IgdghgtgpiBcIDKBjATgSwEYwAQEl8QAaEAMwBsIA3AezQBUYAPAFwRAB4sA+JfACIBRAIoBVIUgbxOAel64GACzxIAwkIByQgPoB5AOraASjs0BBALJDcAazC0A7gGdcD1rlpgKAT1ysVXAwwVwgwABNPAFdWV1oyfxUMNFxzZwAHGBRWYlwsGNwICmdaXCUnf1KIdPTfII9HDADgxLx0pR9nDBQi3Ed6CnCAOkVA9S1dQxMzKxtWCFsYVy7wmABHKKXYxIgPYLoKajwAcwhg4OO7B0cKGHDjvDDIgJgwXCiusEum3MclbqUhTQeCgtGcrDq6SiAC9obdnCMDE1AS9cONtPojEJTBZrAByUJQCDQi64dJOGBoXIvZx4FbrTbg1zHUpYPwbbq2XwjZSqDQYqbYmbWIKuFC0KC1GCsGB1MhRChkDAUCik1FoWi3TwJVGoTA4IYAHTA3DQPFNPBIIHmaAerD0YDgiFYaE2VpdGGODzQai84SaGC8zgAMhhqBcOABtYCGkAYSX0eZgVgGejhWPwWOaWTmWPELN6BgZ2NkIq0vOxgBqxnwSAA0rmECWyzAK+BoK2myB8M4kLKyG34+S0EnWPhk8WQAAGWMAX1yMbjCZHYRTacn2cb+ZAmkLk9LxU72+rtYb+5bbcgsEnPfMqqOg+Xo-HrEnM5A89wi6HidXqbQ6Zdpuba7kWXYHuWJBVjW9aNpm5AXlB7bXl2PYAOK0OEDAYJSj7Ds+E5du+n7fk+f7rl2AAKFBRCgtiKLQixgPAOisbgmgACz4Mc9xKMcrDHOkGAAEIoPg5gNlg5i2gAmo4mgyeY4lrOYACcFAAFZoWo5gCCIxzCVAdZCOYWDHCIQgAKwcY45gwOYwbHBgehIGhzDmI4ehyQATHZDDCcwQgUGoajHAIegoGoUCODJwnBmQtD4LFSjmFA5ipU0YIAMxIFYtCsGsdaOAAtAwxxoQAjMc5gABLGGoda0OYwlThAAAcjhSXoayWKw4QANQ1bFPjmJRIjmMcYAAFq2MVzgAFIcZRkBIJYGlqEo9zCSpQhNbYYUNpo+BKGomgAGJIM41A1ccU41VZ+BqGASAQAw5iauYYh6NCxw+FEWBqDRYi5bpQ3mNQUAiBxrDUFNejBkowlRF80IwPNMk1VNMlIMJ-WSFOzD9TASDzWsU3TdQFDGJZzBwyIzhqBVFBIDJmgQMJZ3mBVxVkAYAgaSgU4UAA7Ll4QOWgkXOGsaxoQVABs-VQMJaH9RVU1ZWdAhqGIFACOYrMablwkYFpljpGAlgABreRx1BZf1xzzcJMmUd5U4YEoNUgyBe5di6mxtiesHnoel4dpONUQL2KCvEesY-iuyYvm+c4LgnZHJv+gHwcBSGgaHkHHjBZ7gYh25Xp28E9sYTwSnhv7J4R8Hy-Lc4ALrupgXqUr6EQBkGwZPFGnekDAZBkFksRnfQobhl8Uakfh5EAZOljnFAURQLgwa0bY4cofBG1hA8lg+Eg8yvkhwel-BEHx0uy-JpoW84Ggk7FRVWXEenj+N2uq8uwvTAE0HwB8q6xmPl8GAZ8L67CDiXOCzYw5IUTqOF+UA36Ti-j-L8Gcn4AJzrGaie8GJMRYmxTi3FeL8UEiJMSElTLSWOHJBSSlzAqXUlpHSekDJGRMmZCy1lbL2Ucs5Vy7lPI+T8gFIKIUwoRSijFOKCUkrCRSmlDKrBsq5UsPlQqJUyqVWqnVBqTUWrtU6uYbqvUBpDWEiNMaE1pqzQWktFaa0NpbR2ntA65gjonXOpda6t17qWUes9V670KCfW+r9f6gMojA3SgIMGEMoYwzhgjJGKM0YYyxjjPGSACZExJmTCmVMaZ0wZkzFmbMOZcx5nzAWQtRbmHFsGSWahpaywVkrFWasNZax1nrA2mgjbNVNmhc2lsbZ2wdk7F2bsPZex9khSuk40JhnstkQMYAEGniQdaV0D80GrgwVgoiHcrTj0ntkZwM80BDwiM4EeH4gA"
];
    
    Scribe() : super("Scribe", 15, false);
    @override
    List<String> levels = ["MIDNIGHT BURNER", "WRITER WATCHER", "DIARY DEAREST"];
    @override
    List<String> quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts", "playing typing themed mini games.", "saving an important piece of a riddle from a crumbling building"];
    @override
    List<String> postDenizenQuests = ["documenting the various Consorts lost to the Denizen.", "writing up a recovery plan for the Local Consorts", "figuring out the best way to explain how to recover from the ravages of Denizen"];
    @override
    List<String> handles = ["serious", "sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
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
        new AssociatedStat(Stats.SBURB_LORE, 0.5, false)
    ]);

    @override
    bool highHinit() {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Scroll",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SMART],shogunDesc: "Rolled Up Picture of JR",abDesc:"Scribe Shit"))
            ..add(new Item("Ink Pot",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.OBSCURING, ItemTraitFactory.SMART],shogunDesc: "Black Liquid That Tastes Awful",abDesc:"You could probably censor shit with this."))
            ..add(new Item("Blank Book",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BOOK, ItemTraitFactory.SMART, ItemTraitFactory.OBSCURING,ItemTraitFactory.LEGENDARY],shogunDesc: "Dick Drawing Practice Apparatus",abDesc:"Fill it in yourself I guess."));
    }


    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Quills","Feathers", "Pens", "Ink","Paper"])
            ..addFeature(FeatureFactory.BIRDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has caused all those fucking bird underlings to finally drop the frogs. The ${Quest.PLAYER1} thinks hard and figures out the best way to start collecting them. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Restore the Library", [
                new Quest("Now that the ${Quest.DENIZEN} has been taken care of, the ${Quest.PLAYER1} discovers a large library of ${Quest.CONSORT} documents and books in its lair. They were not taken care of to say the least, and are badly in need of repair."),
                new Quest("The ${Quest.PLAYER1} sits in a small room, repairing bindings, glueing pages, and copying and replacing pages outright where necessary.  The work is strangely soothing."),
                new Quest(" The final book has been restored.  The local ${Quest.CONSORT}s dedicate a library in the ${Quest.PLAYER1}'s honor and cherish their legacy now returned to them.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}
