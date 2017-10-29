import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Blood extends Aspect {
    @override
    double difficulty = 0.0;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#993300"
        ..aspect_light = '#BA1016'
        ..aspect_dark = '#820B0F'
        ..shoe_light = '#381B76'
        ..shoe_dark = '#1E0C47'
        ..cloak_light = '#290704'
        ..cloak_mid = '#230200'
        ..cloak_dark = '#110000'
        ..shirt_light = '#3D190A'
        ..shirt_dark = '#2C1207'
        ..pants_light = '#5C2913'
        ..pants_dark = '#4C1F0D';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["FRIEND HOARDER YOUTH", "HEMOGOBLIN", "SOCIALIST BUTTERFLY"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business", "Buyer", "Butler", "Butcher", "Barber", "Bowler", "Belligerent"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Blood", "Trigger", "Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"]);

    @override
    String denizenSongTitle = "Ballad "; //a song passed over generations in an oral history;

    @override
    String denizenSongDesc = " A sour note is produced. It's the one Agitation plays to make its audience squirm. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["blood","bonds", "friendships", "ties", "pulse", "chains", "oceans"];

    @override
    List<String> physicalMcguffins = ["blood","photo album", "friendship bracelet", "string", "chains", "manacles", "toy army"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Blood', 'Hera', 'Hestia', 'Bastet', 'Bes', 'Vesta', 'Eleos', 'Sanguine', 'Medusa', 'Frigg', 'Debella', 'Juno', 'Moloch', 'Baal', 'Eusebeia', 'Horkos', 'Homonia', 'Harmonia', 'Philotes']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.RELATIONSHIPS, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.MAX_LUCK, -2.0, true)
    ]);

    Blood(int id) :super(id, "Blood", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.blood(s, p);
    }

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Pulse","Clots","Ichor", "Veins", "Chambers", "Arteries", "Flow"])
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.PULSINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)

            ..addFeature(new PreDenizenQuestChain("Cross the Lake", [
                new Quest("The ${Quest.PLAYER1} finds a great lake of red. On the other side, they can see a village of ${Quest.CONSORT}s in need of their help. The ${Quest.PLAYER1} will need to find a way to cross the lake of blood if they want to give aid."),
                new Quest("The ${Quest.PLAYER1} gets help from ${Quest.CONSORT}s on their side of the lake to build a massive boat. They put blood, sweat, tears, but mostly blood, into building the boat."),
                new Quest("With the boat placed into the lake, the ${Quest.PLAYER1} begins their voyage across the raging rapids. They will need all the help they can get from their ${Quest.CONSORT} crewmates to reach the other side."),
                new Quest("After hours of captaining their ship, the ${Quest.PLAYER1} arrives on the other side of the lake. It turns out they spent so long building the boat that the village fixed its own problems. A considerate ${Quest.CONSORT} hands the ${Quest.PLAYER1} a ${Quest.PHYSICALMCGUFFIN} and some boondollars in compensation.")
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Unplug the Rivers", [
                new Quest("The land is a series of candy red lakes. A wise old ${Quest.CONSORT} stops ${Quest.CONSORTSOUND}ing enough to explain that these lakes actually used to be mighty rivers, until ${Quest.DENIZEN} plugged them up with dams. Now the ${Quest.CONSORT}s can't travel or trade with other villages at all, and the land has begun to stagnate."),
                new Quest("The ${Quest.PLAYER1} discovers the correct sequence of hydraulic pumps to activate to increase the river pressure enough to jettison away the blockage in a geyser of candy red. The first river begins to flow, and the local ${Quest.CONSORT}s begin resuming trade activities.   "),
                new Quest("As the ${Quest.PLAYER1} goes around unplugging each river in turn, they begin to notice more and more debris among the candy red flow. Is ${Quest.DENIZEN} conspiring to reclog the rivers? "),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The rivers are too vital to the ${Quest.CONSORT}s to risk having them reclog.","The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling trade based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Chains", "Unions", "Manacles", "Bonds", "Weddings", "Rings", "Webs"])
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.LOW)

            ..addFeature(new DenizenQuestChain("Learn the Power of Teamwork", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} are investigating a dungeon. Suddenly, a chain snaps out of nowhere and handcuffs them together. After some initial bickering, they learn the POWER OF TEAMWORK and complete the dungeon. "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} are separated in a dungeon, and each discovers a dead end that the other can open. They use the POWER OF TEAMWORK to get to the end of the dungeon. "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} trust each other to have their backs.  So when the ${Quest.DENIZEN} starts trying to turn them against each other, there is no question of believing its lies. They team up to strife the ${Quest.DENIZEN}.","Slaying the ${Quest.DENIZEN} proves the POWER OF TEAMWORK!","The ${Quest.PLAYER1} and ${Quest.PLAYER2} end up getting distracted bickering after one of the ${Quest.DENIZEN}'s slanderous barbs hits home. Whoops, their teamwork wasn't strong enough!")
            ], new DenizenReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Chain the Towers", [
                new Quest("The ${Quest.PLAYER1} comes across a mighty series of towers, each with chains limply hanging from their tips. A wise old ${Quest.CONSORT}s explains that before  ${Quest.DENIZEN} arrived, the chains connected each tower to each other, and facilitated trade and communication between settlements. Now the ${Quest.CONSORT}s are isolated from each other, and grow more paranoid and distrustful of strangers each generation.  The ${Quest.PLAYER1} vows to help. "),
                new Quest("The ${Quest.PLAYER1} delves in dungeons until the right items are discovered to alchemize new connectors for the chains. The first set of towers are reconnected, and trade and communication immediately resumes. The local ${Quest.CONSORT}s discover that ${Quest.CONSORT}s from other villages aren't so different, after all.  Another victory against xenophobia! "),
                new Quest("The ${Quest.PLAYER1} has been working tirelessly to hook up tower after tower, only to discover that the first tower they repaired is already broken again. There is no getting around it, ${Quest.DENIZEN} needs to be stopped. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has tracked down ${Quest.DENIZEN}. There can be no mercy. ","The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is finally free to restore the chains, bringing peace and understanding to the land. ","The tyranny  and xenophobia of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("One Degree of Separation", [
                new Quest("They say it can't be done, but the ${Quest.PLAYER1} is confident that they can become friends with every single ${Quest.CONSORT} on ${Quest.MCGUFFIN}book. They start small, just talking to any ${Quest.PLAYER1} that wanders by. They know they can do this!"),
                new Quest("Oh god. Less than 10% of the ${Quest.PLAYER1} population have been friended. The ${Quest.PLAYER1} is starting to think that maybe they understimated how hard this would be. "),
                new Quest("Oh god. It's all so simple. They see it now. Relationships are like a chain, or a web. All they need to do is find the most connected nodes and....yes. Those 6 ${Quest.CONSORT}s are all they need to indirectly gain access to the remaining 90% of the population. The ${Quest.PLAYER1} schmoozes the right few ${Quest.CONSORT}s and finally acomplishes the impossible. They now have AAAAAAAALL the friends!")
            ], new FraymotifReward("Friend Request", "The ${Fraymotif.OWNER} has so many friends, they have to assume everyone in this fight is already in their friend list."), QuestChainFeature.playerIsSmartClass), Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Steal The Friends", [
                new Quest("They say it can't be done, but the ${Quest.PLAYER1} is confident that they can become friends with every single ${Quest.CONSORT} on ${Quest.MCGUFFIN}book. They start small, just talking to any ${Quest.PLAYER1} that wanders by. They know they can do this!"),
                new Quest("Oh god. Less than 10% of the ${Quest.PLAYER1} population have been friended. The ${Quest.PLAYER1} is starting to think that maybe they understimated how hard this would be. "),
                new Quest("The ${Quest.PLAYER1} decides that doing things the hard way is for chumps and just hacks into ${Quest.MCGUFFIN}book to steal all the friends. Yay, they win! They are the best! ")
            ], new FraymotifReward("Friend Stealer", "The ${Fraymotif.OWNER} is now more popular with your friends than you are."), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)



            ..addFeature(new DenizenQuestChain("Pale Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be a good complement. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a diamond symbol on the door. They ignore all common sense and venture inside. Ice cream and hankies abound. There is a couch, and a sad movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!?","Slaying the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new PaleRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Bloodlines","Generations","Family", "Community", "Villages"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)

            ..addFeature(new PostDenizenQuestChain("Connect The Villages", [
                new Quest("In the wake of the defeat of the ${Quest.DENIZEN} it becomes really how isolated the individual ${Quest.CONSORT} villages are. It is far too common for a young ${Quest.CONSORT} to never have even MET their cousins. The ${Quest.PLAYER1} resolves to fix this as soon as possible."),
                new Quest("The ${Quest.PLAYER1} is working hard to restore roads, track down long lost family members and generally just remind all the ${Quest.CONSORT}s that at the end of the day they are all one big happy family. "),
                new Quest("All those hours of hard work have paid off, the individual ${Quest.CONSORT} villages have all been brought back into communication with each other. The sense of community is so strong, you could cut it with a knife. Or maybe wield it as one?")
            ], new FraymotifReward("Community Builder", "It may take a village for the ${Fraymotif.OWNER} to kick your ass, but luckily they have several."), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Stop the Feud", [
                new Quest("The ${Quest.PLAYER1} learns that two prominent ${Quest.CONSORT} families have been feuding for generations, despite once having been the best of friends. The land is on the verge of a civil war as uninvolved ${Quest.CONSORT}s pick a side, and everyone is suffering."),
                new Quest("The ${Quest.PLAYER1} tries to track down the origin of the feud that leaves their land on the verge of a civil war. Nobody can point to any REASON for it to be happening. "),
                new Quest("In a dramatic reveal, the ${Quest.PLAYER1} discovers that ${Quest.DENIZEN} is responsible for the feud. The two ${Quest.CONSORT} families never wronged each other, it's a huge misunderstanding. But how can they prove this to the feuding families? "),
                new DenizenFightQuest("The ${Quest.PLAYER1} confronts ${Quest.DENIZEN}. The beast smuggly admits to its crimes, and claims that the proof needed lies within its hoarde. Will the ${Quest.PLAYER1} be able to claim it?", "The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} shows the proof to the two ${Quest.CONSORT} families, who reconcile in a dramatic shower of happy tears and ${Quest.CONSORTSOUND}ing. ","The deception of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}