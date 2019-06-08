import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Guide extends SBURBClass {

    @override
    String sauceTitle = "Highlord";


    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 1.01;

    @override
    List<String> associatedScenes = <String>[
        "Guide I:___ N4IgdghgtgpiBcIDiBXAlgExgAgJIgBoQAzAGwgDcB7AJwBUYAPAFwRAB4AjAPgGVcAIgFEAigFUhvOvHYB6HtjoALHLwDCQgHJCA+gHkA6toBKOzQEEAskOxoAztmYQ7AaxgZsAdzTMl2TjRoYADmQcGOSvbYdpgwAI4oMHbMAOQOCUnM2KEUMDT+EADGLthKVLAAdIoqAJ7ZVFmkVMkE0eUwZZ6tnCiNKMVopHW+qhra+kZCphbW2C5gVJ4OI7ZghWgADvYbKjQ4G3vMzHWeMKSkVWIbVGDYhyg0YGEROBnJ2Wi5+cxUL2j5ZVgrRW6i0ukMJjMVhsNyG2RgzAcEGwxBgnmwKCeUGuNCcYCydkKNAgGyRSLuaIgNAwVT0flO51aEEaMGcWRBY3Bk2m0LmCyW2GRqPRdjKuMKvSRNComI8K08tFIHn5FQAOmAuDRuJruIQQE4aMEEXowHBEMwaIk9Ra0MEjTQ1DcMD40Dc7AAZT5hNgAbWAqpAaGxtDxzAMtAwAfgAc0snMAYIMb0dCjAeIEFIdhgCYDADVjLheABpeMINMZrM58DQbNlkC4Oy8M7EKtBnGh3D41MgAAMAYAvq1-YHg7iIPjw9Tu7HS4mQJpk9305na3P84WS0uK6uA5BYN2G+ZSJ8dyP2+PmJ3mN2+yBB9hh22QxfJ5G6zOqwuU3WLYkq+vi1LaMSG3Ks91rYCGyQKgMDoNA8lbUcOy7Otb3vR8kJfCNuwABVIfoSjoKg3DAeAdHI7BNAAFlwYIMGCJRgmYYItgAIUKXBzBLThzENABNTxND48xOLicwAE5SAAKyQNRzAEERglYqAiyEcxOGCEQhAAViozxzBgcx3VCPReCQRhzE8PQBIAJgMuhWMYIRSDUNRggEPRCjUKBPD41j3WIKhcD8pRzCgcwwp8ZoAGZeCsBo4iLTwAFo6GCJAAEZgnMAAJYw1CLKhzFYnsIAADk8Hi9DiSxmAwABqHK-JqcwcJEcxgjAAAtFxkrsAApKicMgXhLCktQlHo1ixKEIqXHcktNFwJQ1E0AAxXg7AoHLgh7HKdNwNQwF4CA6HMKhSHMMQ9AAL2CGoUE4NR8LEOL5Ka8wKCgEQqOYCgur0d0lFYzFghumB+r4nKur43hWPqyQe0YeqYF4fq4i67qKFIYxtMYAGRDsNQMtIXg+M0CBWLW8wMuS4gDAEKTCh7UgAHY4owIyaC8uw4jiJBmDiAA2eqoFYpB6oyrrorWgQ1DEUgBHMcmpLi1i0BkywNjASwAA0bKoihovq4J+tYvicJsns0CUHK3s-Rcf0tU8AM3Otl0rQhdxrbscucXhChgU1EPPfErxvAchwDJ8xwnbD3zjB3v2Aj2XYLQCtxXMCfbrBtjHHDByhD58w5Q4DouigcAF1rUCO08kdMBnWYV0wA9AvfRrogYGIVFCkRNbaE9ChvUQP1o8wuOpzrSwgiDFAoGwd0COz-c6wm8cjUsGpeCca8vZAV2gPLLOD5j0NNAXzgELrZKMsru8o7PEuw3j4DLCoThBh8GpV4ggMN4hBgNvXezJ-zpzdinUCZ9J7MEvlAa+NBuz30jg+CeodX7T2AnhAiihiJBzIhRaitF6KMWYmxDiXF1K8WCAJISIlzBiUkjJOSCklIqTUhpLSul9KGWMmgUy5lLLWU8HZGADknIuTch5LyPk-IBSCiFMKEUoBRTsLFeKgskqpXSllXK+VCrFVKhVKqNU6qNWaq1dqnUep9UGsNCAo1xqTSUjNOaC1zBLRWutTa21dr7W0odY6p1zqXWundB6T0XpvQEB9L6P0-oAyBiDEI4NIbQ1hvDRGyNUbo0xl1bGuN8Z6EJsTUm5NKbU1pvTRmzM2Ycy5jzPmAthai3FpLaWst5aK2VpoVWxUNZIC1jrfWhtjam3Npba2tt7YH3At2JAJ5zD91buAjcx99TO2LrHOBV8b7ATQl3EAPc+4DyHgXOwnc7xAA",
        "Guide II:___ N4IgdghgtgpiBcIDiBXAlgExgAgJK5ABoQAzAGwgDcB7AJwBUYAPAFwRAB4AjAPgGVcAEQCiARQCqwvvXgcA9L2z0AFjj4BhYQDlhAfQDyAdR0AlXVoCCAWWHYUAZxj3sLVWlrYI9gA4wAxiwu1C4QANY4rmjO9pgwAI4oTiwA5M4A5miUMB4QYACeAO6qtBGqedgFuYEswWnBuRjYYDAwjTXYXDAAdNiGqmAuqtga2npGpubWtg5OgzDunj7+1cEstFQwZIRNwd4UfjhR2NQkJNhkaFBoLPY9FmRk1AVoYGnHrtnO7WsbZNgAtIMIIEjkVgdhrthYLkvsFOp5sKhYj0VGpNDoDMZhGZLDZsKEwE8vsojllaOUCpsyF0ADpgbi0HgMnhEEAsCC0NIwFj6ZrsNaJVlrNBpLm0dTUMAYa5oSX2AAymReaXYAG1gDSQJdvHR2WAWIY6BhNfBNVo5BZNYQzfp6CbNSQIGRHFbNQA1Ey4PgAaUtCAdTpdRE1kFg9pAuHsfE2JFdWqgOtoepYuH14YADJqAL7bDXxxPJw20Y3+kDmv3Wsu28OO50wOMer2+muB+vB8DQNumiP2e6ZNuV7W6qqplgZ7O5zVDpNVIsl7vluNaaul2tByuNn1+7trgchzvhyNIagYehobJx6fJ0fjkA57B5q+zo3hgAKZBQflCSmo4TA8F0QDsC0AAWXA0gwNJlDSFg0m8NAACE-FwCxfS4CxOQATQKLRMIsFC4gsABOMgACskHUCxBFENIEKgb1hAsLg0lEYQAFYQIKCwYAseUMn0PgkCYCwCn0bCACZuPoBCmGEMh1HUNJBH0Px1CgApMIQ+USGoXBNOUCwoAsQzrmoewAGY+GsagWDib0Cn+eg0iQABGNILAACRMdRvWoCwEPTCAAA4CnQ-Q4isFgMAAag8zS8gsV9RAsNIwAALVCf57AAKRA19ID4KxSPUZRIIQwjhD80IlN9LRcGUdQtAAMT4exKA8tJ0w89jcHUMA+AgegLGoMgLHEfQAC80jyFAuHUD9xCsqi4osSgoFEECWEoNL9HlZQEJQV4JpgbLMI8tLML4BDoqkdMmGimA+GyuI0vSygyBMNimB20R7HUFyyD4TCtAgBCmosFz-hIQxBFIvx0zIAB2KyMF42hVPsOI4iQWyADZoqgBCkGily0vMprBHUcQyEECxgdIqyELQcirG8MArAADXEkDKHM6K0myhDMNfcT0zQZQPKWpcV27AU9xATdm1XVs41DLtNQ8rw+AOZpLwTYd9RvUtMzvSd8wNg0X1LRd22XO1lbrBtPS3FtHfbNXD3sEwGmoKA9YLEc01LXHcezABdIVaBFMUJSlGU5XlBo1Qj4gYFOZZ7CauhFUoZU1UffWZ31OdwysF5LhQKBsHlT9QlVg9SxK3IuSsPI+HZMd20V7cAzdwdC+TLRK86Whw3+FzzJN+8C4D4ure7KxqC4NALhYPJ67DRvlGbmBW-b4EnabHvSBV9sn31IeoBH8MJ6ns3z8t4s3w-L8fz-ACgNA8DIOg2D4KQlCaEMJpGwrhfCFhCIkXIpRaitF6KMWYqxDiXEeJ8TQAJISIkxIFEkjAaSsl5KKWUqpdSmltK6X0oZYyVwagWSsovWy9lHLOTcp5byvl-KBRCmFCKUVYrxUSslVKGUsq5XyhAQqxVSq0QqlVGqFg6oNWaq1dqnVupsV6v1Qaw1RrjSmjNOaC0lqCBWmtDaW0dp7QOkdE6Z0LpXRunwO6D0novTeh9L6P0-oAyBiDMGEMoYwzhgjZGFhUbynRuoTG2M8YEyJiTMmFMqY0zploBm-lmZIFZuzLmPM+YCyFiLMWEspbuwbt2JA-YLABFlGAQ+LtSxy39hbS+19jbh1ZGnEgGcs60ETlKewyc7xAA"
];
    
    List<String> handles = <String>["guiding", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];
//i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
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
    Guide() : super("Guide", 16, false);

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
            ..add(new Item("Sherpa Parka",<ItemTrait>[ItemTraitFactory.COLD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.FUR],abDesc:"Clearly the best class uses this."))
            ..add(new Item("Guide Book",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.COLD,ItemTraitFactory.BOOK, ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SMART],shogunDesc: "Dummies Guide to Shitposting",abDesc:"Clearly the best class uses this."))
            ..add(new Item("Whistle",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.LOUD],shogunDesc: "Loud screeching pipe",abDesc:"Clearly the best class uses this.")) //keep together people we have a lot of attractions to visit
            ..add(new Item("Announcement System",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.ZAP, ItemTraitFactory.SMART],shogunDesc: "Voice Empowering Speaking System",abDesc:"Clearly the best class uses this."));
    }


    //guides show others their aspect and protect them from it (and it from them)
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Mountains","Vistas", "Rocks", "Sherpas","Guides"])
            ..addFeature(FeatureFactory.WOLFCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Find the Home", [
                new Quest("Now that the ${Quest.DENIZEN} is out of the way, a group of ${Quest.CONSORT} want to return to their ancestral home. Unfortunately, it has been so long that no one remembers exactly where it is.   The ${Quest.PLAYER1} volunteers to guide everyone based on half remembered legends and a few recovered parts of maps. "),
                new Quest("A ${Quest.CONSORT} child nearly falls off a cliff, but the ${Quest.PLAYER1}'s manages to grab them in time. Who knew mountains could be so dangerous? "),
                new Quest("After an exhausting journey, the ${Quest.PLAYER1} has lead the ${Quest.CONSORT}s back to a ruin that is almost certainly their ancestral home. Everyone is too tired to even ${Quest.CONSORTSOUND}, but they are happy.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

        //space player near guaranteed to do this.
            ..addFeature(new PostDenizenFrogChain("Find the Frogs", [
                new Quest("The ${Quest.DENIZEN} has released the frogs from their icy prisons. The land melts and warms and just generally becomes a lot nicer. The ${Quest.PLAYER1} is given a map to where all the frogs are and is told to get going. "),
                new Quest("The ${Quest.PLAYER1} is following a detailed guide on which frogs to combine with which other frogs. It's a little boring, but at least the ${Quest.PLAYER1} knows they won't make a mistake."),
                new Quest("Following the last step in the guide booke, the ${Quest.PLAYER1} finds the Final Frog. Luckily, a ${Quest.CONSORT} ${Quest.CONSORTSOUND}s in time to stop them.    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)
            ,  Theme.MEDIUM);
    }

}
