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
        "Rogue I:___ N4IgdghgtgpiBcIBKB7A5gVxgAgJIgBoQAzAGwgDcUAnAFRgA8AXBEAHgCMA+AZVwBEAogEUAqoJ614bAPTdstABY4eAYUEA5QQH0A8gHUtSbRoCCAWUHYmEANYwAztgcpY2AA4oAlmCalHTgBWGGC21ooQTNheDmAA5FFMytQwcU4QYAAm2GheFI7RiSjOrjieNNgAjlgOUbn51NgA7orFTRlMTl5MAHTYAEIYicpg4TjVjnV5MI2ZKI7xUXPYGQCeST5ozd2KhX36EVHtTkll3r7YKMThkQD82Lq7TTCkpAQrUf4QtWPYapo6AxGEwWKxoGCdFbYUjdPw4DgQpgzD7WOybZqHaKxBJjFJpDEwUanaxeNwAY1KJ2KtRgEFIJVgGzAW1JnmoNl8fQAOmBONQuHyuIQQDZqOCmLowHBEExqFhhbKvGhwdRVCgst0vOqHAAZPKbVgAbWAXJArJoHKY+homVN8FNGhkplNBAdulodtNxDpDhgLtNADUkLgeABpZ0IL0+v2EU2QWCekC4Bw8F7Ef1mqBsy24XyJgAMpoAvu8TZnsx1rdRbZGQI6I666+7E97SL6M0GQ+GW9GM-GY-akw5TDD8hnzeyOrmmAXi6XTRPLVWa4P6xmNM3a7KsB3g2GI4PW+3Y+BoAPTcmAOIoTK0LwzcdZi1TvO1wsgEvYMuLys2xMABVIDAyTCWgUHsMB4G0aDsA0AAWXA0EyNBFDQJg0HcLx+jJXBTHDDhTDFABNJoNCI0xcMqUwAE5SECS9VFMfhhDQfooFDQRTA4NBhEEABWOCmlMGBTB1XJdB4S8GFMJpdBIgAmYTaH6BhBFIVRVDQfhdDJVQoCaIj+h1YgUFwQzFFMKBTEs7oUAcABmHgLBQJhKlDJoAFpaDQS8AEY0FMAAJJBVFDFBTH6fMIAADiaAjdEqcwmEyABqQLDNWUx-2EUw0DAAAtWwPIcAApOD-0gHhzECVRFGQ-oqMEcLbC08MNFwRRVA0AAxHgHAoQK0HzQL+NwVQwB4CBaFMFBSFMURdAALzQVYMA4VQgNEJymPS0wKCgYQ4KYCh8t0HVFEGZlFpgEqiMC-KiJ4foUokfMGBSmAeBKyp8oKihSCQPiGFO4QHFUXzSB4IiNAgfputMXyPOIfR+ECMl81IAB2JzMlE6hdIcSpKkvVyADYUqgfpLxS3z8vs7r+FUURSH4UxocCJz+i8ejzHcMBzAADXkuCKHslK0BK-oiP-eT8y8RRAu29dN0HbcY0bTt9x7Nt1bjM9E0C74eDJQldfLZ9fGnWcP3nc3J18ZdEzXE8Nw9WsjzNzXu3d3sT37RNkyQDI5igR8K0t19B3s+ziwAXQVaglRVNUNSYLUwF1YOjXjogYGIYgYDJTpupoPUKANRBjQXJ97atP9a26lIcH0LxXj7fXa1qjJwXMVYeBsGcTy9g8ox1sOLaYDQMCgBFqETDzfJjm2v2r8O6+rRNzBQDhW+6VZ24TTuImZGBe-7yJdy7EeSF9xsf18KeZ4fWtF7nFe7aXevB0A4DQPAwkoIwXgohZCqF0KYWwrhfChE0AkTIhRUwVFaL0UYsxVi7FOLcV4gJISIkxJeAklJGSckmiKRgMpVS6lNLaV0vpQyxlTLmUstZKAtkHJOS3q5dyXkfL+SCiFMKEUoqxXiolZKaUMpZRynlQqxUyoVQgFVGqdVWKNWaq1Uw7VOo9T6gNIaI0+JjQmlNGac0FrLVWutTa21+C7X2odY6p1zqXTQNdW691HrPVeu9T631fr5X+oDYGuhQbg0htDWG8NEbI1RujLGOM8YEyJiTSo5NKbU1pvTRmzNWbs05tzS8vN+ZCxFmLCWUsZZywVkrP2HdByXmmKYIu6dL5ay3HKM299J7T1ntbIsOcQB5wLkXBwJdqA6mDg4bOH4gA",
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
