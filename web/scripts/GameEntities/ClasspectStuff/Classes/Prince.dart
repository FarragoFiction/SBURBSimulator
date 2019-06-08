import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Prince extends SBURBClass {

    @override
    String sauceTitle = "Archduke";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 1.01;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "Prince I:___ N4IgdghgtgpiBcIAKAnAlmAxjABASRABoQAzAGwgDcB7FAFRgA8AXBEAHgCMA+AZTwAiAUQCKAVSG868dgHoeOOgAtcvAMJCAckID6AeQDq2gEo7NAQQCyQnGgDOOACbUMAcxycIzZmVwB3NGYlHDtqWGowXAgHAAcIFGYcahIcCBC0RxgARwBXGDtmADocc1cIDALUsjIkx0c7Qhwg1Q1tfSMhUwtrWwdKNExmWjRqHIdOAE9UnEwwmE9MAGtUxOacCkq7GFmwR2LlGDQUJJiYiJgwZkalaj8YShgURr8IMkWHCBepnLA7TC8VHtFCocOotLpDCYzFYbPYQnM-EovB5qM0UDBHB4pmsSBBBk0kYlXjUgsiSGhXEpmG4cC8HCRaDgwKilG5GpwckTEr5oqsVFMSDAYDU0mRAj5cFBaLgzncUCQcmRCgAdMBcFDcdXcIggZjxVwwZh6SJsZgoPI6s0Ug0oNQRRyBEa-AAyaH6YFcbAA2sBlSA0FAzgkIJcDLRHH74H7NLJzH7CNG9HRI37cWQtvG-QA1Yx4XgAaTjCFTrwzRD9kFgKZAeDsvGFJEz-sDtD1lzwl2rAAY-QBfRq+5tBtvMMMoCPFkAxosJqdJ6tpsuznN5wsL0swJuVzeT2vmMUPJsB4ch5gd5jdvsDv3H1unscTqNT2NNzTzydmvJNlcFotPxc7rO27VrWADi1COHQaCPEeLbBu2naTj2ID9jgg63vBo7htWSBkDkSyKNQiwXPAOhkTgmgACx4K4jiUq4zCuDEaAAEKYHg5iFpw5goK4ACafiaHx5gcVk5gAJxkAAVqBajmAIIiuCxUD5kI5icK4IhCAArJRfjmDA5jOq4aB6LwoGMOYfh6AJABMBl0CxjBCGQahqK4Ah6JgahQH4fEsc6DJ4P5SjmFA5hhYE1B2AAzLwViolk+Z+AAtHQrigQAjK45gABLGGo+bUOYLFdhAAAcfjcXoWSWMwjgANS5f5EzmEgIilGAABaiwpXYABSlFIJAvCWFJahKHRLFiUIxWLB5haaHgShqJoABivB2JQuWuF2uU6XgahgLwEB0OY1BkOYYh6AAXq4Ew5Jwah4WI8Xyc15iUFAIiUcwlBdXozpKCxPyuDdMD9XxuVdXxvAsQ1khdowDUwLw-VZF13WUGQxjaYwAMiHYaiZWQvB8ZoEAsWt5iZSlJAGAIUmYF2ZAAOzxY4RkoN5dhZFkoHMFkABsDVQCxoENZlXUxWtAhqGIZACOY5NSfFLFoDJlgxGAlgABq2ZRlAxQ1rj9SxfFILZXZoEouVva+75Pp+gHZrmv7rumLvgNAO5Prl0S8NgkSwSeCEXkhV5oTecEjg+1bTg7yaTgB35u2uycbluPsgXYxghs4UAh3eYfVjFMV9gAupa6CuDadq7I6ER2M6+felXxAwCQgqDHYa20K67qeogPrR6HWHjtWJ1gIEExZ1Wk4TSGBqWBMvB6uHy5p3+Jae0XmGaDkUCcDBk4pZl5codeQ7F+Pj5+mt6K4AYaDVHPvt+ovHowCva9eKnq7b1IJncs1996H2Pigas59I7oRjvebCk5cL4WWHQIiJEyI6AotRWi9FGLMTYhxLiPF+KCWEqJCS0lZLyUUspVS6lNI6T0gZIyJkzIWSsjZPw9kYCOWcq5dynlvK+X8oFagwUWKhXCpFIYsV4qWESslNKGVsp5QKkVEqZVKrVVqvVJqLU2odVcN1XqA0hojTGhNKaM05oLXMEtFa61NrbV2vtbSh1jqnXOpda6d0HpPRem9AQH0vo-T+gDIGIMPTg0htDWG8NEbI1RujTGXVsa43xnoQmxNSbk0ptTWm9NGbMzZhzLmPM+YC2FqLcWktpay3lorZWmhVYlQ1qBLWOt9aG2Nqbc2ltra23tiA4Ck5QJukMoMJ0-93YfnNF7DCI4D5HxPk+ZCvZ24gE7t3Zgvd+75zsG3FCQA",
        "Prince II:___ N4IgdghgtgpiBcIAKAnAlmAxjABASTxABoQAzAGwgDcB7FAFRgA8AXBEAHgCMA+AZTwARAKIBFAKrC+9eBwD0vHPQAWuPgGFhAOWEB9APIB1HQCVdWgIIBZYTgCuYcjAgBnVS5wATGC5Yo7mCxoNGA4EADmEBi+OC4A7hAoUB40pDgwYDBQaD72LhjhOCyqaChhLgAOMIE4FTRxMCgeGDh03mUsNDiYNFAVTiy4ELFo3gCOdj4sAHQ4Fh7FuC5QNADWuJhOiS5ERaphKM4HNA6ee2qaOgbGwmaWNjhoHhDk5DikKBCBdodnEGBnby+FA0ACeME8swAQqD0lAuJ9MAUvFN-IFgmBdoscBptHojKZzNZbKswPUPHFlBAWI8abB-gsulwhjhUBhsNMADpgbgoHi8njEEAsRLhGAsfSZdh+SZCvxocJilDqEKeNBBEIuAAyaCoBXYAG1gJyQGg+nQRWAWIY2ib4CatHILCaiA79PQ7SbSC8XDAXSaAGomPB8ADSzoQXp9fuIJsgsE9IDwLj4MHIpH9pvNKEtLDwVsTAAYTQBfXbGrN1HP-a22yMgR0R10N92J73kX2ZoMh8Nt6OZ+Mx+1JlwWci6mPNs1V3P5lhF0vlk3Ti01m0oTyJxuZrSt+vtzuxkDdsMR4cHydx6BDk3JgDiNE89ByKEzK+rVrnC5AZZwFffubrpu9ZIOQASrEoawZPAuiwTgWgACx4OEnjhMo4QsOEFRoFCmB4BY4ZcBYKDhAAmnEWikRY+FjBYACc5AAFZ3uoFiCKI4RQlAobCBYXDhKIwgAKwIXEFgwBYWrhGg+h8HeTAWHE+jkQATOJ9BQkwwjkOo6jhII+iYOoUBxKRUJaqQNB4GZygWFAFh2eqNAuAAzHw1g0CwYyhnEAC09DhHeACM4QWAAEiY6ihjQFhQoWEAABxxER+hjFYLCeAA1GFZmghYSCiBY4RgAAWqsvkuAAUghSCQHwViMeoyioVCtHCDFqz6eGWh4Mo6haAAYnwLhUGF4SFmFwl4OoYB8BA9AWDQ5AWOI+gAF7hKCdhcOoYHiO5bE5RYVBQKICEsFQJX6FqyhQg44RrTAlWkWFJWkXwUKZVIhZMJlMB8JVYwlaVVDkCYQlMFdoguOoQXkHwpFaBAUIDRYQW+aQhiCIxmCFuQADs7meJJKBGS4YxjHeXkAGyZVAUJ3plQUlS5A2COo4jkIIFiI4x7lQmgzFWBUYBWAAGipCFUC5mXhJVUKkUgKmFmgyhhQdO57sOMqXsewann2Ha64OiZha4fDYJkb7ZrOBb1sWP5LpWq5WkBW5OprHr7v2R4nr23tGwO16JsmJj-J4vTWzONZfvW1PU6WAC6croIqjQqgC6oYtq4eGsnJAwKQpDVCwLgDXQOp6mA4SGv+NtrnWw5zWA6qgkHCb1k1-xilYoJ8CK86+-r-vnj7U711aWh2PCjSJr5QUuQ7v519HruNyaA2HLghhoK87c3iAXfVzAvf99SXbD2eUaB0eAE1lPM+vvWC9L07d9rxuiageBkHrGAMFwUQshVC6FMLYVwvhQixEyIUSojReiTEWJsQ4lxHifEBLCVEuJSS0lZLyUUspOIakYAaS0jpPSBkjImTMhZKyNk7IOWyJ0Vy7krCeW8n5AKwVQoRSijFOKiVkoWFSulLKOUYT5UKsVMqFVqq1QgPVRqzVOJtQ6l1CwPU+qDWGqNcak0hLTVmvNRay1VobS2jtPaB1BBHROmdC6V0bp3Wro9Z6r13qfW+r9f6gNgYlVBuDSG+hoaw3hojZGqN0aY2xrjAmRMSZkwplTMYtN6aM2ZqzdmnNua835oLO8wtRYSyljLOWCslYqzVhrI8Jt6x3gnBYdEIQL49ivsKfwut34sAfsyJ+w4l75xAIXYugQy4V3Di4POP4gA"
];
    
    @override
    double difficulty = 1.0;
    Prince() : super("Prince", 10, true);
    @override
    List<String> levels = ["PRINCE HARMING", "ROYAL RUMBLER", "DIGIT PRINCE"];
    @override
    List<String> quests = ["destroying enemies thoroughly", "riding in at the last minute to defeat the local consorts hated enemies", "learning to grow as a person, despite the holes in their personality"];
    @override
    List<String> postDenizenQuests = ["thinking on endings. The end of their planet. The end of their denizen problems. The end of that very, very stupid imp that just tried to jump them", "defeating every single mini boss, including a few on other players planets", "burning down libraries of horror terror grimoires, shedding a few tears for the valuable knowledge lost along side the accursed texts", "hunting down and killing the last of a particularly annoying underling class"];
    @override
    List<String> handles = ["precocious","priceless","proficient","prominent","proper", "perfect", "pantheon"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * -0.5; //good things invert to bad.
        } else {
            powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
        }
        return powerBoost;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Feather'd Cap",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BESPOKE],shogunDesc: "Pupa Pan Hat",abDesc:"So fucking pretentious."))
            ..add(new Item("Crown",<ItemTrait>[ItemTraitFactory.LEGENDARY,ItemTraitFactory.GOLDEN, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.BESPOKE],shogunDesc: "A False Symbol of Power",abDesc:"Prince shit. Man. The tiara dealy."))
            ..add(new Item("Gunpowder",<ItemTrait>[ItemTraitFactory.EXPLODEY, ItemTraitFactory.CLASSRELATED],shogunDesc: "The Best Thing since The Shogun",abDesc:"Huh. I guess cause princes are destructive."));
    }


    @override
    bool hasInteractionEffect() {
        return true;
    }
    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be destroying ${rand.pickFrom(me.aspect.symbolicMcguffins)} in themselves. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify self.
        p.modifyAssociatedStat(powerBoost, stat);
    }


    @override
    void initializeThemes() {
       /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Endings","Finales", "Epilogues", "Codas","Curtains","Conclusions"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.LOW)

            ..addFeature(new PostDenizenFrogChain("Destroy the Lack of Frogs", [
                new Quest("With the closing of the curtain, the ${Quest.DENIZEN} has released the frogs, and yet they are nowhere to be found. The ${Quest.PLAYER1} shatter space itself to reveal an entire dimension of croaking assholes. "),
                new Quest("The ${Quest.PLAYER1} has broken how space itself works to do the ectobiology as effciently as possible.   "),
                new Quest("The ${Quest.PLAYER1} has found the final frog in a crack in reality.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Fix All The Things", [
                new Quest("The land is a fucking mess after all the shit the ${Quest.DENIZEN} put it through, and it falls to the ${Quest.PLAYER1} to get it back to normal. They organize a team of ${Quest.CONSORT}s to start rebuilding infrastructure."),
                new Quest("The ${Quest.CONSORT} economy is a fucking mess, and probably was even before the ${Quest.DENIZEN} started to fuck things up. Why would you even use ${Quest.PHYSICALMCGUFFIN} as a currency? The ${Quest.PLAYER1} wastes way too much time explaining how economies work."),
                new Quest("The land finally appears to be in a good state. The ${Quest.PLAYER1} is wistful as they realize that they are no longer needed. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}
