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
    List<String> associatedScenes = <String>[
        "Grace I:___ N4IgdghgtgpiBcIDiAnCBjGACAkiANCAGYA2EAbgPYoAqMAHgC4IgA8ARgHwDKOAIgFEAigFUB3GvFYB6LlhoALbNwDCAgHICA+gHkA6poBKW9QEEAsgKwAHAK4BnJfawQwAEyxhbbgOYxn9pSwnpRgALTWZACeMChY6AoQaOiMsc4AlmCMlFgMMOi2jJk+Llj2sen+WJRELinpoc6MiYz4WADuSmDxQeyZMG5t6BAO2BCetlDssdW1tmCZqVkNkCRY7LY+zq4ePiTpjAn+AHRYAGLUHS0w5DMoMBCBYG1ulMVYzenOw6PbWEQwdqzD5KELhSIQGJxBJJDCpFBNHL3dpJDzNZRqTS6AwCYxmSxtR5YdK1dFRADktx6UEiMFSHnG9nSbhgAEdbP5GKduO0YHSAIRYABChRB2GRqO29ywCmoKHS7BIUSwewORzcpz0LTFMpgJDWXx1qg02n0RhMFis9ls1mslHKaJyrw6BwUpWsCiiTOGawACiRbOgANbyShBmBgAD8AB0wBwUJx45wCCBGEk-IwdGA4IhGCgOSm8+kfH4UCpQm4Dit7AAZdLkYosADawGjIHSNOoaayemobjb8Db6mkpjb+CHOhoA7bRAgJHKY7bADVDDhuABpUcIGdzhcENuQWDTkA4ezcPVERftzsobuMHBZY8ABjbAF82q3r3bb65GL2UP224gMOW7jsBk7HrO84wFeK5rpukG7jB+7gNAyGDie9imPstxXh2353g+jDPm+H5tvhXa-v+gEYSBV7qBBQF5hysGrhuW4YVBe5gYe6FtqeSCUG4NCVCgeE3oRj5AS+IDvlgn4UT+PZ9se-qBiGNBhhG8BaLpWDqAALDgPi+AoPiMD41jpEK6A4KYm7sKYKA+AAmu06guaYdmsqYACcJAAFZICoph8EIPhClA64CKY7A+EIAgAKwGe0pgwKYNY+OkOjcEg9CmO0OhuQATGlNBCvQAgkCoKg+HwOjoCoUDtC5Qo1kQlA4K1CimFApi9Qc9oAMzcBYlCMKy67tGENA+EgACMPimAAEoYKjrpQphCk+EAABztI5OisuYjBuAA1MtrVRKYvpCKYPhgAAWkGYT2AAUgZvqQNw5gBSoCi+EKPkCJtQZ1Zu6g4AoKjqGc3D2OQy0+E+y1JTgKhgNwEA0KYlAkKYIg6AAXj4US2OwKgBiIo2hZdpjkFAQgGYw5CPToNYKCKYA+ETMBvS5y2PS53BCmd4hPvQZ0wNwb2so9T3kCQhiJfQbNCPYKjzSQ3AueoEBCmcpjzWERB6HwAXoE+JAAOyjW4GUoI19isqySATQAbGdUBCkgZ3zY9Q1nHwKgiCQfCmLrAWjUK6RBeY1hgOYAAaxUGeQQ1nT4b1Ci5vrFU+6QKMtNP0YxGHMchYFwexiHQVevHHstjzcJg2biQRv5ESRslkV+lHKQBx50ShDFTkBXGV8ubEIePSH12hx6noYOxBO3-f3lJGFDUNpHyeRElUSpQFqcGobhmApdj+X+aTyA1cz5xc8oQ3QFN-YOCpFAeuwIBYGKZJxFpJvgALqFnlCWWI5Z3BVkaDWHYzZQGEBgEQAEKR7AXBQHWBs3NmwKQPgPGibYzj3GwHodI+p55HiAv9VwfhzBRG4GmQBVdp4cR3HXFC-9fzqEmNMMSQEwjzR3j3PefclJ-iPhhLGCxGBREoXxEANDuYwHoYwiAzCp7wTYcQJ+f98GMB4VMWIx4hG7zwR3AhqkAyn00ufHSelDLGVMuZSy1lbL2Vik5Vy7lPLeT8oFYKoVwqmFsKYRQpg3oQBEPVFQdk+CFxwIlJOhgoBLiFCtcwMABBnCQCId29gXJIG4D4AQu07pJ2uvI48SB6wwA-jAKArEtHHgrmvcRhi+Hd1fIgkAyDUGMHQdQOB7h7AINkkAA",
        "Grace II:___ N4IgdghgtgpiBcIDiAnCBjGACAkjkANCAGYA2EAbgPYoAqMAHgC4IgA8ARgHwDKOAIgFEAigFVBPWvDYB6blloALbDwDCggHKCA+gHkA6loBK2jQEEAsoKwBnAK4cmpAJ5YAllA52YNrAHNoGA4UGAgAazcwPywmGDAAEzj0Nx93MCYqLDAqMABaAAdyZxgULHRFCDR0WJQbAixg0IiomOU3UuyUKAhSLBQqOyZI1IgE-1I3JnLI6IGmVuwAdxpSeKxKgbGmZSgAOiwzXxtFAdWG7EZ8mGqYePqbKlgsKmIFm2xsvMKIYtLyyowNV8FQo2BsbkSAEdvDYmL5iDQFlg1JodAZjKZLIJ6l55hxXH4JlNFDMFlBnoN6tsqO9bBCYNCfHCsHE1nZ8lhuihmtFtjAoO9SKDfBBfOhHoUYLF9koVOotHpDIITOYrO4bGAAOTzDKZewofIoNzvNaLZRgBbtPowRaVNbG9bjSblW4U+b5RTOcHoHpYAAKpDs6DCCioYTiMoqTE1vgAVnZYVgzRB5pNOaEwL4MudHagMDBdgAdMCcFBcUtcQggJiVPxS3RgOCIJgobxVltuPx1lCqHLxSZuHI2AAybgoM1YAG1gIWQB58jQa+l9DR4rP4LONDIzLOCJvdLR17PiD13rvZwA1Iw4HgAaR3CGPp5g5-AgSPIBwNh4MFIxFf86LqMTA4OkH4AAyzgAvvUM5zlAC4oEuTAriga6PiAW4PnumEHh+J6kGehCXted4PhuJDPq+kCwB+X5mBMoIAQhQHpKBTAQdBsGzoBSHAah6EUVhr4aHhGEEUROFXje974VRxFvrRGFfkgVDxLQKQoMxiHIexnEgDBWBwbxyECR+AZBiGtBhnE8DaPZWAaAALDgfjxH4ih+Ewfj5G4ABC6A4GY94cGYKB+AAmosGgRWYQWQmYACcpCxkgqhmPwwh+H5UC3oIZgcH4wiCAArE5ixmDAZjDn4bi6DwSAMGYiy6FFABMlW0H5DCCKQqiqH4-C6OgqhQIsEV+cOCI4BNihmFAZjzZMNIAMw8JYVBMJCt6LLktB+EgACMfhmAAEkYqi3lQZh+eBEAAByLKFuiQhYTDxAA1KdE3OGYfrCGYfhgAAWmEuQ2AAUk5fqQDwFixqoijuX5CWCNdYSDfeGg4IoqgaAAYjwNgUKdfjgadpU4KoYA8BAtBmFQpBmKIugAF5+M4DiqIGojrRl31mBQUDCE5TAUMDujDoofl2FErMwBDEWncDEU8H5H0SOBDAfTAPAQ5CwMgxQpBGCVDAS8INiqIdpA8BFGgQH5+NmIduTEPo-Cxug4GkAA7Ot8TVSgI02JCkJIFtABsH1QH5SAfYdwMrfj-CqKIpD8GY9uxutfluKlFj5GAFgABptU5FArR9fgQ35EV+m14FuIop18yJYkUS23ivtJZFyYRL4KTRg8Uadoo8JgjbaaxIFgRhkEGdx8E6fxq4fsJCmiYe4nyVJpGyTvA-Ue+yk2EYozxI8098Wxc8UZHkdcUZPEsTfKFrxhFnBqG4ZgO32+d1bIPPeMlyJPiPkPE+o9RQ4FiFAB2sB0I4RMsBPS89oIAF12xGi7CUXsCQBxDmHBfKcWCiAwGIMQa4cJ8Y0FHOOKIU5jKv1Mh-Ci+MQjYH0G4UgpBj5KQoojUYdYLDOB4DWDiCle4HwohJYBL8V7pA0HYTwJQPy5EOitBehlmGKPfmhD8tMwCTGcPwkes4hFRBgKI8RKYe77zAZRCByCWHAWUaorSGFNHaKXig5cbDZxfysjZMAdkHLOVcu5Ty3lfIBSCiFMKkVoqxXiklFKaUMpZTMHYMwSgzAQwgKIIaqggr8GbjgEqJcjBQAvH5M6FgYCCHxkgUQkcbARSQDwPwgh7oAxLr9MxH4kBjhgLA-k9jQEfi7vI5eM93EcDUeggyZCQAUKodUGwtCUDEISDYUhBkgA"
    ];
    
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
