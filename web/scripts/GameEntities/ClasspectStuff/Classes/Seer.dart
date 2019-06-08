import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Seer extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.51;
    @override
    double companionWeight = 0.51;

    @override
    List<String> associatedScenes = <String>[
        "Seer I:___ N4IgdghgtgpiBcIDKMYCcAEBJEAaEAZgDYQBuA9mgCowAeALgiADwBGAfElgCICiAigFVeSKvGYB6DhioALGBiQBhXgDleAfQDyAdXUAlDaoCCAWV4YAlgGcMAE3KWwAcwwQM1y3ZgBHAK4w1vQY9LIQwWi+fpaRtqEwAJ4YAA5o5KReCvEY-oHBzpak6BgA7pahHuSwGADWYOQlRDB2zjAAdDLyiirq2nq8hibmGM7kgRjkfsHkBCHyMaUQSfTkbgDG-jFZsja19Y3NrRgEaVAhVeMzbmBrljBgwUSUMLgTYETLq5FFEERz4VZ6AByOJdKDkIIhNCFSy-FJ3NYKK5OAiUKDhSzkMDXBJYhRrSZEOwYGBFTAQaw1Y6UDo6ML0UnoV4ApoU4LZZRqTS6AxGMwWAioIi2VgwegMzBRSzJZLNc4YVlobEQMDEhkQNayKzY7IEKZ+SJtAA6YDYaHYZvYeBA9AgaFa9C0YDgiHoaAC1rdlmcrTQSixdnKmLA1gAMjCXEwANrAI0gSxQZKUW0PHSUOxx+Bx1QSYxx3DZrRUTNxgi-awwfNxgBq+iwSAA0nmEKXy5W8HHILASyAsNYUEQCFX44nkyr6FgHj2AAxxgC+r1jI6TaBT9DTaAzLZAOebBZ3RZ7ZeF7f3tfrTaPbeHXfbWd71mMREKp7jCZXa8n9Bn88Xb9Hq7jhuW73ruw6qIe25ugEw7no2zb3seFY3tAd5xn2ADi5B2FQdxoMO75jg8X4-iAC4YEuhGAam6Y9gACkQfhrFSVDkDU9zwBoXEYKoAAsWDOC0sjOPQzjJJYABCaxYMYTasMY9oAJolKoinGDJPjGAAnEQABWGFKMY3D8M4ElQA2vDGKwzj8LwACsvElMYMDGKGBRaEgGG0MYJRaMpABMzlUBJtC8EQShKM43BaGsShQCUikSaGqJYIlsjGFAxgZeUEIAMxIGY5D0D4DYlAAtFQzgYQAjM4xgABL6EoDbkMYEnThAAAcJTyVoPimPQdgANT1YlCTGHR-DGM4YAAFo1GV1gAFK8XRkBIKYulKLILQSZpvCtTUUVNqoWCyEoqgAGJINYpD1c4071fZWBKGASAQFQxjkEQxiCFoABezgJH4rBKIxggFUZo3GKQUD8Lx9CkLNWihrIEl+C4-0wEtin1bNilIBJQ0iNOtBDTASBLT4s1zaQRD6HZtDI-w1hKNVRBIIpqgQBJl3GNVZUEDo3C6Ws05EAA7AVdiuWgsXWD4PgYcVABsQ1QBJGFDdVs25Zd3BKIIRDcMYXO6QVEmWPppjJGApgABr+bxpC5UNzhLRJil0f506WLI9WQ+BkH3tBr4gHBl7bkhYe3j29UUkgiLOgRAGflO26zmRf7LkR660duYEdgexZR9eRcRwhrYnih3bbn2+gqg4UApx+44kduuW5fOAC6nrQj66D+qqQZYmGjfRr3+AwAQgprPQ1iXZQ4YZJGiAxv+rc0ZuPamOQrCWM+9AJDXaEgNtKqtKYCRILa37l3W8FXtXRdUWuqh+FAor4duZXVV3WcUQ3rnYCPZ3pgHKMfIusdtznxcDAK+N9wiwQfpHRCZd9yv3HO-T+6Aex-1-IAnO1E87b23AxJiLE2IcS4hoHi-FBLOGEqJcSUkZJyQUs4ZSql1LGE0jpfShljKmXMpZaytkHJORcm5SwHkvI+T8iUQKMBgqhXCpFaKsV4qJWSuQVKEl0qZWyisaw+VCrFVKhVKqtUGpNRam1Dq3Ver9UGiNMaE0pozXmotFaa0IAbS2jtUy+1DrHWMKdc6V0bp3Qek9OyL03ofS+j9P6gNgag3BpDbg0NYbw0RsjVG6NMbY1xvjQmxMkCk3JpTamtN6aM2ZqzdmnNua835oLYWotxZS2MDLUMcslAKyVqrdWmtta631obY2ptVDmzalbDCNs7aO2dq7d2ntva+39oHKBqEewYRfMYOewZkEXkrjad0YdMEPGwV-Uic5J4gGnrPeei80ChkbtYCeZEgA",
        "Seer II:___ N4IgdghgtgpiBcIDKMYCcAEBJLIA0IAZgDYQBuA9mgCowAeALgiADwBGAfElgCICiARQCqfJNXgsA9JwzUAFjAxIAwnwByfAPoB5AOoaASprUBBALJ8MAcwowAzhghoKAVzAATDAxgQAxnIBLMCtHMABPCjBFAHc5CgxfJ3sMGDJ0MIZA4K8FMIwomE8GeIBrMApoxzZXBhyYAMwIOwAHGF8GADoME0JvRuJiPAwyiuJCq0ViAJLFTIha93t0NIdijDZFOzkk9y6sMAx3CiCQzIC7IczFFXUtPUNjc0sIAYqHQio6hscWttq1jbDcrRA5sPIvQZeNAuYh5ZqkMInOoYZpOWoUQjIlDoDoAHTA7DQHEJHHwIAYTgmDG0UWYDGhcAI9ICVgmaGUkXcAQYAUidgAMgEyCdmABtYC4kABKDNKgUsAMXRUdyS+CStSSEySvDq7TUVWSwgvOwwbWSgBqBiwSAA0lqEIbjab8JLILADSAsHYUMRCGapTK5RAFfsGB6AAySgC+QwlAdlaHliuVHo19p1IDUeo9RuIJv9lutdpzTv9budas9dhMUzS-ulCaToYj0djkobQYVSrQKodmc1-qz+r7ufzLpAhdt9sro+dGfLHq9AHEKO5qAF0PXA4ngwxm33IyAYxg4x2d12U32AArEFy+EqyCgzMDwTRvjBqAAsWCs7iscisBgrGaAIACFfCwEw7TYEw0CsABNaI1HgkxIIARxMABOYgACsl2UEweAEKxQKgG0+BMNgrAEPgAFZP2iEwYBMfkrACbQkCXOgTGibREIAJiY6hQLoPhiGUZQrB4bRfGUKBong0D+Q+LBFLkEwoBMDTuQoOwAGYkHMCgGDQm1ogAWmoKwlwARisEwAAkDGUG0KBMUDwwgAAOaIYO0NCzAYdwAGoHMUsITCvAQTCsMAAC0SnMuwAClPyvSAkDMHDlDkP9QIwvg3JKKS7TULA5GUNQADEkDsMgHKscMHLorBlDAJAIGoEwKGIEwhG0AAvKwwhcNhlFvIRDMIsKTDIKABE-BgyDi7R+TkUC3CsAaYGS+CHLi+CkFA4LRHDOhgpgJBkrQuL4rIYgDFougVoEOxlBs4gkHgtQIFAqqTBs8zCF0HgcN8cNiAAdkM9wWLQWS7DQtClxMgA2YKoFApdgpsuK9KqnhlCEYgeBMb6cMM0CAjwsxmjAMwAA1+M-Mg9OCqxktA+Cr348MAjkBypsHbM+3pFw5wtK0pxLPMJfAaAK0lBymiQXwYCiLdG13fdK0PY9T23JNu17Ss02F4cZ1LcdJ2LEcrfnBXFzsAxgyOKBNc7PcFQ9VHUejABdMlmVZdAOQ8bleTAAVXbFQOCBgQhCD+OwqqoQVhWCMUDa1i8ew9MwKDYAIpgYMIy0dvscuDCYzDCJAKTDa2pdty3ZY988GDUFwoA2NAPXMmy9L1tt40942PQ6sBuTL8cF0r7ZghgWv6-mAtm+nR02-HM8ky7nvNz7Qfh5PdtDd3cfr1ve9H2fV93y-H8-wAoCQPAyDoNghCkJQ9CsNw-DCLEVIuRSi1E6IMSYixNiHEuI8T4tEQSMBhKiXEpJaSsl5KKWUhQVSoF1KaW0sUfShkC4mTMpZaydlHLOVcu5TyPk-IBSCqFcKkVoqxQSklVK6UICZWyrlEiBUiolRMGVCq1Var1Uas1WirV2qdW6r1fqQ0RpjQmlNHgM05oLSWitNaG1gjbV2vtQ6x1TrnUutdW6cV7qPWetoV671PrfV+v9QGwNQbgyhjDOGCMkYozQujTG2Ncb40JsTUm5NKbUyXLTemTMWZsw5lzHmfMBZC1nhXSsS4hTMXaJHNeRYN7kgZO3Xe3de4tiPHHEACck7tBTmnV2dhY5HiAA"
];
    
    @override
    List<String> levels = ["SEEING iDOG", "PIPSQUEAK PROGNOSTICATOR", "SCAMPERVIEWER 5000"];
    @override
    List<String> quests = ["making the various bullshit rules of SBURB part of their personal mythos", "collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go", "suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't"];
    @override
    List<String> postDenizenQuests = ["casting their sight around the land to find the causes of their lands devastation", "taking a consort under their wing and teaching it the craft of magic", "predicting hundreds of thousands of variant future possibilities, only to realize that the future is too chaotic to exactly systemize", "alchemizing more and more complex seer aids, such as crystal balls or space-specs"];
    @override
    List<String> handles = ["sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

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
    bool isHelpful = false;

    Seer() : super("Seer", 6, true);


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.4, false)
    ]);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Cueball",<ItemTrait>[ItemTraitFactory.CUEBALL, ItemTraitFactory.CLASSRELATED],shogunDesc: "A Worthless White Ball",abDesc:"Don't listen to this asshole."))
            ..add(new Item("Crystal Ball",<ItemTrait>[ItemTraitFactory.BALL,ItemTraitFactory.CRYSTALBALL, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.GLOWING],shogunDesc: "A Worthless Clear Ball",abDesc:"Seer shit."))
            ..add(new Item("Binoculars",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.METAL],shogunDesc: "Long Distance Perversion Apparatus",abDesc:"Seer shit."))
             ..add(new Item("Blindfold",<ItemTrait>[ItemTraitFactory.BLINDFOLDED, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.COMFORTABLE],shogunDesc: "Long Distance Perversion Apparatus",abDesc:"May as well skip the whole 'going blind' part of the deal."));
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 2;
        } else {
            powerBoost = powerBoost * 2.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 0.67;
    }

    @override
    double getDefenderModifier() {
        return 0.67;
    }

    @override
    double getMurderousModifier() {
        return 1.0;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //seers are blind, get it?
        addTheme(new Theme(<String>["Mines","Holes", "Tunnels", "Burrows","Nests"])
            ..addFeature(FeatureFactory.MOLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLAUSTROPHOBICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            //in the land of the blind....
            ..addFeature(new PostDenizenQuestChain("Be the King", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the land is really starting to open up. The ${Quest.PLAYER1} finds a tunnel filled with Blind ${Quest.CONSORT}s who could use some guidance on where to place new tunnels. The ${Quest.PLAYER1} agrees to see what they can do. "),
                new Quest("The ${Quest.PLAYER1} guides the Blind ${Quest.CONSORT}s to the best place to lay a new tunnel. You kind of wonder how they got along up until now."),
                new Quest("The Blind ${Quest.CONSORT} have finally finished the tunnel.  Not only did it not collapse, killing all the diggers, but there was grist and boondollars found during excavation.   The happy ${Quest.CONSORT}s give the ${Quest.PLAYER1} some as a reward. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has unblocked the tunnels containing the vast majority of the frogs. The ${Quest.PLAYER1} thinks hard and figures out the best way to organize the ${Quest.CONSORT}s to start collecting frogs. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Work With Exiles", [
                new Quest("The ${Quest.PLAYER1} hears a strange voice in their head. Huh, it seems like a carapace years in the future (but not many) needs their help making sure things happen how they already happened which. Fuck. More Time shit. The ${Quest.PLAYER1} organizes a group of ${Quest.CONSORT}s to carry everything out."),
                new Quest("The ${Quest.PLAYER1} instructs a group of ${Quest.CONSORT}s to exile a random ass carapace. They have no clue why, but the voice insisted. Alright, then."),
                new Quest("At the ${Quest.PLAYER1}s request, a solitary ${Quest.CONSORT} chucks a few random ass objects into a Lotus Time Capsule. Okay. They are FINALLY done running around and doing inscrutable errands for a voice in their head. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Have the Keikaku", [
                new Quest("A group of underlings are still making trouble, even after the defeat of the ${Quest.DENIZEN}. The ${Quest.PLAYER1} begins planting rumors of a huge ${Quest.PHYSICALMCGUFFIN} Treasure in the center of a still active dungeon. "),
                new Quest("As planned, the group of underlings moves into the still active dungeon, hopeing to find the ${Quest.PHYSICALMCGUFFIN} Treasure.  In a dramatic twist no one could possibly see coming, it turns out the ${Quest.PLAYER1} was the treasure all along. The underlings are soundly defeated and the land is safe."),
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
