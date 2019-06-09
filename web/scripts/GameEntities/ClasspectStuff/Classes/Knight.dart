import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Knight extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.51;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "Knight I:___ N4IgdghgtgpiBcIDSYCWBzAFgFwAQEkQAaEAMwBsIA3AewCcAVGAD2wRAB4AjAPgGV8AEQCiARQCqwvg3gcA9L1wNMMXHwDCwgHLCA+gHkA6joBKurQEEAssNyoAzrgAOdGthgBjbKjDpcEXABHAFcYezx0VCoYOn9HJwg6PBpSf1x7VAATGBCw7AA6XH0wD1UIcnJcbBVcGi5wiA9yMP86VSaYRJhMoiqa3PDcSOjYzAgwTMdq1Q1tPSNTc2tbANgIe3IAT1w2gHdEzNwuGFJ6VXcKnz9pqD6IPGqHXDGnJxgweLbsbG2U9zBCnwaLAaGBVJkHBBXjQfO4en0ZpodAZjMIzJYbLh9uQANaOCD7bZjKhXXCkYJJFRtQ7TVCxFhvOiod6lOxgZyudxeUluKn2fIAHTA3DoPBFPGIIGwiXQMGwxTgiGwdFCkuVGFldHUoIh3lB9gAMlEruwANrAAUgVBQJz0aVgbCGeiZS3wS1aOQWS1Ed36Biuy2kcr2GDey0ANRM+D4SC9CEDwdDxEtkFgAZA+HsfBg5FIYatNrt42w+Ad6YADJaAL69C0F21JYtOugu+MgD1xn3tv3poPkEP5yPR2O9xP51NJt0Z+wWchRJNd60N+0lsttysgGu4OtLosO5utqcd-NaHtt5WhQdRmNxqd9gfJ8DQSeWzMAcRomQYzLo+d3jYdUtsArata0tf8VwPdMAAVyGCDwcSUGgcXeeBdHQ3AtAAFnwdBMiwdBsHQJxUAAIQ8fALFjLgLDodAAE1di0eiLEowILAATnIAArN91AsQRRHQUioCQYQLC4dBRGEABWLDdgsGALANSJ9D4N9mAsXZ9EYgAmRSGFI5hhHIdR1HQQR9A8dQoF2ejSINU58HszALCgCw3NQbAaHsABmPhrDcQIkF2ABaBh0DfABGdALAACRMdQkBoCxSPLCAAA5dho-RAisbBMgAaji+zNgsaDRAsdAwAALRxUL7AAKSw6DID4KxuPUTB8NI9jhBSnELNjLR8EwdQtAAMT4ewqDi9Byzi2T8HUMA+AgBgLBocgLHEfQAC90E2YIuHUODxACgSSosKgoFELDsCoGr9ANTBSOCXw9pgRr6Limr6L4UjCqkctmEKmA+EawIatqqhyBMGTmCe0R7HUKLyD4eitAgUiJosKLQtIQxBG4jxy3IAB2ALMmUuhrPsQJAjfbBAgANkKqBSLfQqopq3yJsEdRxHIQQLEx7iAtI1BeKsJwwCsAANXSsKoXzCvQRrSPo6DdPLVBMDii6TzPKcLwXCNrxHNt7zNp80zbOL1j4UowT-QsANXYD11A7dwLdyDnXTY9H1Pf0rbHR8hxvUd+xtid00zExxkyYFXeXYsgPTXzfOrABdNUmXQTVtQmLzUH1A0k7NPOSBOUhPGwewJvoI0SV8M0dz9psA7bKwfGtYJbgNeCcXHZ90y68ZZSsTY+GlT2u0jy273DxdO4dLQB+OX821CqLs83MD6z3R1u6nCa2lUQxUAqUe7anCffBgafZ-uK9h1vBMY9T4+N6gLf0z3t7Duad9yn0tLBYeSEUJgDQhhbCuF8KYEIsRMiFEqISVogxJiLE2KcR4nxASQkRJiQklJWS8lFLKVUupTS2k9IGSMiZMyFkrI2Tsg5JyLk3IeSgF5Hy-lArMxCuFSKMV4qJWSqldKWUcp5QKsVUq5VKrVTqg1ZqrUIDtU6t1YSfUBpDQsCNMak1pqzXmotGSy1VrrU2ttXaB0jonTOhdQQV0bp3Qek9F6b0PpfR+n9AGQM+AgzBhDKGMM4YIyRijNGGMsY4zxgTImJMyaUwsNTA0tN1D00ZszNmHMuY8z5gLIWIsxYSylm+GWctFbK1VurTW2tdb60No+OObY3zzgsNyUEb8o7nhVDbCCxZf7-y9puauIBa710bs3JO9gq6biAA",
        "Knight II:___ N4IgdghgtgpiBcIDSYCWBzAFgFwAQEl8QAaEAMwBsIA3AewCcAVGAD2wRAB4AjAPgGV8AEQCiARQCqI-o3icA9H1yNMMXPwDCIgHIiA+gHkA6roBKe7QEEAsiNyoAzrggOA1jAAmubLVwAHelpsGABjPAhcDxgyGDAHGAoYByd0QIBXP1xaMmcKClQkgDpcCWxUfIAvVDB0b1VUelxLBz9QvB97bBT6GAhghzw-INiyiApiOrVNHX1jMwsbOwcAd1paPydq5zAvBxokyciIAE9ilRhj73o0iku0nZh6AYgd3GXMPs7cWBenDu41BEUBgcIUADpgHj0XhQ3gkEDYCD0dAwbAGMBwRDYa5wUjYjAo+gaWg7VBlEkOAAyqGo1XQHAA2sAwSBUFAhvREWBsEYGB4WfAWdp5JYWcQhQZGAKWWQxvExSyAGqmfD8JCihAyuUwBXgaA6zUgfAOfgJMi6tkcrnYfDc6UgAAMLIAvhNmaz2Qxrbz6PzDcKNeKQNpJfbZRR5SQlSq1RrBeRtbrILB7cbLPlqAag5avS8bXbDU6QK7cO6c5y8z6-fGA7qQ1LDeHI0Hlar1WHE1G9SnDcaAOK0DyMAr0C2eivc23Ye1Fktl8fevn2gAKFDSIVcylo7jA8D0+9w2gALPh0B4sOhsOg-KgAEIhfCWdXcSzIgCay20b8sj4AjpYAE4KAAKz7DRLCEMR0FvKAkBESxuHQMQRAAViPZZLBgSxKXQVADH4PsWEsZYDA-AAmTDGFvFgRAoDQNHQIQDBCDQoGWN9b0pMhaHwDjMEsKBLAEslaAcABmfgbCCX8kGWABaRh0D7ABGdBLAACVMDQkFoSxbwdCAAA5lhfAxf2sbAPAAanUjjjksZcxEsdAwAALVcOSHAAKSPZdIH4axgI0TBz1vf8RF01xGPVbR8EwDRtAAMX4BxqHU9AHXU1D8A0MB+AgRhLFoChLAkAwKnQY40m4DQ1wkSSINsyxqCgMQj2wahXIMSlMFve50AqGAvLfdTXLffhbys6QHRYKyYH4Lzf1ctzqAoUwUJYLqxAcDRlIofg320CBb0SyxlLksgjCEYCQgdCgAHZJI8bD6BYhxf1-PtsF-AA2KyoFvPsrOU1yxMSoQNAkCghEsQ7gMk29UFA6w-DAawAA0yKPagxKs9AvNvN9lzIh1UEwdSGrrUNDWxNIs2jNs4y1CN6e7A143Ulx+BCWJWfLa0pxnF03RZfnKyXf0RSpht4ybVnW1jDsWaTfVUwcUwXg8WgoDHK080Fw0fp+l0AF14XxdBCWJUlyTiSlNcZM3SGiGIwgcRKGGpWkakZec9e5Kt7Wsao2TSKBcEpddXBVnt42Cl4UWsY5+ERacuwV9tG07bMFzzbQw4BUdDTk5SxNnEWPX9nkJfjRKejUIxygoGP2ZZeOahgJOU76XUM6ZhNla7MXuXzqBC-tUvy9LUXc4DmuWVXKOtx3PcD2PU9z0wS9rzvB8nwQ190A-L8f0sf8gNA8DIOg2D4MQ5C0IwrCcLwgiiJI8jKOo2j6MY5jWPYpxbivFbz8UEsJHw4lJLWGkrJBSSlVIaS0jpPSBljKmXMpZGydkHJORcu5TyPk-IQACkFEK0FwqRWipYWK8UkopTShlLKKEcp5QKkVEqZUKpVRqnVBqQgmotTah1LqPU+o1EGsNUa41JrTVmvNRay1XKrXWptAw21dr7UOsdU651LrXVug9J6L03ofS+r9f6gNgag3BpDaGsNtDwz0kjPsKM0aY2xrjfGhNiak3JpTLsyZW4gD7DSLCYRUAkl7jGTO8ZaZ81ntgUe49Cym3hC7No7tPaawcI7YsQA"
];
    
    @override
    double difficulty = 0.7;
    @override
    List<String> levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SKULLDODGER"];
    @override
    List<String> quests = ["protecting the local consorts from a fearsome foe", "protecting the session from various ways it can go shithive maggots", "questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader"];
    @override
    List<String> postDenizenQuests = ["", "spending way too much time hustling from village to village, saving the consorts from the denizens last few minions", "breaking a siege on a consort village, saving its population and slaughtering thousands of underlings", "finishing the legendary tests of valor dispensed by an elder consort"];
    @override
    List<String> handles = ["keen", "knightly", "kooky", "kindred", "kaos",];

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
    bool isHelpful = false;

    Knight() : super("Knight", 3, true);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Shining Armor",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.PLATINUM, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SHIELD],shogunDesc: "Kyoto Overcoat",abDesc:"Knight Shit"))
            ..add(new Item("Excalibur",<ItemTrait>[ItemTraitFactory.LEGENDARY,ItemTraitFactory.PLATINUM, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.POINTY, ItemTraitFactory.EDGED, ItemTraitFactory.SWORD],shogunDesc: "Masamune",abDesc:"Knight Shit"))
            ..add(new Item("Noble Steed",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.FLESH, ItemTraitFactory.SENTIENT],shogunDesc: "Horse Prime, Envoy of the Ultimate End",abDesc:"Knight Shit"))
            ..add(new Item("Hero's Shield",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.SHIELD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.PLATINUM],shogunDesc: "A Weaklings Way Out, Shame Upon You",abDesc:"Knight Shit"));
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
        return 2.5;
    }

    @override
    double getMurderousModifier() {
        return 0.75;
    }


//protect, defend, fight, exploit. aspect is dragon you face and weapon you wield all in one.
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Heat","Volcanos", "Flame", "Lava","Magma","Fire"])
            ..addFeature(FeatureFactory.OVERHEATED, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Breed the Frogs", [
                new Quest("The ${Quest.DENIZEN} has cooled the lava enough for water to begin pooling in places, which attracts frogs.  The land is less overheated. The ${Quest.PLAYER1} collects all sorts of frogs. Various ${Quest.CONSORT}s 'help' by ${Quest.CONSORTSOUND}ing up a storm. "),
                new Quest("The ${Quest.PLAYER1} has a weird system going where the newest zapped in tadpole presses the buttont to zap in the next one. Things are going almost as quickly as if they had another player's help. "),
                new Quest("The ${Quest.PLAYER1} has found the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Exploit the Heat", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s could really use some basic infrastructure repairs. The ${Quest.PLAYER1} finds instructions for a thermal energy converter in a dungeon and alchemizes all the parts needed to build one. The ${Quest.CONSORT}s will have power for generations,now. "),
                new Quest("An important wall is crumbling. While the defeat of the ${Quest.DENIZEN} means the underlings are mostly under control, the ${Quest.CONSORT}s would feel a lot better with it fixed. The ${Quest.PLAYER1} figures out how to patch it up with bits of cooled lava. Everyone feels just a little bit safer."),
                new Quest("The ${Quest.PLAYER1} rigs an automatic lava dispensor to light fire moats around consort villages, automatically patch wall holes and even bake consort bread.  Who knew all this shitty heat could be good for something?  The ${Quest.CONSORT}s quality of life is at an all time high! ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Fight the Beast", [
                new Quest("A fiery ${Quest.MCGUFFIN} Dragon has risen up in the wake of the defeated ${Quest.DENIZEN}. A Learned ${Quest.CONSORT} explains that it can only be defeated by the Legendary ${Quest.PHYSICALMCGUFFIN} Blade. The ${Quest.PLAYER1} prepares to go questing for it. "),
                new Quest("The ${Quest.PLAYER1} finds the Legendary ${Quest.PHYSICALMCGUFFIN} Blade stuck in a rock. After a lot of fucking around trying to remove it, they accidentally snap it in half. Welp. Guess it can't hurt to go fight the ${Quest.MCGUFFIN} Dragon anyways. How much harder can it be than a ${Quest.DENIZEN}, anyways?"),
                new Quest("The ${Quest.PLAYER1} is engaged in an epic, yet conviniently off screen strife with the ${Quest.MCGUFFIN} Dragon. Nothing seems to have any effect untill, out of desparation, the ${Quest.PLAYER1} pulls out the broken Legendary ${Quest.PHYSICALMCGUFFIN} Blade and chucks it at the mighty dragon. A blade of ghostly ${Quest.PHYSICALMCGUFFIN} extends from it an the dragon is vanquished.  Huh. You....guess that the blade was always supposed to be like that? Huh.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Protect the Consorts", [
                new Quest("The volcanos of the land are weirdly active after the defeat of the ${Quest.DENIZEN}. One begins to erupt near a ${Quest.CONSORT} village.  The resident ${Quest.CONSORT}s are filling the air with panicked ${Quest.CONSORTSOUND}s, but not really doing anything to evacuate or save anyone. The ${Quest.PLAYER1} face palms, then begins wildly captchalogging everyone in order to get them to safety.  When they let everyone free, the village is destroyed, but at least it's people are safe."),
                new Quest("Another day, another volcano is erupting. After decaptchalogging the final rescued ${Quest.CONSORT}, the ${Quest.PLAYER1} thinks that there MUST be a better way."),
                new Quest("After a lot of false starts, the ${Quest.PLAYER1} has managed to rig a system where the rising heat of the lava itself will trigger entire ${Quest.CONSORT} villages to just rise up out of harms way. Hell yes!")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}
