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