import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Page extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 1.01;

    @override
    List<String> associatedScenes = <String>[
        "Page I:___ N4IgdghgtgpiBcIAKEDmMAEBJEAaEAZgDYQBuA9gE4AqMAHgC4IgA8ARgHwDKWAIgKIBFAKr8u1eCwD0nDNQAWmLgGF+AOX4B9APIB1DQCVNagIIBZfhgCWAZwzkwGCBhtWAJjACOAVxg2GGAzyEAGUXt5WYXZBMACeGATkRETkAO6Bihg+fgGoVqQwlE6U5N5gbrgYAA6FiZRQVmCoGKhhIRgeMG52qfJWRJhsEURujc0xkS4wYDaY5ARTRAupVEEYZR5FMVm+-i35hQDkdlUlDDAAxgxWDgB0cophxxhg5AFQ3hfy9gvOYakQShuBJUDJKVQaHT6fhGUwWSpDAIEGAwIhODBEKwMBgDDBQKiYU5vS7nNy3AA6YHYlA41I4eBADEB6AY2jAcEQDEovgZXKsqHQlGUDlG1wcNgAMvkxswANrAckgKxQKqrCBgBi6KhuRXwRVqKQmRW4fXaai6xUECBEWbGxUANQMWC4AGkjQhLdbbXhFZBYBaQFgbFxUQQ7UqVWqNVgNQGAAyKgC+lQVEdVlCZGq1QIDBvdJpAajNAatNpg4cdzrdJa95Z94Ggdb1gZsJkxBXDyvTmYYMYY8aTKcVXajmu1ucN4aL5o9jO5dYLldd7ubpe9Bb9TcVQYA4uQ3NQrIVO5GM+re7HZwmQMmMKmR2es+PZ0giJ8ANZycjv6bwTT-jA1AAFiwVA3FQeRUAYVAqisAAhC4sBMN02BMShUAATVSNQMJMJDPBMABOIgACsd2UExeEEVA4KgF1+BMNhUEEfgAFYgNSEwYBMCU8m0LgdzoExUm0LCACYuOoOC6H4IhlGUVBeG0C5lCgVIMLgiVEiwDT5BMKATH0rFyBsABmLhzDeTwXVSABaahUB3ABGVATAACQMZQXXIEw4LjCAAA5UlQ7RPDMBg3AAajcjTYhMJBBBMVAwAALXfWybAAKSApBIC4MwSOUeRwLggj+B899FLdNQsHkZQ1AAMS4GxSDc1A4zctisGUMAuAgagTCSExhG0AAvVBYm8NhlDfYQLMomKTFIKBBCAhhSBS7QJXkOCylQUaYEyjC3JSjCuDgyKxDjOhIpgLhMs8FLUtIIgDFYuhNsEGxlCcoguAwtQIDghqTCc2yCF0XgSIuOMiAAdgstweMoFSbE8TwdwYTwADZIqgOCd0ipyUtMhreGUYQiF4EwAZIiy4KsMizCqMAzAADTEoDSFMyLUEyuCMKQMS4yseQ3Pmqdi1nLlfArJ1lxrMtw03AM3IgYMLmmBdh1PHs+wHG8hzTUdsx1Wc80lmdV1rOWqxXT0lfrFXZyDAx1TccgoBPbtz312dTNMpMAF1eUoflBWFcosRuGYJXduUQ-wGACGRK4bAaqgpVIGVEHlHWfafHNZzMRplW8KAMAlD9lcbAMivVdAzFiLgmX7esl2rWc12143HwYNRy7YY9Z1spzA8Nu985N59mwasJMF0foiBr-1Z3rpoYCbluQlthWu5t+sHx7AeoCHygAzHwdJ97ntTYDV8Py-H8wD-ADgNA8DIOg2CEKQlC0MwthXC+EiKkXIpRaitF6KMWYmxDiXEeJ8QEkJES4lJLSVkvJRSylVLqU0tpXS+lDINAYCZcylksY2Xso5Fy7lPLeV8v5IKIUwoRWirFeKiVkppQytlXKEB8qFWKjRMqFUqomBqnVRqzVWrtU6qxbqvV+qDSIMNMaE0pozW8HNQyvBFrLVWutTa21dpNAOkdE6Z0LpXRundB6T0UovTeh9bQX0fp-QBkDEGYMIZQxhvDRGyNUbo0xjjPGBMiYkzJhTKmNM1B018ozHczNWYcy5jzPmAshYizFhLJ2tdZw7gOCYK4Mdd6d2bDLHuR9zwnzPgbRMicQDJ1TgwdOmd3Y2ATjeIAA",
        "Page II:___ N4IgdghgtgpiBcIAKEDmMAEBJLIA0IAZgDYQBuA9gE4AqMAHgC4IgA8ARgHwDKWAIgFEAigFUB3GvFYB6LhhoALTNwDCAgHICA+gHkA6poBKW9QEEAsgIwBXAM4xbGRkoCWVDAAclYCrEjEMCFsPGABjRk8KAHcYKkdGCgxbCmIyTApnWNsAck8qCnZiGChbPECAEwgPRhcwVCclQOCwiISMQhcIiDAATyTO6wgaijBI21sXQpgAOnlG1Q1tfSMTCwFsxwhiYhcHQKpMGDT3Z26Aa0JrYlnFZTVNXQMBYzNLJyorvuswcqzGbvKGCiCiGGE6GFg3XiiXYmAgGBQ6GmAB0wBwqJx0Zx8CB-lR0IwdGA4IhGB84AQyS5UOgqCoRuVOi4RrYADIuMi1VAsADawGRIBcUA81H+YEYemo5QF8AF6mkpgFeDlOhoMoFhC29iVAoAaoYsNwANKKhAarUwHXgaCWs0gLC2bgwYiEK1CkVUMWMLDi9UgAAMAoAvmV+YLhaLuhKpX75ablSB1Kq-ZriNr8HqDcbTbKiBarZBYH6HaYdmk3RHPVGfYw-YGQCGMGH3ZHxZKqNK7XGrUm1XbU+mE-rDSaU-mM9ai3aHQBxCjlGi7KgVj1emt14OhgUtqttmN2pDEayhM7yChnGBgeBaG8YdQAFiwqHKqAUqEYqA8LgAQqEsKYTXYUx8QATSidQQNMf8AEdTAATmIAArGcVFMPghFQb8oCNARTHYVAhAEABWe8olMGBTFZVAXB0bgZ3oUwoh0MCACZyJob96AEYgVBUVA+B0UIVCgKIQO-VlCAoLAxIUUwoFMOTOgoWwAGZuAsDJoKNKIAFoaFQGcAEZUFMAAJQwVCNChTG-f0IAADiiICdGg8xGHKABqUyxJ6UwkCEUxUDAAAtM4dNsAApe8kEgbhzEQlQFBfb9YIEayzn4k11CwBQVHUAAxbhbDIUzUH9UziKwFQwG4CAaFMFJTBEHQAC9UB6ax2BUI8RHUtDvNMMgoCEe9GDIYKdFZBRv2+VAWpgCKQNM4KQO4b8PPEf16A8mBuAi6DgpCshiEMIj6AmoRbBUQziG4ED1Agb98tMQydMIPQ+EQ0J-WIAB2dTykoqghNsaDoJnRhoIANg8qBvxnDzDOClT8r4FQRGIPhTHuxD1O-FxkPMDwwHMAANFj7zIFSPNQCLvxApAWP9FwFFMvqe2TO0yWsW0hyzUd+3HBNC1tXNTKCbhQkvXnt0rNdfTtetG2bOWo3bTtc27CdezHNMZZAYds11wcBRF4tbEMAFfBXVtvQV3Moah4MAF0cSpGlYnpH4mRZVkAV5V2CBgQhCBaWx8uodlOTqXkVdXNX91zcxaiFawoAwVljzOAsbT9RLunQcwem4f5awnQ2BdzAd9Z3L11DT2FlztHTDJUpWt3DeO9w7P18oOTA9BcbYc6nXN87qGAi5LoYrQrnNzT1m3d0YeuoEbv1W-bptZa76Me4PI8TzPC8rxvLQ70fZ9X3fT8fz-AC8OA1AwIgqDTFghDkNQ9DMOw3D8MIiRMiFEqI0TogxJirF2KcW4rxfiglhKiXEpJaS35ZLyUUgkVS6lzCaW0npAyxkzIWSsjZOyjlnKuXcl5HyfkApBVCuFKKMUIBxQSklTCqV0qZVMNlXKBUiolTKhVIiVUap1QasQJqrV2qdW6tYXqCk+ADSGiNMaE0pozTqPNRay1VrrU2ttXa+1DrBWOqdc6OhLrXVuvdR6z1XrvU+t9P6AMgYgzBhDaGsN4aI2RqjdGmNsbqFxjZAmM4iYk3JpTamtN6aM2ZqzdmE4zZ2hnByCi4RmRgFnvzeeuJyRLzrg3WIG4GyBxAMHUO4Rw6RwBLYAODYgA"
];
    
    @override
    double difficulty = 0.0;
    Page() : super("Page", 1, true);
    @override
    List<String> levels = ["APPRENTICE ANKLEBITER", "JOURNEYING JUNIOR", "OUTFOXED BUCKAROO"];
    @override
    List<String> quests = ["going on various quests of self discovery and confidence building", "partnering with a local consort hero to do great deeds and slay evil foes", "learning to deal with disapointment after dungeon after dungeon proves to have all the enemies, and none of the treasure"];
    @override
    List<String> postDenizenQuests = ["learning to control their newfound prowess, accidentally wiping out a consort village or two", "getting all mopey about their new powers, because apparently actually being competent is too much for them", "finishing the legendary tests of valor with a never before seen aplomb", "accepting the role Sburb has placed upon them. They are themselves, and that is all that needs be said on the matter"];
    @override
    List<String> handles =  ["passionate","patient","peaceful","perfect","perceptive", "practical", "pathetic"];

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

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 2;
        } else {
            powerBoost = powerBoost * 0.5;
        }
        return powerBoost;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Shorts",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BESPOKE,ItemTraitFactory.LEGENDARY],shogunDesc: "Crotch Hugging Thigh Exposers. Absolutely Indecent.",abDesc:"Don't skip leg day."))
            ..add(new Item("Sidekick Figurine",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.COOLK1D],shogunDesc: "Small Statue of a White Headed Cat in a Green Suit",abDesc:"Robin is way cooler than Batman."))
            ..add(new Item("Steroids",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.MAGICAL],shogunDesc: "My Morning Medication",abDesc:"Shit son, calm down with all the screaming and the powering up."));
    }


    @override
    double powerBoostMultiplier = 2.0; //they don't have many quests, but once they get going they are hard to stop.

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Desert","Sand", "Pyramids", "Camels","Tombs"])
            ..addFeature(FeatureFactory.OVERHEATED, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SNAKECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LIZARDCONSORT, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Help Breed the Frogs", [
                new Quest("The ${Quest.DENIZEN} has allowed water to flow once more. The croaking of frogs fills the air as pools begin to form. The ${Quest.PLAYER1} asks the ${Quest.CONSORT}s to help them collect frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} shows them how to do it right, and soon everybody is helping out. "),
                new Quest("A ${Quest.CONSORT} child has tripped over the final frog. They cry and ${Quest.CONSORTSOUND} at their skinned knee, but their pain is quickly forgotten when the ${Quest.PLAYER1} praises them for finding the frog.  Together,     "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Become The Best", [
                new Quest("The ${Quest.PLAYER1} was about to walk through a patch of incongruous tall grass when a quirky ${Quest.CONSORT} named Professor ${Quest.CONSORTSOUND} halts them. apparently, it's not safe to travel without trusty ${Quest.PHYSICALMCGUFFIN} by their side. The professor also makes some side comments about the ${Quest.PHYSICALMCGUFFIN} League. If the ${Quest.PLAYER1} can assemble a team strong enough to beat the gym leaders, they might have a shot at becoming the ${Quest.PHYSICALMCGUFFIN} League Champion!"),
                new Quest("The ${Quest.PLAYER1} wanders about their land, learning how to use their ${Quest.PHYSICALMCGUFFIN} effectively and taking down the ${Quest.PHYSICALMCGUFFIN} gym leaders. Along the way, they hear rumors that the dastardly Team ${Quest.CONSORTSOUND}, led by ${Quest.DENIZEN}, plans to interfere with the league. The ${Quest.PLAYER1} will not stand for this."),
                new Quest("After an intense round of ${Quest.PHYSICALMCGUFFIN} battling, the ${Quest.PLAYER1} finally defeats the last gym leader of the ${Quest.PHYSICALMCGUFFIN} league. Turns out, the ${Quest.PHYSICALMCGUFFIN} they used was super effective! they can now challenge the ${Quest.PHYSICALMCGUFFIN} League. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has finally almost completed the ${Quest.PHYSICALMCGUFFIN} League. Much to their suprise, the Champion they must defeat in order to claim the title is none other than ${Quest.DENIZEN}!!! Will they succeed? STRIFE!","The ${Quest.PLAYER1} is now the ${Quest.PHYSICALMCGUFFIN} League champion. ${Quest.DENIZEN} remains alive just long enough to walk them to the hall of fame, which is suprisingly filled with grist!","The ${Quest.PLAYER1} whited out...")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Explore the Tombs", [
                new Quest("Now that the ${Quest.DENIZEN} is finally out of the way, some of the previously sealed tombs have opened up. It is time for the ${Quest.PLAYER1} to desecrate the fuck out of some tombs."),
                new Quest("In a twist that is shocking only to the ${Quest.PLAYER1}, they are now inflicted with a Mummy's Curse. There is a REASON you don't desecrate random tombs. A local ${Quest.CONSORT} explains that they will have to find a ${Quest.CONSORT} champion to face the Mummy, for anyone cursed by it will surely perish should they face it in a strife."),
                new Quest("The ${Quest.PLAYER1} finds a competent enough Warrior ${Quest.CONSORT} to help them fight the Mummy. While they can't fight directly, the ${Quest.PLAYER1} can at least give them some ${Quest.MCGUFFIN} buffs. With a deafening ${Quest.CONSORTSOUND}, the Warrior ${Quest.CONSORT} wins the day! The curse is lifted! ")
            ], new ConsortReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }
}
