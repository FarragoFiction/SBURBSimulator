import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Thief extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 1.01;

    @override
    List<String> bureaucraticBullshit = <String>["got caught stealing from a Dersite newstand.","got caught running a con scheme.","finally got caught stealing."];

    @override
    List<String> levels = ["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
    @override
    List<String> quests = ["robbing various enemy imps and ogres to obtain vast riches", "planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly", "torrenting vast amounts of grist from the other players"];
    @override
    List<String> postDenizenQuests = ["literally stealing another players planet. Well, the deed to another player's planet, but still. A planet. Wow", "stealing every last piece of grist in every last dungeon. Hell fucking yes", "crashing the consort economy when they spend their hellaciously devious wealth", "doing a dance on their pile of ill earned goods and wealth"];
    @override
    List<String> handles = ["talented", "terrible", "talkative", "tenacious", "tried", "torrented"];

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

    Thief() : super("Thief", 7, true);

    @override
    bool highHinit() {
        return false;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be taking ${rand.pickFrom(me.aspect.symbolicMcguffins)}  from the ${target.htmlTitle()} and keeping it for themself. ";
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 0.5;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Lockpick",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.OBSCURING, ItemTraitFactory.POINTY,ItemTraitFactory.LEGENDARY],shogunDesc: "Anti-Lock Dagger",abDesc:"No matter what, you'll always have at least one.")) //like katia.
            ..add(new Item("Sneaking Suit",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.OBSCURING],shogunDesc: "Full Body Latex Suit",abDesc:"God. Why is Snake's outfit really called this. So dumb.")) //snake knows what it's about
            ..add(new Item("Dagger",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.POINTY, ItemTraitFactory.EDGED, ItemTraitFactory.DAGGER],shogunDesc: "Stabbing Contraption",abDesc:"For when you wanna show 'em your stabs, I guess."));
    }


    @override
    double getAttackerModifier() {
        return 1.5;
    }

    @override
    double getDefenderModifier() {
        return 0.8;
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
        powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        target.modifyAssociatedStat((-1 * powerBoost), stat);
        p.modifyAssociatedStat(powerBoost, stat);
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Police","Law","Jails", "Slammers", "Officers","Cops","Prisons", "Detectives","Crime","Robbers","Heists"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Steal the Frogs", [
                new Quest("The ${Quest.DENIZEN} cannot release the frogs since the corrupt ${Quest.CONSORT} Cops have confiscated them. The ${Quest.PLAYER1} organizes a team of crack ${Quest.CONSORT}s to help raid the frog evidence lockers. "),
                new Quest("The ${Quest.PLAYER1} performs frog breeding as fast as the ${Quest.CONSORT}s can deliver stolen frogs to them.  "),
                new Quest("The ${Quest.PLAYER1} has finally stolen the final frog.      "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Escape the Law", [
                new Quest("The ${Quest.PLAYER1} is just minding their own business, when they see a huge stack of boonies recovered from the ${Quest.DENIZEN}'s layer and slated to be returned to the ${Quest.CONSORT}s. Unable to resist, they pilfer just a bit. A nearby ${Quest.CONSORTSOUND} sounds the alarm, shit, the ${Quest.PLAYER1} didn't know anybody was looking!  They flee with as many boonies as they can carry."),
                new Quest("The ${Quest.PLAYER1} is keeping a low profile. Shit's still too hot to spend their ill gotten boonies, but it'll be worth it, they just know it."),
                new Quest("Fuck, the ${Quest.PLAYER1} has been spotted. They lead the police ${Quest.CONSORT}s on a wild chase that ends with the ${Quest.PLAYER1} faking their own death and assuming a new identity. They can FINALLY spend those boonies. "),
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Free The Prisoner", [
                new Quest("A weeping ${Quest.CONSORT} approaches the ${Quest.PLAYER1}, spinning a sad tale of their best friend being unjustly arrested during the reign of the ${Quest.DENIZEN}. Nobody will free him, even after the ${Quest.DENIZEN} is gone. The ${Quest.PLAYER1} doesn't really care until the weeping ${Quest.CONSORT} mentions a huge reward. It's ALL about the boonies, baby. "),
                new Quest("The ${Quest.PLAYER1} manages to steal the keys to the ${Quest.MCGUFFIN} Prison, easy peasy. It happens so fast it's like there was no key in the first place.  It's not much harder for them to abscond with the Prisoner ${Quest.CONSORT}, too. Nice."),
                new Quest("The ${Quest.PLAYER1} returns the Prisoner ${Quest.CONSORT} to their weeping and ${Quest.CONSORTSOUND}ing best friend. The Prisoner ${Quest.CONSORT} reveals the location of some valuable stolen goods they 'heard about' in prison.  Good enough for the ${Quest.PLAYER1}.")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            //god, i love heist movies.
            ..addFeature(new PostDenizenQuestChain("Shit, Let's Be a Heist Movie", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the ${Quest.CONSORT}s have recovered their precious ${Quest.PHYSICALMCGUFFIN}. Huh. That looks....REALLY valuable. And the ${Quest.PLAYER1} totally deserves it, I mean, they did AAAAAAALL the work defeating the ${Quest.DENIZEN}, right? They begin plotting to take it."),
                new Quest("The ${Quest.PLAYER1} assembles a team of Disreputable ${Quest.CONSORT}s. There is Baron ${Quest.CONSORTSOUND}worth, the disaffected Heir to the ${Quest.MCGUFFIN} Fortune, Smokes Mc${Quest.CONSORTSOUND} their 'in' with the shady underbelly of ${Quest.CONSORT} society, and Fresh Jimmy, the wide eyed youth who has the stickiest fingers in Paradox Space.  The ${Quest.PLAYER1} thinks they have enough quirky characters to actually start planning this heist, now."),
                new Quest("On the day of the big heist, Fresh Jimmy alerts the authorities about the impending robbery. He rats out the other Disreputable ${Quest.CONSORT}s and the ${Quest.PLAYER1}, too.  As the ${Quest.CONSORT} authorities converge on the warehouse the team has converted to a make shift base of opperations, they begin receiving reports that the ${Quest.PHYSICALMCGUFFIN} has already been stolen? Fresh Jimmy has already escaped to the side, it turns out the traitor ruse was a distaction."),
                new Quest("The Disreputable ${Quest.CONSORT}s meet up with the ${Quest.PLAYER1} after the heat has died down to collect their share of the proceeds. Wow, it turns out crime really DOES pay! ")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);


    }


}