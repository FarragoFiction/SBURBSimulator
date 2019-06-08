import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Sage extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.51;
    @override
    double companionWeight = 0.11;

    @override
    List<String> associatedScenes = <String>[
        "Sage I:___ N4IgdghgtgpiBcIDKEDmMAEBJEAaEAZgDYQBuA9gE4AqMAHgC4IgA8ARgHxJYAiAogEUAqnyTV4LAPScM1ABaYkAYT4A5PgH0A8gHV1AJQ2qAggFk+GVAEtSMAM4YIGIjADGDAK6VMENuQ8MGAwKGJCe3hjkBEEKVpSOdgAOboEM5Bh25LCRYETk5ADWMJR2AHSyCgCelulWYGmOzuSBURiu5GAEHnZ1qBgAJjAMEFZEMRCBYOR+-dV2MDBQDg0eYIMlw2u4GGwBGDC2lJUdmPOLy+lsmF1ERNUwYKhoMP0YdTGKKuraenyGJuYAOQOJILVxyco6BRgD4ZZJuORvBzkQ7bYKfNSaXQGIxmCz9cj2MCAwLoQJQDzgyLRJzeADuEEo-W2u1SECIBV6jj8e3RcQSyXcGCgECKyxCykxPxxAIsBAWYygVEw7U6VkG9TeML58VW6zsm36XNaVgYpQAOmB2JQONaOHgQMNKGStGA4IgGJQPHB8J6rKh0JQlB0jQwrB07AAZGy9ZgAbWA5pAVigiSomwYOio-ST8CTqkkxiTuHzWmouaTBHZ82LSYAavosEgANJFhCV6swWvgaBd9sgLB2JAwIgEbsptOUDNYeoVkAABiTAF9tonk6n0xB6lmmXOC22SyBVGW51WiDW8PXGy223nCJ3u5BYHPB8YiDY+4eJ5v6jOGHPFxAFcMDXb8py3TNsz3Qtu2Pct+09b1uwbJtW1PB9Lx7Z9+0HABxch+moKxinHDdwN-Wd+0A4DQLIjMdxzfsAAUiEpApZEKB54A0HiMFUAAWLBUH6VA5FQBhUESKwACFXCwYxWzYYxnQATTpVQVOMeSAEdjAATiIAArXClGMHgBFQaSoGbPhjDYVABD4ABWfi6WMGBjEjawtCQXC6GMOktDUgAmdzqGkug+CIJQlFQHgtFcJQoDpFTpMjAhyCwVK5GMKBjFy01yDsABmJAzGabTmzpABaahUFwgBGVBjAACX0JRm3IYxpPnCAAA46SUrRtNMBh+gAaha1LKmMJiBGMVAwAALQKaq7AAKX4pjICQUxDKUOQROk3S+C6go4tbVQsDkJRVAAMSQOxSBa1B5xa5ysCUMAUGoYxyCIYwhC0AAvVBKg8NglFYoQyrMqbjFIKABH4hhSCWrRIzkaTVlQYGYHWlSWqWlSkGk8bRHnOhxpgJB1u0pbltIIh9Ccuh0YEOwlAaogkBU1QIGku7jAa6qCB0HhDNceciAAdjK-pPMoRK7G07TcIYbSADZxqgaTcPGhqluKu6eCUIQiB4Yw+cMsrpKsYzTESMBTAADWC-jSGK8bUHW6SVKY4L5ysOQWth2CTwQr1PyvVDbw7c9o6wvs7xaiAh1cB5E7A6dKLvajVyTbOIIY6CD1LeC7zPC9DxQm90ITx9exfOx9C3AkoFIycc--ftiuK5cAF0HT9ANimDNZTXDMAozb+Mh-wGACHldw7Duqho1IWNEATQu6OLqD+1MOoUw8KAMEjNjG+wu8Dq3dBTEqJBhh7mvrzQ-sq6zvf6lUU+rkoOc1UGr9yAgXdcXd967n7CgMAppKhX2TkmW+jwYAPyfhMZCb8473gbphIuP8-4kX7MA5cYD8GQSgXeFibEOJFDANxXiAkhIiTEhJKSsl5KKWUqgNSGktLGF0gZYyplzKWWsrZeyjkXJuQ8l5KwPk-IBSCnSUKMBwqRWirFeKiVkqpXSplbKuV8pQEKiVMqpgKpVVqvVJqrV2qdW6r1AaQ0RpjUmtNWa81ForTWptbaEBdr7UOpZE6Z0LrGCujde6j1nqvXek5T630IC-X+oDEGYMIZQw8DDfKPB4aI2RqjdGmNsaPDxgTImJMyYUypjTOmDMlpMxZmzLQHMuY8z5gLIWIsxYSylrLeWitlaq3VlrHWesDZGxNmbC2VtVA226vbXCjtnZuw9l7H2fsA5BxDmHTCT5EEgFwh+Yw7gp6YNjnORCX8IEEKgP-ACg8HSL2XgwVe68252DnkBIAA",
        "Sage II:___ N4IgdghgtgpiBcIDKEDmMAEBJLIA0IAZgDYQBuA9gE4AqMAHgC4IgA8ARgHxJYAiAogEUAqvyQ14rAPRcMNABaYkAYX4A5fgH0A8gHUNAJU1qAggFl+GKAFcAzowzEYEKmAyFqGRoozsYYGEIASwcKQgwKbxgqWwA6OUUATys7UPZGCCC3AGswCgB3JwATdAjwqKCqDAhbAAcYAGNGPAwsxmjaqhgHEJaIMCKvRTdbeRdMEIx8kPkIqJj4tUj5LNQrZzBbarBE71WMazAnWy3JoK38qhD2tyKCt2CYxniFJVUNHX1+I1MLDFyCls9lsyNFkvkYMRiBg8vkXmMehcEa0HLB+kCKL5MBAMCh0LEADpgDhUTgkzj4EAZKjoRjaAIsRhUaxwAhMoKodBUZQUAYhIK82wAGSCZFWLAA2sACSAglBatQMmBGLpqEUZfAZWopCYZXgtdoaBqZYQIMRbDA9TKAGoGLBIADSuoQJrNFqt4GglpdICwtiQkMIHrlCqoSsYWGVxpAAAYZQBfFrS2XyxX9FVq6Pa536kBqQ3R03m725232p2Ft0lmWQWDRv0mYii6sp0PhyOMaNxkCJjDJkNp5Wqqjqn3Zj35o0+ovu-A2u2O52aohVj2173Lv0AcQoRRoQWiwdTYfTHa7CaTMoHJ6HmZ9AAViNYGtk5BRsv54Jpvxg1AAWLBUBKeRUEYVBaiCAAhBosBMJ12BMGkAE18jUJCTFggBHEwAE5iAAKy3ZQTF4QRUEgqAHX4Ex2FQQR+AAVj-fITBgEwhVQIJtCQLd6BMfJtBQgAmViaEg+h+GIZRlFQXhtAaZQoHyJDIKFDwsBU+QTCgExtJCChbAAZiQcxIkwh18gAWhoVAtwARlQEwAAkDGUB0KBMSCYwgAAOfIEO0TCzEYIoAGonJUxITHvQQTFQMAAC1sks2wACk-3vSAkDMfDlHkEpIOw-gPOyWSnTULB5GUNQADEkFsMgnNQGMnMYrBlDAFAaBMChiBMYRtAAL1QRJrHYZQn2EEySIikwyCgQQ-0YMgEu0IV5Egw5UEGmBUqQpyEqQpBINCsQY3oUKYCQVLMISxKyGIAwGPoVbBFsZQ7OIJAkLUCBIJqkw7MswhdF4fCGhjYgAHYTKKdiqAU2xMMwrdGEwgA2UKoEgrdQrshLDJq3hlGEYheBMH78JMyCgkIsxajAMwAA0hL-MhDNC1BUsgpD7yEmMgnkJzponAsfSZFkPTLRdK2LNcvWjJyaiQBp-Bba92yjH1u17ftj3DYdR2Xcc5zzMXlxnFtpYradV1N9d61sAx+juKAjzbU8teXdH0YTABdSl2U5aIeT5RgBU2IUXclAOCECQhGkYWwauoEUxTAVBJT1j3bxHaMzCyOVrCgDAhWfbJ5brH08v6dAzESJAMk7U3raXV05dNjX0zUYu-CoaNLLswydcvVtBwzPOfRQMAQkSSuNxlGuM5gevG4gZvSwXG2Lbt3Mu+VHuoD76Mh5Hvsr319NDejR9y7fD8wC-H9-0A4DQPAqCYLgmjENQFC0IwiYbCeFCLEVIuRSi1FaL0SYixNiHEuI8T4gJYSolxKSWkrJeSillKqXUppbSukoD6SMiZMwZkLLWVsg5Zyrl3KeW8n5AKQUQrhUitFWK8UkopXSplCA2Vcr5XIkVEqZUTAVSqrVeqjVmqtQYu1TqEBuq9X6kNEaY0JrWCmrpXgs15qLWWqtdam0M47T2gdI6J0zoXSujdO6CUHpPRetoN6H0vo-T+gDIGIMwYQ2hrDeGiNkaowxljHGeMCZExJmTCmagqaeVpluemjMWZsw5lzHmfMBZCxFvbBWPotzNhME0COUst5typMydWl8D690PNrf2lJ46J2TqnF2tgY49iAA"
];
    
    Sage() : super("Sage", 14, false);
    @override
    List<String> levels = ["HERBAL ESSENCE", "CHICKEN SEASONER", "TOMEMASTER"];
    @override
    List<String> quests = ["making the lore of SBURB part of their personal mythos", "learning to nod wisely and remain silent when Consorts start yammering on about the Ultimate Riddle", "participating in riddle contests to prove their intelligence to local Consorts"];
    @override
    List<String> postDenizenQuests = ["learning everything there is learn about the Denizen, now that it is safely defeated", "learning what Consort civilization was like before the Denizen, to better help them return to 'normal'", "demonstrating to the local Consorts the best way to move on from the tyranny of the Denizen"];
    @override
    List<String> handles = ["serious", "sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
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
        new AssociatedStat(Stats.SBURB_LORE, 0.5, false)
    ]);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Sage's Robe",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.COMFORTABLE,ItemTraitFactory.SMART, ItemTraitFactory.MAGICAL, ItemTraitFactory.LEGENDARY],shogunDesc: "Pompous Asshole Robes",abDesc:"So sagey. Needs a beard or some shit, though."))
            ..add(new Item("Peer Reviewed Journal",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BOOK, ItemTraitFactory.SMART],shogunDesc: "Book Containing More Corrections Than Actual Content",abDesc:"I guess this is p well reviewed."))
            ..add(new Item("Guru Pillow",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.PILLOW, ItemTraitFactory.SMART],shogunDesc: "Headrest For Smart People",abDesc:"Huh. What. Was JR thinking. When they made this item?")); //JR: I have no fucking clue.
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Books","Libraries", "Tomes", "Pages","Advice","Scholarship","Expertise"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has blocked access to the books for the duration. The ${Quest.PLAYER1} has no choice but to go get some fresh air for a change and start collecting frogs. The ${Quest.PLAYER1} thinks hard and figures out the best way to organize the ${Quest.CONSORT}s to start collecting frogs. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Be the Sage", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, it is time to begin recovery efforts. The ${Quest.CONSORT}s ask the ${Quest.PLAYER1} what they should do first.  When they hesitate, the ${Quest.CONSORT}s begin ${Quest.CONSORTSOUND}ing in distress. Desparate, the ${Quest.PLAYER1} confidently advises them to begin cleaning up rubble. The ${Quest.CONSORT}s seem satisfied.  The ${Quest.PLAYER1} absconds into a nearby library to read up on how in Paradox Space they can figure out what ACTUALLY needs done. "),
                new Quest("The ${Quest.PLAYER1} has read up on disaster recovery and helps the ${Quest.CONSORT}s plan the next season's crops, build infrastructure and even set up psychological counseling center for those in need. Every moment they aren't in public they are devouring tomes in an effort to stay one step ahead of everything."),
                new Quest("Finally, recovery efforts are complete. The ${Quest.PLAYER1} has developed quite the reputation as the person to go to for advice and knowledge. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
