import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Rogue extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.51;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "Rogue I:___ N4IgdghgtgpiBcIBKB7A5gVxgAgJIgBoQAzAGwgDcUAnAFRgA8AXBEAHgCMA+AZVwBEAogEUAqoJ614bAPTdstABY4eAYUEA5QQH0A8gHUtSbRoCCAWUHYmEANYwAztgcpY2AA4oAlmCalHTgBWGGC21ooQTNheDmAA5FFMyl7UThBgACbYaF4UjtGJKM6uOJ402ACOWA5ROXnU2ADuikWN6UxOXkwAdNgAQhiJymDhOFWOtbkwDRkojvFRs9jpAJ5JPmhNXYoFvfoRUW1OSaXevtgoxOGRAPzYujuNMKSkBMtR-hA1o9hqmjoGIwmCxWNAwDrLbCkLp+HAccFMabvax2DZNA7RWIJUYpJzNGAjE7WLxuADGJWORRqMAgpGKsHWYE2JM81Bsvl6AB0wJxqFxeVxCCAbNQwUxdGA4IgmNQsEKZV40GDqKoUJkul41Q4ADK5DasADawE5IBZNHZTH0NAyJvgJo0MlMJoI9t0tFtJuItIcMGdJoAakhcDwANJOhCe72+wgmyCwD0gXAOHjPYh+01QVkW3C+BMABhNAF83saM1n2lbqDaIyAHeGXbW3QmvaQfenA8Gw82o+m49G7YmHKZoXl02a2e0c0x80WSybxxbK9WB3X0xomzWZVh20HQ+GBy22zHwNB+yakwBxFAZWheaZjzPmye5msFkDF7ClhcV60JgAKpAYKSYS0Cg9hgPA2hQdgGgACy4GgGRoIoaBMGg7heH0pK4KYYYcKYooAJqNBohGmDhFSmAAnKQgQXqopj8MIaB9FAIaCKYHBoMIggAKywY0pgwKY2o5LoPAXgwpiNLoxEAExCbQfQMIIpCqKoaD8LopKqFAjSEX02rECguAGYophQKYFldCgDgAMw8BYKBMBUIaNAAtLQaAXgAjGgpgABJIKoIYoKYfR5hAAAcjT4boFTmEwGQANQBQZKymH+wimGgYAAFq2O5DgAFKwX+kA8OYgSqIoSF9JRghhbYmlhhouCKKoGgAGI8A4FABWgeYBXxuCqGAPAQLQpgoKQpiiLoABeaArBgHCqIBoiOYxaWmBQUDCLBTAUHlujaooAxMgtMDFYRAV5YRPB9MlEh5gwyUwDwxUVHl+UUKQSC8QwJ3CA4qg+aQPCERoEB9F1pg+e5xD6PwgSknmpAAOyORkInUDpDgVBUF4uQAbMlUB9BeyU+XldldfwqiiKQ-CmFDgSOX0Xh0eY7hgOYAAacmwRQdnJWgxV9IRf5yXmXiKAFW1rhuA5btGDYdnu3atmrsangmAVfDwpIEjrZZPr4U4zu+c5mxOvhLgmq7Huu7o1oepsa12bs9sefYJkmSDpLMUAPuWFsvgOdl2UWAC68rUIqyqquqTCamAOpB4acdEDAxDEDApIdF1NC6hQ+qIEa86Pnblq-jWXXUDAOD6F4Ly9nrNY1ekYLmCsPA2NOx6e-ukba6H5tMBoGBQPC1AJu5PnR9bn5V2HtdVgm5goBwrddCs7fxp3ERMjAvf95EO6diPJA+w236+FPM-3jWi+zivtuLnXA4AUBIFgQSkFoJwQQkhFCaEMJYRwnhAiaBiKkXIqYSiNE6IMSYixNiHEuI8X4oJYSokvDiUktJWSjQFIwCUipNSGktI6T0gZIyJkzIWSslAGy9lHJbxcm5Ty3k-KBWCqFcKkUYpxQSklVK6VMrZVygVIqpVyoQEqtVWqLEGpNRaqYNqHVuq9X6oNYavFRrjUmtNWa80lorTWhtLa-Adp7QOkdE6Z0LpoCujdO6D0novTeh9L6P08p-QBkDXQIMwYQyhjDOGCMkYozRpjbGuN8aE2JhUMmFMqY0zpgzJmLM2Ycy5heHmfNBbC1FuLSW0tZby0Vr7DuA4LxTFMIXNOl9NabllKbe+k9p6zytoWbOIBc750Lg4Yu1BtRBwcFnd8QA",
        "Rogue II:___ N4IgdghgtgpiBcIBKB7A5gVxgAgJK5ABoQAzAGwgDcUAnAFRgA8AXBEAHgCMA+AZVwAiAUQCKAVSG868dgHoe2OgAscvAMJCAckID6AeQDq2pDs0BBALJDszCAGsYAZ2wRsAdxgQyzJdhQlsGicUDBoAYydsEhoUKBslFEccNwTsABMUMAByZmwwGBg0+Jg4iDAitIBLR2YaSs4MZhwfEpcoTLRivIK0gE8AOmwBFEqwTscUbBgwR1DInwhcmEoYGl7MnCUIZxTF4t7uwptJ2bCIwsHcXK8JqZm55wXclux1LV1DY1NLa1gYZkeKimjAADjAwrZmJVMoC9mFYslKj5sJwYKNOq5UJgYP0ADpgLg0biE7hEEC2Ghof56fJsWpYMm1SpoKk0NSZKpQmEAGUqlHRbAA2sBcSBKlAQbRbGBmAZaGlRfBRZpZGZRYRlXo6IrRSQbjB1aKAGpIXC8ADSaoQuv1hvA0AN1pAuEcvBgZBIdvFkpo0uYuBlOpAAAZRQBfQjYEViiVSsqy+VBlVWjUgTRaoN6shJO0ms2WzO2oiiyCwIMusxkPmO1PeuMygPMIOhkARqOiuu++NymgKp3Ju3p7VOrM54sgPMWq1K0hF1Olx0zl0AcRQaTolVWXtjXYbgadLbb0c7fp7fZnAAUyBgwnZFCgHGB4DoX9hNAAWXBoNJoJRoZhoCClQAEJhLgZiWpwZiUgAmm4mgwWY4EAI5mAAnGQABWy5qGYAgiGgwFQOaQhmJwaAiEIACs75uGYMBmNyaCVHovDLowZhuHocEAEz0XQwGMEIZBqGoaACHoYRqFAbgwcB3IkCguByUoZhQGYalIokADMvCWCgzDIeabgALR0Ggy4AIxoGYAASSBqOaKBmMBwYQAAHG4UF6MhFjMGkADUtlyb0ZgXiIZhoGAABadgmY4ABS74XpAvAWJhahKD+wGoUIzl2OJlqaLgShqJoABivCOJQtloMGtnUbgahgLwEB0GYKBkGYYh6AAXmgvQYJwajXmIel4cFZiUFAIjvswlDRXo3JKMBGBjL1MAJTBtnRTBvDAQFkjBowAUwLwCXIdFMWUGQSBUYwi0iI4aiWWQvAwZoEDAeVZiWSZJAGAImFhMGZAAOx6WkjHhGojjIchy6GQAbAFUDAcuAWWdF2nlQIahiGQAhmB9mF6cBlTYRYIJgBYAAaPHvpQ2kBWgCXATBF48cGlRKLZ42DhmTr0jWxqmlOhbZiL9plk6tnbLwET5NuPp+o2zbhpGx47qeib9qqAvDjOo5S5OBYjnOJYOuWjhIGUGRQMr9b+vuM5I0j4YALqMnULKrOy5RItCMzcnbQpe8QMAkCQ4IAuVtC8vyYxClrKvdrrM7lUEOAGJUZBkHaC5BplZRUhYvS8JCuZi2bRsWzGqcypoGBQKiNBBiZlnaYemsdtrae9kGFgoJwudIr0BdW06xdjDAZcV4sVf5tONqS47u7ME3Ldbk6nfd+29dO2eQZXjed50A+0zPq+H5fj+f4AUBoHgZB0FoHBCFIWYqEYdhuH4YRxFSLkUojROiDEmIsTYhxLivF+KCWEqJcSklpKyXkopZSwFVLqU0swHSekh6GWMmZCy1k7IOSci5NynlvK+X8kFEKYUIpRVivFJKKUIBpQyllQiuV8qFTMMVUqFUqo1Tqg1KiTUWptQ6l1Hq-VBrDVGuNAQk1pqzXmotZaq11qbW2rtfah1eDHVOudS611br3Ues9V671PrfV+v9QGwNQYQzMFDbkMM4YI2RqjdGmNsa43xoTYmmhSYuQpsuKmNN6aM2ZqzdmnNua835uOQuTplzVjMBCIOi9xZCxoFgNefpN6t3Vq2cOIBI7RwhI4OONAQ7lEcGHVsQA"
];
    
    @override
    List<String> bureaucraticBullshit = <String>["has to pay off a fine for 'loitering'.","is fined for 'looking disreputable'.","got caught smuggling banned goods."];

    Rogue() : super("Rogue", 4, true);
    @override
    List<String> levels = ["KNEEHIGH ROBINHOOD", "DASHING DARTABOUT", "COMMUNIST COMMANDER"];
    @override
    List<String> quests = ["robbing various tombs and imp settlements to give to impoverished consorts", "stealing a priceless artifact in order to fund consort orphanages", "planning an elaborate heist to steal priceless grist from a boss ogre in order to alchemize shoes for orphans"];
    @override
    List<String> postDenizenQuests = ["scouring the land for targets, and then freaking out when they realize there's no bad guys left to steal from", "stealing from enemies on other players planets, acquiring enough boonbucks to lift every consort on the planet out of poverty", "doing a little dance on their pile soon-to-be distributed wealth", "literally stealing another player's planet. They put it back, but still. A planet. Wow", "loaning money to needy consorts, then surprising them by waiving every last cent of debt they owe"];
    @override
    List<String> handles = ["rouge", "radical", "retrobate", "roguish", "retroactive", "robins", "red"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = true;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be taking ${rand.pickFrom(me.aspect.symbolicMcguffins)} from the ${target.htmlTitle()} and distributing it to everyone. ";
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Domino Mask",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BESPOKE],shogunDesc: "This Scares Me On A Primal Level",abDesc:"Not satisfied with the god tier shit I guess."))
            ..add(new Item("Archery Set",<ItemTrait>[ItemTraitFactory.BOW, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BESPOKE, ItemTraitFactory.ARROW],shogunDesc: "This Is Number 69 On The List I Dont Need To Make An Equius Joke",abDesc:"Like robin hood and shit."))
            ..add(new Item("Gristtorrent Server",<ItemTrait>[ItemTraitFactory.LEGENDARY,ItemTraitFactory.PLASTIC,ItemTraitFactory.ZAP, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SMART, ItemTraitFactory.OBSCURING],shogunDesc: "Shogun Coin Printer. Illegal Item.",abDesc:"Steal from the rich, give to the poor."));
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 0.5;
    }

    @override
    double getAttackerModifier() {
        return 1.25;
    }

    @override
    double getDefenderModifier() {
        return 1.25;
    }

    @override
    double getMurderousModifier() {
        return 1.0;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        //modify others.
        powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        target.modifyAssociatedStat((-1 * powerBoost), stat);
        for (num i = 0; i < p.session.players.length; i++) {
            p.session.players[i].modifyAssociatedStat(powerBoost / p.session.players.length, stat);
        }
    }


    @override
    void initializeThemes() {

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion","Rogues"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Steal the Frogs", [
                new Quest("The ${Quest.DENIZEN} cannot release the frogs since the corrupt Noble ${Quest.CONSORT}s have hoarded them. The ${Quest.PLAYER1} organizes various common ${Quest.CONSORT}s to help raid the frog stockpiles. "),
                new Quest("The ${Quest.PLAYER1} performs frog breeding as fast as the ${Quest.CONSORT}s can deliver stolen frogs to them.  "),
                new Quest("The ${Quest.PLAYER1} has finally stolen the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Lead a Rebellion", [
                new Quest("The ${Quest.PLAYER1} learns of the extreme injustices of the ${Quest.CONSORT}s who rose to power during the tyranny of ${Quest.DENIZEN}. This cannot stand!"),
                new Quest("The ${Quest.PLAYER1} forms a small band of merry ${Quest.CONSORT}s to run raids on the ${Quest.CONSORT}s in power.  All proceeds are given to hungry ${Quest.CONSORT}s in need. "),
                new Quest("The ${Quest.CONSORT}s who profiteered on the tyranny of the ${Quest.DENIZEN} have finally been brought to justice. Their mansions are torn down. Their wealth is given to the poor.  The ${Quest.PLAYER1} is hailed as a hero. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}
