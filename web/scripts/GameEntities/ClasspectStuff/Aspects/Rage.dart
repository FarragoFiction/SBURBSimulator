import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Rage extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9900cc"
        ..aspect_light = '#974AA7'
        ..aspect_dark = '#6B347D'
        ..shoe_light = '#3D190A'
        ..shoe_dark = '#2C1207'
        ..cloak_light = '#7C3FBA'
        ..cloak_mid = '#6D34A6'
        ..cloak_dark = '#592D86'
        ..shirt_light = '#381B76'
        ..shirt_dark = '#1E0C47'
        ..pants_light = '#281D36'
        ..pants_dark = '#1D1526';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Mirth", "Whimsy", "Madness", "Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams", "Denial"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MOPPET OF MADNESS", "FLEDGLING HATTER", "RAGAMUFFIN REVELER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Raconteur", "Reveler", "Reader", "Reporter", "Racketeer"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo", "Horrorcore", "Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"]);


    @override
    String denizenSongTitle = " Aria"; // a musical piece full of emotion;

    @override
    String denizenSongDesc = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Rage', 'Ares', 'Dyonisus', 'Bacchus', 'Abbadon', 'Mammon', 'Mania', 'Asmodeus', 'Belphegor', 'Set', 'Apophis', 'Nemesis', 'Menoetius', 'Shogorath', 'Loki', 'Alastor', 'Mol Bal', 'Deimos', 'Achos', 'Pallas', 'Deimos', 'Ania', 'Lupe', 'Lyssa', 'Ytilibatsni', 'Discord']);

    @override
    List<String> symbolicMcguffins = ["rage","sanity", "power", "whimsy", "impossible", "screams", "laughter", "madness"];
    @override
    List<String> physicalMcguffins = ["rage","face paint", "script", "bike horn", "war mask", "murder weapon", "loud speaker", "bullhorn", "broken machine"];


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.POWER, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Rage(int id) :super(id, "Rage", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.rage(s, p);
    }

    //Rage is so GODDAMNED EASY to come up with qualia for. it's so visceral.
    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Murder","Strife","Shrieks", "Combat","Hate", "Death","Violence", "War", "Screams","Noise", "Chaos", "Bloodrage", "Rage","Wrath"])
            ..addFeature(FeatureFactory.ANGRYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.MEDIUM) //THIS IS STUPID.
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNFIRESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Stop the War", [
                new Quest("Two different factions of ${Quest.CONSORT}s have been at war for generations. Neither side gives the ${Quest.PLAYER1} a straight answer on WHY they are fighting. They are tearing the land apart with needless bloodshed. This is stupid. "),
                new Quest("The ${Quest.PLAYER1} is starting to think it's impossible to get the two sides of the ${Quest.CONSORT} War to just stop fighting. They yell, they rant, they pass out flyers, they blame the ${Quest.DENIZEN},  they even try fixing both sides' problems. But they keep fighting. This is so fucking stupid."),
                new Quest("God. It's...it's just so FRUSTRATING that the two ${Quest.CONSORT} armies seem dedicated to wiping each other out. A stray bullet grazes the ${Quest.PLAYER1}. They see red. When they come to, the only living thing left is the ${Quest.PLAYER1}. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} has slithered onto the former battlefield to taunt the ${Quest.PLAYER1}. 'Good job', they hiss, in a language only the ${Quest.PLAYER1} can understand, 'There can be no strife when there are no armies left alive.' With no thought, the ${Quest.PLAYER1} attacks them in a rage.  ","When the bloodrage is done, the ${Quest.PLAYER1} is left to deal with the fact that only they are left alive. They wander the land, looking for anyone left alive. At least....it seems, some ${Quest.CONSORT}s survived, avoiding the conflict entirely. The ${Quest.PLAYER1} wishes they could have, too.","The Rage was not enough for the ${Quest.PLAYER1} to win.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        //guys. I think maybe all these clowns aren't actually happy. smell blood rarely, but it's there.
        addTheme(new Theme(<String>["Whimsy", "Mirth","Circuses", "Tents","Clowns", "Wackiness", "Laughter"])
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FOOTSTEPSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.LOW) //THIS IS STUPID.

            ..addFeature(new DenizenQuestChain("Do a Stupid Dance", [
                new Quest("The ${Quest.CONSORTSOUND}ing and capering ${Quest.CONSORT}s are...OKAY, you guess? They keep asking the ${Quest.PLAYER1} to do a stupid ${Quest.MCGUFFIN} Dance, though. They politely decline."),
                new Quest("A capering ${Quest.CONSORT} tells the ${Quest.PLAYER1} that some underlings looted a local village. The underlings will only return the stolen property if they are defeated in a stupid  ${Quest.MCGUFFIN} Dance off. The ${Quest.PLAYER1} politiely declines and defeats them in a good old fashioned beat down. The ${Quest.CONSORT}s seem less than enthused about getting their stolen property back. Something about the ${Quest.PLAYER1} being a spoilsport?"),
                new Quest("A crying ${Quest.CONSORT} child asks why the ${Quest.PLAYER1} is such a meany head. Why won't they dance? Defeated, the ${Quest.PLAYER1} hangs their head, and then begins doing an extremely stupid ${Quest.MCGUFFIN} Dance, well below their dignity. The ${Quest.CONSORT} child is estatic and begins ${Quest.CONSORTSOUND} in time to the music that only the ${Quest.PLAYER1} can hear. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} approaches the ${Quest.PLAYER1}, complimenting them on their stupid ${Quest.MCGUFFIN} Dance. Mortified, the ${Quest.PLAYER1} initiates strife.","It is done. Now NO ONE but that ${Quest.CONSORT} child knows of the blow to the ${Quest.PLAYER1}'s dignity. No one at all.","You just KNOW that that shitty ${Quest.DENIZEN} is gonna somehow post videos of the ${Quest.PLAYER1}'s stupid ${Quest.MCGUFFIN} dance online. They must be stopped.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        //TODO make sure to have pre and post denizen quests for this one too, so it can be eXTRA bullshit.
        addTheme(new Theme(<String>["Denial","Rejection","Resignation","Impossibilty","Awareness","Walls","Meta","Bullshit","Finality","Acceptance", "Allowance", "Frustration"])
            ..addFeature(FeatureFactory.ANGRYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH) //THIS IS STUPID.
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH) //we are laughing at you, asshole.
            ..addFeature(new DenizenQuestChain("Hate This Bullshit Land", [
                new Quest("The ${Quest.PLAYER1} has wandered around for hours. There are walls. And empty villages. And FUCKING NOTHING ELSE. What is WRONG with this stupid as fuck bullshit land? "),
                new Quest("The ${Quest.PLAYER1} feels like someone is laughing at them. Not like....a ${Quest.CONSORT}, as irritating as they are. Like....something watching all of this and thinking it's all a big laugh. Like entertainment. Somebody out there thinks it's FUNNY that this land is so empty and bullshit and frustrating right now. The ${Quest.PLAYER1} is so fucking pissed."),
                new Quest("The ${Quest.PLAYER1} has fucking given up. Fine. This part of the land is bullshit. There are no quests, no challenges. The land itself rejects their attempts to find meaning in it. FUCKING FINE.  A sign pops up next to the resigned ${Quest.PLAYER1}. 'You win, teleport to fight ${Quest.DENIZEN}? Y/N'. God DAMN it. "),
                new DenizenFightQuest("This is the least satisfying quest chain, ever. With a hearty 'FUCK YOU', the ${Quest.PLAYER1} presses the button to fight their bullshit final boss. Fuck dignifying them with a name. The ${Quest.PLAYER1} is going to work out all their fucking frustrations with this land with a good old fashioned beatdown. ","Fucking YES. Finally some goddamned CATHARSIS! Maybe the ${Quest.PLAYER1} can finally put this bullshit chapter of their land behind them.","God FUCKING DAMN IT. After all that the ${Quest.PLAYER1} LOSES!? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}