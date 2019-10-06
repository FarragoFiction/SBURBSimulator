import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Doom extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.00;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 0.5;

    @override
    List<String> associatedScenes = <String>[
        "[Resolved Ambiguity]:___ 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",
        "[A Chosen Thread]:___ N4IgdghgtgpiBcIDaBBABAYQBYHsDOMYaAKlgE4wQAmAuiADQgBmANhAG45nEwAeALghAAeAEYA+VJlwEipCtRrCA9BIA6YMWXEbSMNAGUMAUQByxgPoB5AOrmAShdMoAssbQBXMAGMc7GGR4aBBoAA5kOKFYMN4AnsGiOB78aPzRJCj2AOLGxE6ullaOzm4GAHQk6cSZOXklhcUFBmgAlkEwUKE4AO4BMFRoovFp+kZmhXbGjW6tRFxUAak4aEweLEwtLCypWG1hEVExsWUaWuJnDCD8EGQA5jD8VmBwiPxkHnCMby2392QYODAVBa-BagLwABkWuwWmBbkIkMA1CAWp0uNcwPwbPNkfBkS4cKJNiDYsj6MjTFZiLjkUwICwCGTkQA1ewASQMAGkUDTmPTGQxkZBYLyXLEDNd+Gy8FkFPwAqQIGBmfSPkyUWiyBipZjeQBGADMyIAvvQ0EiNV0tUqsTiEMiAAosDzeADWJBwrsI8AsvrQpgALGzblRblhbvxbqEWgAhbxslDc0QoO4ATW6plTKATAEcUABOFgAKyyGBQABEAIq3GNQTnGFCiW6V4wAVgD3RQMBQENuLSsBiyvBQ3Ss6YATF3iDHeMYWBgMLdy1ZvBgoN1UzGIUwcGzN1gUFAUIeQfgDQZXDh+DnOd0ALTEW5ZPW3FAACXsGE5OBQMYADBAAAc3TJlYOYuPwVAANRvpusQoA6lYoLcYAAFquneeAAFIBg6kAGC4RbYKGMZ5sYP6uku3KmGyWAYKYABiBh4Owb63H+b5tmyGBgAYEDVDgLAoAAqlYABetyxB4ogYM6wkXhWsEoOwUCVgG-DsKhVgQlgMZeLcYkwFhqZvqhqYGDGUHGAYf68FBMAGFhOaoWh7AsPYra8FplZ4BgeosAYqamBAMYMSgep3kwNjlkW3h-iwADsF5UD2ZCrngOY5lk14AGxQVAMZZFBeqoQaDHlhgwksOWKBBUWF4xi0JYuKEYAuAAGuOAbsAaUG3FhMapg645-i0WBvgp6qUtS9p8gyMDqqyHLcrybxqoK4DQAts1vhAeAGN4hDbeSlrojabK6rNf4mmaFqola2rYmQVC8qYyg8ht028nS82LeyXIfXic0CidwrbUD0ooCw0LHci91nZiF38Ly10gKa5pw5qj12kDb0fSdX2zT9IMsv9K1E-ysObSKs3SvYSpUDgUDqvD1qI5dQOtqj6N3VjNpPS9CBgGsLAE1S32U39y2A7SksbWDoqxFY0ZgGCYBWEwxA3PcUoynKCpYEqKrOlTrPakjvKtjdGOnWztrPa971TeLFO-RtS0A6t7xUwrO17QCnQsA8-RQywEIM5WHx4PweAs3z7PI1d1u8w9-M4xSTufS7QNrVTHvk0DxM+1tvK7XgKDeKC-gOgc0RxHHqcJyjyeY439uC7jmdizNOfe1LnuuyT1Pg8iZcMSLGxbP0NeRHXpIbWb50c8i3N0F8ZA-H8AJAiCauQgzCJryAMBMEwMQxwxXBQjCcIIinCPt7yTouu6xCet6voWP6QYhmGEZRrGeMiZGwpluOmTM2YUB5kLCWMsVYax1gbE2Fs7ZOzdl7P2Qcw5RwTinDOOcC4lwrjXBuLcO49wxgPEeE8-AzwXgJNeW8D4nwvnfJ+b8v4ALAVAuBSCME4IISQihdCmEcJ4QgARIiWASJkQolRFANE6KMWYqxdinFWzcV4vxFAgkRLiUktJWSHh5LHnLEpFSakNJaR0npOEhljKmXMpZaytl7KOWcq5dynlvK+X8oFYKoVwqRWirFeKSUUApQhGlDAGUsq5XyoVYqpVyqVWqrVUw9VfxNSyC1NqnVuq9X6oNYao1xqTXliXWa9gOh+G7JXNW-cC7Ilzg3B+pgPBQFEAEZuaNbqtwfgLR2+MhSVKBtgJU9xlawjVhrFwecyYy2BqbeO-B2mdO6bNK2vSbaL0xIM2aDoegbNBqM5E4y4QOUlI0xZRdWl2zWV0sg+oDTcz6bbbGDtZp43VL7IGLgIBegrlXGAM9Dj13dgsiWbsTq7NWR0x5PTjRHxPmfSueBL5kHDkCPAh80ZAA",
        "[Sacrifice]:___ N4IgdghgtgpiBcIDaBlCBjATgSwGbfRgF0QAaEXAGwgDcB7TAFRgA8AXBEAHgCMA+VBhz5CRLgHp+AHTC9MfGYwAWMAAQoAwgFEAcloD6AeQDqegEr6dAQQCyW1QBNMEbGADOqtiuyZVdAO5gqgAOATC+uAyeKqo8MGAw+Gx+uNFqjFZmAOJajJa2BoYW1nYoAHQycnxVZCBsEJgA5jBshgmcbJgArnDkndiNzZgadGAO2GzYo24AMtg0ro2cSMBSINhQoZj1YGzGDA5r8Gs2ECwbXVCqM13oANZrpGs6hoxHa7gQlG4wj2sAamYAJIoADSVneFC+Pz+4GgvwQJwAnih6mwgW4spgYBA2OFlBAwP8vj1YRstjt0btIQBGADMawAvqRVKt1psGJT9phDoiQAAFSi3O6qRh0O7xeD6aWqHQAFiBjQcjSUjTYjWC2AAQuggVZwTwrE0AJr+HTGqx6gCOVgAnJQAFZZDRWAAiAEVGlqoKCtFYeI13VoAKxy-xWGBWGaNbCGFBZFhWfyGU0AJgjjC1LC0lA0GkarsM6A0UH8xq1M0iQPLSisUCsdYmdDcdJQtjobCtoP8AFpGI0sjTGlYABJmDSguhWLUABggAA5-IbDFabGwHABqEflpFWfnuqyNMAALTuPbcACk5fzICgbA6NEplVqbVop3cC+CdEClBodAAxFA3BoEdGhnEcQyBDQwDQDI6EoKwAFVDAAL0aJEuh4DQhUQts3W3KwaCgd05TYGhj0MGYlC1LowEaFCYAvY0R2PY0UC1DctBQGcWA3GAUAvK1jxPGhKDMYMWAo903A0GlKBQY0dAgLV-ysGke1wYxXQddAZ0oAB2NsHCjTBizcK0rSyTsADYNygLUsg3Gljzpf9XQ0RDKFdKxFIdNstWwJ0bGCMAbAADVTOUaDpDdGgvLVjX5VMZ2wJQRzw2EXjePlPm+BEnhAQEQXBSFOlJMg1kgWBIRHCA3BQQgEjJDltkJKk2EhGcmRZNlyU5NruV5Y4QB0cQIQqkbXkhXKYQmoqwXG4aZvyyr4UhDErEoeYVvZCk2qBak+S6kBmVZNY+ta3ZBshUbxoKrLpuhHb5pKnKnthKqEWGjEzEJBw6CgZq9t2A6Or5YNjtO3qWq5A4jjALpKEoe6prevLYRexaPneibPshGwkUMTUwCmMBDFwRgGmadFMWxXF8SUQliSFHaLspUHIWDbqzt2-qrrhvlbsy1GlpxgrMdK7odrxvlapkgHgkoFoYAcV14mwBiwBmP73R6Nw2DcIG+fazrueh4G9gF4aRxxSgvGF7LRfRubgQWx7nYKmXhoJ1FcQxLEcTxJhGaJElWZh-bDuG+kZ0hnrzoj-meUhfkwkwB33dm8XXdep2s9W6q+R9tF-bpoOCVDlmjcuk2+RjuOebZgareeMaM75MrnpzrGoQ9guvrWDEUBgShcGr9mo7WSGSD6HBBnCEYxgmUnZj+5YZ5ARJcBgdADf-Bg5gWOjlnN43rr5QVhVFcVJWlfRZQVJUVTVDVtV1fV-SNRpTXNS0rBte0ToXQei9D6P0AYgyhnDJGaMsZ4yJmTGmDMWYcx5gLEWEsZYKxVhrHWBsUAmwtjbDYDsXZez9kHMOMcE4pyzgXEuKwK41ybm3FqXc+5DwnjPJea8t57yPmfK+d8n4rDfl-ABICIEwIQWDFBGCEA4IIWQmhDCWEcJ4VdARIiJEyIUSojROiDEmIsTYhxLiPE+ICSEiJMSEkpIyTkgpJSKk1IaS0jpPShkrDGRmKZDQ5lLI2Tsg5JyLk3IeS8j5HQflpyBSyMFUKEUooxTiglJKKU0oZVxmtPkZgYBQDoDQSMu9SYY27pLcqBUm67B0JcOI6cjpmwThbc+w0hbZMLsNR8hJmhE1cKTcmNgu7FR7stcebValQHqZzJpvMa6tLWKnfw4QPo5K6SHZoxdcRlJGZncOFtJnTL5D2GOszqmW2TrLW29sOkDxAN0uiMAtlg2zrstG+c5mUkOSs45pyTrx0+c3S5w0lk-M9mstYDzmi+xeQCcp7z9nG2+Q06OdIG6n3mS3EANsvg3PBZ0yFGz+Joh2W7BF4yal1J+ai6etQt47z3gfP6bh14nSAA",
        "[Call To Action]:___ N4IgdghgtgpiBcIDaBhCAbdACAKgeywEEBjAFwEs8wBdEAGhADN0IA3PAJxxgA9SEQAHgBGAPlQZs+ImUo1BAejEAdMCI6jVOABYwsAZRQBRAHJGA+gHkA6mYBK5k4QCyRgOQBnLDDAwoATzosUl1cQjsAcSMcRxcLSwcnV30g8i9WGA5-LDxhVkoAVw90bIATPDxYUqCIMFKsclJPLAKAB2CCEL1DU3jbI0S4jqwPUjx2rqgAOlV1UTn6EFIIDgBzGFJLXwFSDgK4Bl3yVfWOFCpSxrkPABlyfLBVgSRgZRByKFbOZbBSa05Sm94G9nBAeB8ClAsDcCsQANZvOhvEyWHBAt6MDAeGCIt4ANTsAEl9ABpQjophYnH0N6QWAU5z+fTLUiEjwRDgwCCkTI6Wp4jD7XHvT7fWqs34UgCMAGY3gBfIKvEVfDg-P4AikABXQsLhuDwcJ88HMpqwJgALITVqVVtpVqRVq1yAAhYiEwhk4SENYATQA7iZfYQPQBHQgATnQACsIihCAARACKqxdUBJRkIwlWSaMAFYLf7CDBCDdVuRLPoIjxCP7LAGAEzFnAunhGdAoFCrBOWYgoKD+30um6MPCEofaQhQQhTxp4Dwy-QuPCkUMk-0AWhwqwiUtWhAAEnYUCS8IQXQAGCAADn93ssoecpFKAGoD0P-IQtUnCKswAAtOENw8AApC0tUgfRnGjFBtFtF1wyMM84W7MkTEJbQUBMAAxfQPFYA9VgvA980JFAwH0CAcEIPB0EIABVSwAC9Vn8AphBQXV6KXRN30IVgoCTC1SFYf9LBubQXQKR4mJgEDfQPf9fX0F0XyMfQLx4F8YH0EDQ3-ADWHQOw8x4MSkw8FApXQfRfRMCAXWwwgpQ3RhrATaNiAvdAAHYl1KUsOD7DxQ1DCJVwANhfKAXQiF8pX-GVsITFB6PQBNCDs6MlxdchY2cVowGcAANBsLVYGUX1WECXV9LUGwvchtAPHjhRRNEEAxKlhQJYkyQpXYhRpcBoGpYEQAPCAPH0YgfGpJEVTFX5CUlTqQAvBUlTeD5VXVf4OEBNaTAUclhvailMXQbEeqJUlTvGy7ruGukxreNlCHQe55u20U1XFFbSApDaQEVLBlR2paNQOiljtOhbzrWx7vpAXq7ou7rntGik2TsWpyigYUIb+5bVvGvNgdB8Hfr2zUEDAApMHh1EBr2ZHUf6xGMYWl6GX8SxnTAORLEYHAVnWVl2U5bleW0flBWRon1QBikNwazawZ+3bxX2w7xthtrmc5q62dujnxsG5GebWybLMqVp0A2GBSmw8gOFGG48aTfZRg8Qnqf+0m3gprbFuJqHdZBXJyE+0h-ANjrzdZm6+vurrjeFK3xtFtYNmZbk2Q5LkeS4WWivIXw-a1knAbW4ONdDmnoaOk74-R9PhvZ1PKXb7msetqaSAoDItQ4cZdGIOPhsVgOa-GinaEODhjlOc46iuKhbjx54F5AGBGEYGAyA8bDODuB4nkQF5NchnXtV1eEDSNMATTNS1rVte1HWdN0PS9H1VgDEGEMhBwxRljPGZMqZ0yZmzLmAsRYSxlgrFWGsdZGzNlbO2Ts3Zez9kHMOUc44XSTmnLOMYC4lzOBXGuTc25dz7iPCeM8l4bx3kIA+J8r53wuk-N+X8AEgKgXApBaCsF4KIWQqhQg6FMI4TwgRIiJE8xkQolRGidFGIsTYhxLiPEEx8QEkJESYkJJSRknJBSSkVJqQ0lpHSekDL-iMiZMylgLJWRsnZByTkXJuQ8l5Xy-lArBVCuFUMUUYpxQSklFKaUMpZRynlCIBUiqlXKpVaqtV6qNWaq1TG9I1p2D8HgDIg85DJzRmtC2ldIYmEhMITIQN1ZUyruHGGLd8mvRALBWo6x+blyFowZwJsU5tyegtaevw6lQAaRwFWUo64tJvrTPWHTe4FPGnnNUzIl4HwqWbNO4zr5h2mbMppIMd57wPkfE+HAPZ1A8NvEGQA"
];

    @override
    double difficulty = 1.0;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#0F0F0F'
        ..aspect_dark = '#010101'
        ..shoe_light = '#E8C15E'
        ..shoe_dark = '#C7A140'
        ..cloak_light = '#1E211E'
        ..cloak_mid = '#141614'
        ..cloak_dark = '#0B0D0B'
        ..shirt_light = '#204020'
        ..shirt_dark = '#11200F'
        ..pants_light = '#192C16'
        ..pants_dark = '#121F10';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dancer", "Dean", "Decorator", "Deliverer", "Director", "Delegate", "Destined"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Dark", "Broken", "Meteoric", "Diseased", "Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["doom","rules", "fate", "judgement", "fog", "gas"];

    @override
    List<String> physicalMcguffins = ["doom","bone", "skull", "mural", "gravestone", "tome", "tomb"];

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Doom', 'Hades', 'Achlys', 'Cassandra', 'Osiris', 'Ananke', 'Thanatos', 'Moros', 'Iapetus', 'Themis', 'Aisa', 'Oizys', 'Styx', 'Keres', 'Maat', 'Castor and Pollux', 'Anubis', 'Azrael', 'Ankou', 'Kapre', 'Moros', 'Atropos', 'Oizys', 'Korne', 'Odin']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.MIN_LUCK, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Doom(int id) :super(id, "Doom", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.doom(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("~ATH - A Handbook for the Imminently Deceased ",<ItemTrait>[ItemTraitFactory.BOOK,ItemTraitFactory.ZAP, ItemTraitFactory.PAPER, ItemTraitFactory.DOOMED, ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY],shogunDesc: "A Huge Ass Black Book on Coding or Something",abDesc:"Don't use this to end two universes, asshole."))
            ..add(new Item("Egg Timer",<ItemTrait>[ItemTraitFactory.PLASTIC,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.DOOMED],shogunDesc: "Egg That Counts Down to Your Death"))
            ..add(new Item("Skull Timer",<ItemTrait>[ItemTraitFactory.BONE,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.DOOMED],shogunDesc: "Skull That Counts Down to Your Dinner Being Ready",abDesc:"Everyone is mortal. Besides robots."))
            ..add(new Item("Poison Flask",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL, ItemTraitFactory.POISON],shogunDesc: "Glass of Bone Hurting Juice"))
            ..add(new Item("Ice Gorgon Head",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL, ItemTraitFactory.COLD,ItemTraitFactory.DOOMED,ItemTraitFactory.RESTRAINING,ItemTraitFactory.UGLY,ItemTraitFactory.SCARY],shogunDesc: "Oddly Attractive Decapitated Head"))
            ..add(new Item("Obituary",<ItemTrait>[ ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.SCARY, ItemTraitFactory.DOOMED, ItemTraitFactory.PAPER, ItemTraitFactory.ASPECTAL],shogunDesc: "Omae Wa Mou Shindeiru in Paper Form",abDesc:"I wonder whose it is? Yours?"));
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Death", "Endings","Mortality", "Graveyards", "Bones", "Funerals","Skulls", "Skeletons","Cemeteries", "Graves", "Tombstones"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Empty the Graves", [
                new Quest(" The ${Quest.PLAYER1} learns of a Omni-Lich that has been emptying the graves of the ${Quest.CONSORT}s, who are understandably upset at this disrespect to everything their culture holds dear."),
                new Quest("The ${Quest.PLAYER1} hunts down the Omni-Lich, only to discover that it cannot be killed without the use of a mystic ${Quest.PHYSICALMCGUFFIN}. The player begins to search for this totally USEFUL and IMPORTANT item. "),
                new Quest("The ${Quest.PLAYER1} finds the ${Quest.PHYSICALMCGUFFIN}, and slays the Omni-Lich, scattering its bones to the winds, which, according to ${Quest.CONSORT} traditions, should summon its master. Uh. Eventually."),
                new DenizenFightQuest("FINALLY, the bones of Omni-Lich has summoned it's master, ${Quest.DENIZEN}.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s are free to bury their dead in peace once again.","The grave robbing of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Disaster", "Fire", "Ash", "Armageddon", "Apocalypse", "Radiation", "Blight", "Gas", "Poison", "Chlorine", "Wastelands"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)

            ..addFeature(new DenizenQuestChain("Become the Warlord", [
                new Quest("The ${Quest.PLAYER1} has found a group of Violent ${Quest.CONSORT}s whose society has long since crumbled. They live in roving bands, willing to kill and maim to gain access to '${Quest.MCGUFFIN}', the fuel their post apocalyptic society runs on. "),
                new Quest("The ${Quest.PLAYER1} has survived a small assault team of Violent ${Quest.CONSORT}s, and is declared their new leader. They beg and grovel and ${Quest.CONSORTSOUND} and ask that the ${Quest.PLAYER1} help them take back their ${Quest.MCGUFFIN} from a rival gang. "),
                new Quest("The ${Quest.PLAYER1} is now the warlord of nearly all of the Violent ${Quest.CONSORT}s. There is clearly not enough ${Quest.MCGUFFIN} for everyone, though. It turns out that the ${Quest.DENIZEN} has been hoarding it all to cause scarcity to breed violence and anarchy. What a huge bitch. This cannot stand. "),
                new DenizenFightQuest("There isn't enough room in this wasteland for the both of them. It's time to take out the ${Quest.DENIZEN}.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} distributes the hoard of ${Quest.MCGUFFIN} to the Violent ${Quest.CONSORT}s and keeps the hoard of grist for themself. ","The ${Quest.MCGUFFIN} shortage continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Make This Stupid Planet Habitable", [
                new Quest("The ${Quest.PLAYER1} is sick of their stupid uninhabitable planet, and so starts to make sections of it habitable through judicious use of alchemy and ${Quest.PHYSICALMCGUFFIN}s alike. "),
                new Quest("${Quest.CONSORT}s begin to flock to the safe areas that The ${Quest.PLAYER1} constructed, and begin to make tiny villages within the safety of its zones. Precious  ${Quest.PHYSICALMCGUFFIN}s are found in some nearby mines. "),
                new Quest("The ${Quest.PLAYER1} has straight up established a new consort government in the safe zones. This is so deliriously biznasty it threatens the very existence of anything un-nasty in all possible timelines. Alas, while ${Quest.DENIZEN} remains alive, the safe zone will be temporary at best. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the safe zones. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is finally free to continue improving the land. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Prophecy","Prophets","Fate", "Destiny","Rules","Sound","Judgement","Carvings", "Murals", "Etchings"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISPERSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.LOW)

            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} finds a small dungeon bearing the image of ${Quest.DENIZEN}. At the bottom, they find a switch inside a small hole they can just barely fit their arm inside. When they reach in and flip the switch, they feel something attach to their arm with a loud click. The ${Quest.PLAYER1} pulls out their arm to find attached is some super complicated machinery complete with a timer counting down. That can’t be good."),
                new Quest("The device continues to count down. After consulting with local ${Quest.CONSORT}s, the ${Quest.PLAYER1} navigates another dungeon in hopes of finding a clue to removing the ominous device from their arm without causing it to go off. Past complicated puzzles involving doomsday dates and scales, they find a small scroll on a pedestal. Written on the scroll is a prophecy that the ${Quest.PLAYER1} will permanently die in an explosion from attempting remove a device on their arm. Well, that’s just great."),
                new Quest("The timer doesn’t stop from counting lower. The ${Quest.PLAYER1} makes up their mind and decides they’re not going to sit and wait until the timer goes off. They’re going to remove the stupid thing, prophecy or not! They quickly pry it off their arm and throw it away as far as possible. There’s no explosion; the device just breaks. Did the ${Quest.PLAYER1} use their powers to stop it from exploding and break the prophecy, or was this all just a shitty test from ${Quest.DENIZEN}? Either way, the ${Quest.PLAYER1} isn’t very pleased with the ${Quest.DENIZEN}."),
                new DenizenFightQuest("The ${Quest.PLAYER1} tracks down the location of the ${Quest.DENIZEN} ‘s lair. It’s payback time!", "The ${Quest.DENIZEN} has been thoroughly beaten. Serves them right for playing such a mean trick on the ${Quest.PLAYER1}.","The ${Quest.PLAYER1} couldn’t get their revenge. ${Quest.DENIZEN} has a hearty laugh at their expense.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} learns from one of their ${Quest.CONSORT}s that there is an ancient prophecy of a ${Quest.MCGUFFIN} plague that is due to kill them all any day now."),
                new Quest("The ${Quest.PLAYER1} gets deep into the nitty gritty of the apocalypse prophecy. They learn that the plague is not technically going to hit the consorts- it's going to hit the bearers of the MAGIC ${Quest.PHYSICALMCGUFFIN}, which currently happens to be the ${Quest.CONSORT}s. "),
                new Quest("The ${Quest.PLAYER1} goes on a daring series of stupid missions to deliver the MAGIC ${Quest.PHYSICALMCGUFFIN} into an underling camp, thereby redirecting the incoming ${Quest.MCGUFFIN} plague into devastating the underlings instead of the ${Quest.CONSORT}s. The underling army is all but decimated, and ${Quest.DENIZEN}s lair is all but undefended. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} is finally ready to face the ${Quest.DENIZEN}.", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(NPCHandler.DP), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme


    }
}
