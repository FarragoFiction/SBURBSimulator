import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Law extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.9;
    @override
    double companionWeight = 0.1;


    @override
    double difficulty = 1.0;

    //TODO oh god where did KR put that palette again?
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#383838'
        ..aspect_dark = '#000000'
        ..shoe_light = '#2b1130'
        ..shoe_dark = '#130017'
        ..cloak_light = '#eba900'
        ..cloak_mid = '#c28900'
        ..cloak_dark = '#855900'
        ..shirt_light = '#ffd800'
        ..shirt_dark = '#d1a900'
        ..pants_light = '#44244d'
        ..pants_dark = '#271128';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Law", "Courts", "Trials", "Rules", "Edicts","Control","Cones","Order"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["LEGAL LAD", "SHERRIF SURESHOT", "CONE KOHAI"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Lawyer","Litigator","Lands","Laborer","Lady","Lad","Lamb","Lawman","Luchador","Lover","Legislacerator"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Judge","Law Abiding","Legal","Courting","Trail","Edict","Jury","Baliff","Verdict","Sentence","Jail","Executioner"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death's Lawyer plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["orders","rules", "edicts", "sentences"];

    @override
    List<String> physicalMcguffins = ["chains","gavel","caution tape", "rule book", "dictionary", "wig", "handbook", "lock"];

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>["Themis","Phoenix","Wright","Jupiter","Dike","Marduk","Fortuna"]);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.MOBILITY, -2.0, true),
        new AssociatedStat(Stats.SBURB_LORE, -0.1, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Law(int id) :super(id, "Law", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        //TODO have a real gnosis even for law, don't just steal dooms
        return s.mutator.doom(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("LAW Gavel",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.WOOD, ItemTraitFactory.HAMMER],shogunDesc: "Tiny Whacky Smacky Skull Cracky of Justice",abDesc:"Organics seem to respect this. Use it to your advantage."))
            ..add(new Item("LAW Caution Tape",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.PLASTIC, ItemTraitFactory.RESTRAINING],shogunDesc: "Impassible Barrier",abDesc:"For when you want to tell inferior organics to keep out."))
            ..add(new Item("STOP SIGN",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.STAFF,ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING],abDesc:"This isn't a weapon, dunkass."));
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Scales", "Disorder", "Chaos", "Injustice"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Punish the Rebels", [
                new Quest("The ${Quest.PLAYER1} is told by a worried ${Quest.CONSORT} that a group of underling rebels are causing havoc across the land, breaking laws left and right. They must be stopped! Eventually."),
                new Quest("The ${Quest.PLAYER1} has located a rebel hideout. The underlings get ready for a battle to the death when the ${Quest.PLAYER1} suddenly breaks out a ${Quest.PHYSICALMCGUFFIN} and starts getting all lawyerly on them. The underlings are all sentenced to 30 years in prison, without parole."),
                new Quest("The ${Quest.PLAYER1} finds out through interrogating enough of the underling rebels that they have a big mean leader they call the ${Quest.DENIZEN}. Sounds like a challenge. The ${Quest.PLAYER1} cracks their knuckles as they prepare for the biggest case on this side of Skaia."),
                new DenizenFightQuest("Arriving at the final rebel hideout, ${Quest.PLAYER1} prepares for battle against the ${Quest.DENIZEN}. For their crimes against the ${Quest.CONSORT}s, they're getting the DEATH SENTENCE.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s are no longer plagued by the lawbreakers.","The ${Quest.DENIZEN} continues to run their underling crime ring with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Heroics","Villains","Heroes","Powers","Justice","Metropolises","Comics"])
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Become the Villain", [
                new Quest("The ${Quest.PLAYER1} is taking a walk through one of the land's many cities when they witness a fight break out between an Underling Hero and ${Quest.CONSORT} Villain. One of the Underling Hero's attacks hits the ${Quest.PLAYER1}. They won't be having any of that! The ${Quest.PLAYER1} helps the ${Quest.CONSORT} Villain defeat the Underling Hero, and in turn gets invited to join a league of shady criminals. Sweet."),
                new Quest("The ${Quest.PLAYER1} teams up with some other villainous ${Quest.CONSORT}s to take down a rival team of Underling Heroes. They won't be having any of this LAW business, certainly. Rules were made to be broken, and that's just what the ${Quest.PLAYER1} is going to do."),
                new Quest("After defeating yet another league of Underling Heroes, the ${Quest.PLAYER1} and the other ${Quest.CONSORT} Villains feel a cold chill run down their spine. In the distance, lightning strikes a mountain, revealing the headquarters of the  ${Quest.DENIZEN}, leader of the Underling Heroes and the last hope to preserve law. They're going down!"),
                new DenizenFightQuest("The ${Quest.PLAYER1} arrives at the ${Quest.DENIZEN}'s headquarters, fighting through waves of Underling Heroes before they can finally reach the ${Quest.DENIZEN}. It’s time to end the LAW, once and for all!", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The last of the Heroes is no more.  Injustice takes over the land at last.","The ${Quest.PLAYER1} is defeated. The ${Quest.DENIZEN} holds on to the last remnants of justice in the land.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Become the Hero", [
                new Quest("The ${Quest.PLAYER1} is taking a walk through one of the land's many cities when they witness a fight break out between some ${Quest.CONSORT} Hero and an Underling Villain. Being naturally inclined toward the preservation of order, the ${Quest.PLAYER1} teams up with the ${Quest.CONSORT} Hero and triumphs against the Underling Villain. As a reward, the ${Quest.CONSORT} Hero invites the ${Quest.PLAYER1} to join an elite team of crime fighting good guys! Awesome!"),
                new Quest("The ${Quest.PLAYER1} works together with some ${Quest.CONSORT} Heroes to take down and arrest some Underling Villains. Slowly but surely, the balance of order and disorder begins to shift in order's favor. The number of villains is getting fewer and fewer."),
                new Quest("With the last of the Villainous Underlings defeated, the ${Quest.PLAYER1} rejoices, thinking that justice has been served in this land. But what's this? Lightning strikes the ground far away and causes a dark mountain to shoot up into the sky! The lair of the final villain, the ${Quest.DENIZEN}, has been revealed."),
                new DenizenFightQuest("The ${Quest.PLAYER1} storms the lair of the ${Quest.DENIZEN}, the final villain in all of this land. It's time to bring back KAW, once and for all!", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The last of the Villains is no more. Justice is finally preserved in the land at last.","The ${Quest.PLAYER1} is defeated. The ${Quest.DENIZEN} holds on to the last remnants of injustice in the land.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Greed", "Poverty", "Discrepancy", "Famine", "Starvation"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SILENCE, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Bring the Balance", [
                new Quest("The ${Quest.PLAYER1} looks upon the land and notices how some of the ${Quest.CONSORT}s are low on food and other resources while others live in luxury. Something must be done to fix this!"),
                new Quest("The ${Quest.PLAYER1} comes up with a plan to bring balance to the land. If there's not enough resources, they'll simply have to cut the ${Quest.CONSORT} population in half. But through murder? No... They need something cleaner. Something more random."),
                new Quest("The ${Quest.PLAYER1} wanders through a poverty striken ${Quest.CONSORT} village and is told the legend of the ${Quest.DENIZEN}. The ${Quest.DENIZEN} lives in a lair on the other side of the land, where they hoard all of the land's resources. Oh yeah, and they've got this golden ${Quest.PHYSICALMCGUFFIN} that can half the number of ${Quest.CONSORT}s on the land. The ${Quest.PLAYER1} finds this especially interesting. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} shows up at the ${Quest.DENIZEN}'s lair and asks them to hand over the golden ${Quest.PHYSICALMCGUFFIN}. The ${Quest.DENIZEN} agrees... if the ${Quest.PLAYER1} can defeat them first!","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} uses the golden ${Quest.PHYSICALMCGUFFIN} to cut the ${Quest.CONSORT} population in half. Problem solved. ","The ${Quest.PLAYER1} is defeated and left without the golden ${Quest.PHYSICALMCGUFFIN} they seek.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Create the Balance", [
            new Quest("The ${Quest.PLAYER1} looks upon the land and notices how some of the ${Quest.CONSORT}s are low on food and other resources while others live in luxury. Something must be done to fix this!"),
                new Quest("The ${Quest.PLAYER1} comes up with a plan to bring balance to the land. They can force the ${Quest.CONSORT}s who have an abundance of resources to share them with the ${Quest.CONSORT}s who are resource deprived. But when the ${Quest.PLAYER1} tells them this, they get understandably upset. They worked so hard for their resources, why should they share them with others? The ${Quest.PLAYER1} is left stumped."),
                new Quest("The ${Quest.PLAYER1} wanders through a poverty striken ${Quest.CONSORT} village and is told the legend of the ${Quest.DENIZEN}. The ${Quest.DENIZEN} lives in a lair on the other side of the land, where they hoard all of the land's resources. The ${Quest.PLAYER1} is confused as to why nobody mentioned this before. The solution to the resource problem is obvious now."),
                new DenizenFightQuest("The ${Quest.PLAYER1} shows up at the ${Quest.DENIZEN}'s lair and asks them to be kind and share their resources with the ${Quest.CONSORT}s. The ${Quest.DENIZEN} agrees... if the ${Quest.PLAYER1} can defeat them first!","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} distributes all of the denizen's resources throughout the land, improving living conditions everywhere.","The horrific inequality maintained by the ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
                ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);
    }
}