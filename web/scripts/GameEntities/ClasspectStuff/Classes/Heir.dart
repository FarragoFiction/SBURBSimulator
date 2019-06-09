import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Heir extends SBURBClass {

    @override
    String sauceTitle = "Stalker";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 1.01;

    @override
    List<String> associatedScenes = <String>[
        "Heir I:___ N4IgdghgtgpiBcIASMCWAnABASRAGhADMAbCANwHt0AVGADwBcEQAeAIwD4BlbAEQFEAigFV+XavBYB6TpmoALGJi4BhfgDl+AfQDyAdU0AlLeoCCAWX6ZUAZ0wUwmCJhuoAJjACOAVxg2GmAzyEAEADt4MdkEwUJjeoU4A5hCoYP5OLjAxqYnEAJ7WUKEUNq5sxEoAxsHEFWCJMAB0corKapq6BvzGZpbWdoquDBBgDHiYbBGBigUQ6Eo23m4eYPkTfgwUAO4wbhMF0RhONqEwlQFbqEHTShBsqMRXBxSYUBAA1kpbwQEOlQtZWB7VBFEplCqYSoUWCBdC+ZoKJSqDTafRGEwWfgAcjs8y2cz2hComDcFBy01s-VeqRBEGI40mAWi1jAinQVxG-3shBuRwgJzODBxmGKOywlMIc0wiXmIRg6EaAB0wOx0BxVRx8CBhugGgwdGA4IgGHC4AQTahEg10CoHG4rqgHDYADKoMg5ZgAbWAipAIOK6GGoz0VDcvvgvvUUlMvrwkZ01HDvslxBsMFjvoAaoZsFwANIxhDJulpjPgaDposgbA2LgwYiEMv+qhBhjYUZJkAABl9AF9xj6-aDAyMGCH0GGq1HC3GQOoE52U6X8Fmc-nCxGiCXK7PILBOzXTI8yDvfc2R6N2wxOz2QP3MIPz63x5PN9Oy-PE1WTb4y9ncwWi7bmWe6VpuNYAOIUG41CoPKTbDq2V43n2A5noho4vp2AAKxDeJU7xyBQnxgPAWjkZg6gACzYIkbiJPIiQMIkoSoAAQpU2CmAWbCmLqACaWzqPxphcZ4pgAJzEAAVhBKimLwgiJGxUB5vwphsIkgj8AArFRWymDApjOokqA6FwEF0KYWw6IJABMhnUGxdD8MQKgqIkvA6JUKhQFs-Fsc6RLYAF8imFApjhVcJQAMxcBYFAMJ4eZbAAtNQiQQQAjIkphIIYKh5hQphsV2EAABxbLxOieOYDBuAA1EgAV5KY2GCKYiRgAAWu8qU2AAUlR2GQFw5jSSo8j0Wx4n8MV7yeQW6jYPIKjqAAYlwNhkEgiRdkgunYCoYBcBA1CmBQxCmMIOgAF6JHk3hsCoeHCPFCnNaYZBQIIVEMGQ3U6M68hsd49S3TAA38Ug3X8VwbENWIXZ0A1MBcANnjdT1ZDEIYOl0IDgg2CoWXEFw-HqBAbHraYWWpYQei8NJlRdsQADs8VuMZ6A+TYnieBBSUAGwNVAbEQQ1WXdTF628CowjELwpgU9J8VsagsnmKEYDmAAGnZVFkDFDWJANbH8dhdldqg8hIO9H4Lt+pp-mugFVkup7lvuVZIPyXD-IaCEBkhHZVre96Phhwahp274rnOjubh7LsARuxapp7oEHjYhgjKSUBBy2o7IVWMUxX2AC6WoWla8q2mA9oMI6aTOnnXpVwQMCEIQgo2OtVCuu69RepHweYTHVbmBQ9yPAweQgRWnaTSMDTmHkXDDNe8f-uuQEZ4XF4MOo3hQGw8FVqlWXl3eaFDmP0cTp25gQHQIIn5gzr4e8C-e5uy-1DANeG8Qgp13u7YC8cnyjmPqfc+m4r6oQfOhe+Y4J6blwl-IiJEyIUWorReijFmKsQ4lxHifFEiCWEqJUw4kpKyXkopZSql1KaW0npAyRkTJmQslZGy9lHLOVcu5Ty3lfL+UCsFUK4VIpQGijYOKCUkopXSplHKeUCpFRKmVSq1Var1Sai1NqHUuq9X6kNEaEAxoTSmspWa81FqmGWqtDaW0dp7QOjpI6J0zoXSujde6j1nqvXerwT631fr-UBsDUG4NIbQ1hvDRGXBkao3RpjbGuN8aE2JqTcmlNqa03pozZmrMOamC5s6HmKg+YC2FqLcWktpay3lorZW6hVYlQ1hBLWOt9aG2Nqbc2ltra23tvHLOVYIJuiMucZuoC3abh-J7KBowYFn3QChO8HcQBdx7ucPuA8842HbneIAA",
        "Heir II:___ N4IgdghgtgpiBcIASMCWAnABASWyANCAGYA2EAbgPboAqMAHgC4IgA8ARgHwDK2AIgFEAigFUB3GvFYB6LphoALGJm4BhAQDkBAfQDyAdS0AlbRoCCAWQGYArgGcYdzIyUZM0CAC9UYAObu7AAcYAGNGTEDKAHcYdCdGSkwQyihAkhhGZQdyWIgSTDtUABMYAEcbR0Z4hQhGfHcQ5PQin38E51cscsrMX1QcuPqY9GU8qIgATydYCDBwomoO5TVNHQNjU0trduTU9MyAiIh0cMoidwj0SkClEInMM4KU5QBrHyKAOkx9VBdMGAgIQUBWKZQqdnCuzSGRg9Rcy3UWj0hgEJnMViSNT8jncYCKmHYoWeThCJEoDiw7XhbggQVC4Rcs3+AwJMAWIzh6BsJHuaUmrSWRxOD3O8MwKAwHwAOmAOOhOHLOAQQIxjr4MrowHBEIwuXBCLrUL51ehVJQ8b9UOa7AAZfqtFgAbWAUpAqFS1FVc301CKrvgro00jMrvwgd0NH9rqIeQcoddADUjNhuABpEMIaOxmDx8DQHOZkDYOzcGAkIi592RE6zRjYOZRkAABldAF96i63R6a97fY2gxmwyANBHGzGSHGCInk2mMwHiNnc5BYI3i2YSP0C0Oq57a-XGI2WyB25hOzue4wfc1+8HcyPI4Xx5Oh0mU+mx4up3mV4XiwBxSgihoVBYkrbsvTrBtCyPE8z3A2srz9QsAAUSBsEIXnkSgXhgMB4G0AjMA0AAWbBfCKXwFF8RhfECVAACEQmwMx03YMx0F8ABNKINE4sxmNKMwAE4SAAKz-VQzD4IRfHoqBUwEMx2F8IQBAAVmIqIzBgMwbT6XRuD-egzCiXRuIAJm0mh6PoAQSFUVRfD4XQQlUKAok4+ibQWbBPIUMwoDMALfnJABmbhLEoRhSlTKIAFoaF8P8AEZfDMJAjFUVNKDMeimwgAAOKI2N0UoLEYIoAGokE8iYzGQoQzF8MAAC0XjiuwACliOQyBuAsUTVAUCj6MEgQcpeJz0w0bAFFUDQADFuDscgkF8JskHU7BVDAbgIBoMxKBIMwRF0TxfAmGx2FUNCRAiqSarMcgoCEYjGHIFrdBtBR6JsPxPBgTrOKQFrOO4ejKvEJt6EqmBuE60oWta8gSCMNT6E+oQ7FUZKSG4TiNAgeiFrMZK4qIfQ+FEkImxIAB2CKil09BXLsUpSj-aKADZKqgei-0q5KWtCha+FUEQSD4MwCdEiL6NQcSLECMALAADXM4jyFCyrfE6+jOOQ8ym1QBQkHuu9R0LXUKlzV9Zw-Cct1dZcC3nJBaW4EJcKdrtqwg-dDzbDtXXPCDEJvQdwwfecnx9u330fT8hxd1c7CMWYihSMC-b3KD5y5rm2wAXWVQ1jViM0LUYK0wFtDOnRLwg2SIek7AW6g7XIB1EGdEP4N7a9CwsSh2FQDdGAmJd80bIbZnVCwJm4VUDy-eO5yzR3s93OYNBsKBCXQRs4uS0KYOD33t8vPsh4geh3T3zAbXQl4p5-edZ+xBel9qW2ZwTmOk59xzjvPeB9GwnzPqeIBl9w4oTQhhLCOE8IEW0ERUi5FKLUVogxJiLElLsS4jxPiAlhJiQklJGSckFJKRUupTS2ldL6UMsZUyFkrI2Tsg5JyLk3IeS8j5PyAUgpQBCnYcKkVoqxQSklVK6VMrZVyvlIqJUyoVWqrVeqjVmptQ6t1XqEB+qDWGrJMaE0ppmBmnNRay1VrrU2mpbau19qHWOqdc6l1rq3XunwR6z1XrvU+t9X6-1AbA1BuDSG3Boaw3hojZGqN0aY2xrjfGhNiak3JpTamtMGZmCZjaFmqg2Yc25rzfmgthai3FpLaWGhZa5QVn+JWKt1aa21rrfWhtjam3Nl+FOhY-ybjMGEGuv83zrxVHqLeF5d771AtBYuypm6t3bugG0Gc7AN2PEAA"
];
    
    @override
    List<String> bureaucraticBullshit = <String>["needs to file some paperwork to claim a small inheritance.","needs to pay off some debts with a property they inherited."];


    @override
    double difficulty = 0.3;

    @override
    List<String> levels = ["SKAIA'S TOP IDOL", "POPSTAR BOPPER", "SONGSCUFFER"];
    @override
    List<String> quests = ["retrieving a sword from a stone", "completing increasingly unlikely challenges through serendepitious coincidences", "inheriting and running a successful, yet complex company"];
    @override
    List<String> postDenizenQuests = ["recruiting denizen villages, spreading a modest nation under their (Democratic!) control", "assuming control of yet more denizen villages. Turns out a mind bogglingly large number of consorts have the Heir named in their will", "chillaxing with their aspect and while talking to it as if it were a real person.", "wiping a dungeon off the map with their awe inspiring powers"];
    @override
    List<String> handles = ["home", "honorable", "humble", "hot", "horrific", "hardened", "havocs"];

    @override
    bool isProtective = false;
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

    Heir() : super("Heir", 8, true);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 1.5;
    }

    @override
    double getAttackerModifier() {
        return 0.5;
    }

    @override
    double getDefenderModifier() {
        return 2.0;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
        //mostly just shitty legal puns on inheritance.
            ..add(new Item("Family Ashes",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.ONFIRE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.DOOMED, ItemTraitFactory.GHOSTLY],shogunDesc: "Whats Left of Staff",abDesc:"Probably an inheritance or some shit."))
            ..add(new Item("Last Will and Testament",<ItemTrait>[ItemTraitFactory.LEGENDARY,ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.DOOMED, ItemTraitFactory.LEGAL],shogunDesc: "Legal Rights to SBURBSim",abDesc:"Probably an inheritance or some shit."))
            ..add(new Item("Grooming Guide",<ItemTrait>[ItemTraitFactory.BOOK, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSY],shogunDesc: "I Hope This Is About Animals",abDesc:"Probably an inheritance or some shit."))
            ..add(new Item("Powered Attorney",<ItemTrait>[ItemTraitFactory.COLOSSUS, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.AI, ItemTraitFactory.LEGAL],shogunDesc: "Phoenix Wright 2.0",abDesc:"Believe me, you don't want to be sued by a RoboLawyer."))
            ..add(new Item("Executer's Ax",<ItemTrait>[ItemTraitFactory.AXE, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.EDGED, ItemTraitFactory.LEGAL],shogunDesc: "Handheld Guillotine",abDesc:"Probably an inheritance or some shit."));
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
        addTheme(new Theme(<String>["Courts","Manors", "Halls", "Mansions","Legacy"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(new PostDenizenQuestChain("Inherit Responsibilities", [
                new Quest("With the death of the ${Quest.DENIZEN}, it now falls to the ${Quest.PLAYER1} player to take up all their old responsibilities. Wow, who knew a cranky giant snake did so much to keep things running? "),
                new Quest("After organizing taxes, approving budgets and listening to ${Quest.CONSORT} complaints for what felt like forever, the ${Quest.PLAYER1} is finally allowed a break. Wow, this posh as fuck mansion they get to use ALMOST makes up for all the bullshit work they have to do!"),
                new Quest("The ${Quest.PLAYER1} is FINALLY caught up with the backlog of bullshit caused by the death of the ${Quest.DENIZEN}. Now they just have to manage up keep and crisis management. They think they can handle it.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)


            ..addFeature(new PostDenizenFrogChain("Inherit the Frogs", [
                new Quest("The ${Quest.DENIZEN} has released the frogs into the ${Quest.PLAYER1}'s care. The land becomes a lot more frantic feeling with all that croaking. The ${Quest.PLAYER1} collects all sorts of frogs. Various ${Quest.CONSORT}s 'help' by ${Quest.CONSORTSOUND}ing up a storm. "),
                new Quest("The ${Quest.PLAYER1} begins combining frogs into ever cooler frogs. They begin to realize that an important feature is somehow missing from all frogs. Where could the frog with this trait be?  "),
                new Quest("The ${Quest.PLAYER1} has found the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ,  Theme.MEDIUM);
    }


}
