import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Mage extends SBURBClass {

    @override
    String sauceTitle = "Master";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 1.01;
    @override
    double companionWeight = 0.51;

    @override
    List<String> associatedScenes = <String>[
        "Mage I:___ N4IgdghgtgpiBcICyEDmMAEBJEAaEAZgDYQBuA9gE4AqMAHgC4IgA8ARgHwDKWAIgKIBFAKr8u1eCwD0nDNQAWmLgGF+AOX4B9APIB1DQCVNagIJJ+GAJYBnDPQAOMSpdhgGlsKgwB3Sw3kY-jCWlBgQ1o4AxgxhtvYQlDHkBGEY1pYAJjAAjgCuMNYMAHRyigCeGEQwMUEhaTBg1gUYqLmZmEFQuJUwCWAeXhBERGlUDLbJGADWYOTeVRnogeUYYDCkTtNr3hhsMARUMN25bpYjQRW5RO5QEAwwRBUJzhthMd7yd+ub9uQeDFVrLYCBBostMHkCjFUJYNqFvBA3DAMoFyFs5iUFEpVBodPp+EZTOYfEMprYIAiKgRKOQoOC0u1IYUMAQYA8BqkiH4AZgoId0fNkegIGwqkUADpgdiUDjSjh4EAMBLoBjaNbMBiUfIKzWWVDoSjKchgDJ+SzG6wAGVhA2YAG1gOKQC5folEQxdFQMk74E61FITE7cH7tNQfU6QUQmkGnQA1AxYLgAaUDCAjQ2jeCdkFg4ZAWGsXAeBBjzqgrqVbiwbjzAAYnQBfbqOssV92eyjetMgf2p4M90N5yOZ-vxxMpocZmClnPT7sFkxcjall1jd3Vhh1xvNp2rt1uDtd309gOltSD7ua-KlsfJ1PH4dz-uzvMFgDi5Ay1EsThX5bXVY1t29YgE2GAtnulYel6eYAApELkkRTHI5BTA08CaJhGBqAALFgqCLPIqAMKg9iWAAQpEWAmCmbAmJQqAAJreGojEmNR2QmAAnEQABWb7KCYvCCKg5FQEm-AmGwqCCPwACsOHeCYMAmJaMLaFwb50CY3jaMxABMynUORdD8EQyjKKgvDaJEyhQN4jHkZaBxYI58gmFAJgeX45DWAAzFwZjkAw2RJt4AC01CoG+ACMqAmAAEgYyhJuQJjkbWEAABzeHR2jZEgDAZAA1AljllCYsGCCYqBgAAWlM4XWAAUjhsGQFwSC8co8iLORnH8GlUxWSmahYPIyhqAAYlw1ikAlqC1gl8lYMoYBcBA1AmOQRAmMI2gAF6oGUuRsMoCHCIFQllSYpBQIIOEMKQdXaJa8jkScqAHTAzWMQldWMVw5HFWItZ0MVMBcM12R1fVpBEAYcl0C9gjWMoMVEFwjFqBA5FTSYMXhQQui8LxkS1kQADsgUZKplC2dY2TZG+IUAGzFVA5FvsVMV1X5U28MowhELwJjY7xgXkZY-FIPYYBIAAGvpOGkH5xWoM15GMbB+m1pY8gJVdZ4XseV5PnGCZ3pOUbm+A0BzseCXhFwkQNLbkHrkBx4gWBEH-vu0GdnmvbG2G3aPjelsTuHU4zvbr7WAYiIZLSf5toBm7dn5fmNgAujqzj6k4RommaFqWsn9r5-g+ystE1hTVQ1qkLaiAOru-tQYeeZIOQbBnH4ZRx7m3Y9Yi6BIGUXBKpno5R-e6Y22nAEMGouRQHslB5uFMU56BO6tiv3fdht-QMEPWZ2yPx5j54MCT9PdyR+OC+ELHl8e24a8b7+3a79u4EO7p0DkeJ08FELIWoKhdCmFNDYTwgRVARESJkUotRWi9EmIsTYhxbifEBJCREmJCSUkZLyUUspVS6lNLaV0gZIyJkzIWSsjZOyDknIuTch5LyUAfL+UCr3EKYVIrRTiolZKqV0qZRynlAqRVSrlUqtVWqDUmqtXahATq3VeqiQGkNEaJgxoTWmrNeai1lpyVWutTa21dr7SOidM6F0rq8BundB6T0XpvQ+p4b6v1-qA2BqDcGkNoawzqvDRGyNtCo3RpjbGuN8aE2JqTcmVMaZ0wZkzFm2R2ac25rzfmgthai3FpLaWb5ZbyyVirNWGstY6z1gbI2l8XzdjfLCFS0RzRgGflbS8Wp3ad3dN-TeW5QLVxALXGA9dG6UAriaawVdQJAA",
        "Mage II:___ N4IgdghgtgpiBcICyEDmMAEBJLIA0IAZgDYQBuA9gE4AqMAHgC4IgA8ARgHwDKWAIgFEAigFUB3GvFYB6LhhoALTNwDCAgHICA+gHkA6poBKW9QEEkAjAFcAzjBsYIxYhkZKMAazAUA7sRgAJuiuSgCeAORkmBTsjBAAlmCBrhQYAMYUUAAO-oyYMFFUoRg2iaj+GFlWAF7VFaUBMACOVvaMlRQ2pez+AHQY3FZUMHgY3j4hMPFUGMM+EFQBDlDxqArt7JiwEGBl-l2j7FbtbspqmroGAsZmFhjxNmDh7agUZSkYuY7OGBSEk9NPON-EFMK8PvMbHl+gAhYpeXzvU6AiA2LIwNKMUanAbnbT6IwmcyWRhUKzEYpWMCNKhQnZLDA+BQQdrxdrbMAORipTaODAodC9AA6YA4VE4Ys4+BAcSo6EYOiSLFJrWlpNW6CoKgo1LZ8R1NgAMvEyGUWABtYBCkDxbLUOJgRh6agBa3wa3qaSma14D06Ghu62EJx2H3WgBqhiw3AA0t6EEGQzAw+BoMmEyAsDZuDBiIQU7asvadowsI7AyAAAzWgC+oytNrtVAdTpdFc98d9IHU-orweIofwEajsfj7qISZTkFgFazpmIJvTXcLxcdZcYFerIDrGAbK+bJedi3bXpTPYDGf7g67kejcb7k6HqZnGazAHEKAEaPEYFQC02W3XTda3ra19xbI9XQzAAFYgrDSDx5AoDwYDAeAtAwjB1AAFiwVAggUVBGFQLJ4hhNIsFMON2FMOUAE0fHUOjTEoppTAATmIAArN8VFMPghFQGEoBjARTHYVAhAEABWbCfFMGBTENVB4h0bg33oUwfB0BiACYFJoGF6AEYgVBUVA+B0NIVCgHw6JhQ1CAoLB7IUUwoFMdy2U6ABmbhzAoRgmhjHwAFoaFQN8AEZUFMAAJQwVBjChTBhSsIAADh8GidCaJBGACABqOL7NCUxoKEUxUDAAAtDxQpsAApbDoMgbgkC4lQFCCGE2IEFKPAsuN1CwBQVHUAAxbgbDIOLUErOKZKwFQwG4CAaFMChiFMEQdGqVBQisdgVDgkR-P4krTDIKAhGwxgyBqnRDQUGEqVQaoYEaui4pqujuBhQrxErehCpgbhGqaGrarIYhDGk+hHqEGwVCi4huDo9QIBhCbTCi0LCD0PguLSStiAAdn8gIlKoaybCaJo3yCgA2QqoBhN9CqimqfImvgVBEYg+FMDGuP8mF4h4pAsjAJAAA1dOwsgfMK1BGphOjoN0yt4gUOLzrPXsMxVJdhzvMdEwHE3n3Tcc4tRbg0lQq3wJLICMy3Hc9wAw82wzDsDYvccryt29RwfS2pzTWcbEMelMn-IsDzXcsMyZpnawAXTVKgNV-bVdUYfVOUNekLSzggYEIQgMUYGwJuoY1TTAVALS9xOIN98ckBieIF0YUJI5fccup2dAkFCbg4g3J9Q-vS9H2Xb3HXUKwoE2P8M1CqKfI90DG3bn3jwzNbdn7webetEfm5gcfJ5ZFNZ-NicI6fF3l9X9eK233fdzApfWyPuOWC8FEI0GQqhdCmEcJ4QIkREiZEKJUXErRVADEmIsVMGxTiPE+ICSEiJMSEkpKyXkopZSql1KaW0npAyRkTJmQslZGydkHJORcjCNyHkvLchsH5AKQUQrhUijFeKiVkqpXSllHKeUCrFVKuVSq1U6oNWaq1CA7VOrdSEn1AaQ1TAjTGpNaas15qLWkstVa61NrbV2vtQ6x1TrnT4Jda6t17qPWeq9ZuH0vo-T+gDIGIMwYQyhjVGGcMEY6CRijNGGMsY4zxgTImJNyaU2prTemjMmgszZhzLmPM+YCyFiLMWEs3xSxlvLRWytVbq01trXW+snzTgviAN8i5TCYiLg-Ecc9xzGwTquRgK816-mAtucuIBK7V0xHXBu9IbBl23EAA"
];
    
    @override
    List<String> levels = ["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
    @override
    List<String> quests = ["performing increasingly complex alchemy for demanding, moody consorts", "learning to silence their Mage Senses long enough to not go insane", "learning to just let go and let things happen"];
    @override
    List<String> postDenizenQuests = ["finding yet another series of convoluted puzzles, buried deep in their land. These puzzles pour poison into the land, and will continue to do so until solved", "realizing the voices are gone. Not just quiet, but gone. Without them, they can finally get down to work on their land puzzles", "solving the more of the puzzles of their land. Not that that's the end of the horseshit, but hey! Less horseshit always helps", "getting sick to death of puzzles and just utterly annihilating one with their game powers"];
    @override
    List<String> handles = ["magnificent", "managerial", "major", "majestic", "mannerly", "malignant", "morbid"];

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

    Mage() : super("Mage", 2, true);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.4, false)
    ]);

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
            ..add(new Item("Alternate Costume",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.MAGICAL, ItemTraitFactory.LEGENDARY, ItemTraitFactory.OBSCURING],abDesc:"Apparently some people don't like the regular mage outfit? Whatever."))
            ..add(new Item("Mage's Cape",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.MAGICAL],shogunDesc: "Shitty Wizard Cape",abDesc:"Mage Shit"))
            ..add(new Item("Mage's Staff",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BLUNT, ItemTraitFactory.MAGICAL, ItemTraitFactory.STICK],shogunDesc: "Shitty Wizard Stick of Power",abDesc:"Mage Shit"))
            ..add(new Item("Walking Broom",<ItemTrait>[ItemTraitFactory.BROOM,ItemTraitFactory.WOOD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SENTIENT,ItemTraitFactory.MAGICAL, ItemTraitFactory.STICK],shogunDesc: "Support Stick of Cleaning",abDesc:"Normally I'd blame Wastes, but walking brooms is more of a Mage thing."));
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
        return 1.5;
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Cities","Skyscrapers", "Buildings", "Stoplights","Cars","Streetlights","Traffic"])
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.LOW)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has freed the frogs from their video game inspired hell. No longer will they be threatened to be squashed by all this fucking traffic. They are hopping ALL over the road now. The ${Quest.PLAYER1} thinks hard and figures out the best way to start collecting frogs. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Work With Exiles", [
                new Quest("The ${Quest.PLAYER1} hears a strange voice in their head. Huh, it seems like a carapace years in the future (but not many) needs their help making sure things happen how they already happened which. Fuck. More Time shit. The ${Quest.PLAYER1} abjures the concept of helping entirely, but the Voice just won't shut up. God dammit, FINE. They'll help."),
                new Quest("The ${Quest.PLAYER1} makes sure to exile a random ass carapace. They have no clue why, but the voice insisted. Alright, then."),
                new Quest("The ${Quest.PLAYER1} chucks a few random ass objects into a Lotus Time Capsule. Okay. They are FINALLY done running around and doing inscrutable errands for a voice in their head. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

        ..addFeature(new PostDenizenQuestChain("Suffer Visions", [
                new Quest("The ${Quest.PLAYER1} is feeling quite pleased with their victory over the ${Quest.DENIZEN} when suddenly they are nearly blinded by a crippling vision of pain and ${Quest.MCGUFFIN}. Oh god, why is this happening?"),
                new Quest("It's been a while since the last ${Quest.MCGUFFIN} vision, and the ${Quest.PLAYER1} doesn't trust it. As a test, they actively look out for ${Quest.MCGUFFIN} related danger.  Sure enough, right before they find it they suffer the painful vision. Their course of action is clear: prevent ${Quest.MCGUFFIN} from ever hurting anyone ever again or suffer migraines from hell forever."),
                new Quest("Finally, the land is practically a ${Quest.MCGUFFIN} free utopia. The ${Quest.PLAYER1} can finally have a break from painful visions.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Become the Mayor", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the ${Quest.CONSORT}s are ready to expand their civilization. They ask the ${Quest.PLAYER1}'s help in planning the brand new city of ${Quest.MCGUFFIN}burg."),
                new Quest("A panicking ${Quest.CONSORT} runs up to the ${Quest.PLAYER1}, ${Quest.CONSORTSOUND}ing the whole time. The ${Quest.MCGUFFIN}burg sanitation facility has been delayed, but the residential areas are already starting to fill up!  The ${Quest.PLAYER1} shuffles around work shifts to get the sanitation working before things get too...disgusting."),
                new Quest("It is finally time for the final brick to be placed for the final building in ${Quest.MCGUFFIN}burg. The ${Quest.PLAYER1} snips a ceremonial ribbon opening up the Mayor's office, to which they have been elected in a landslide. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);


    }

}
