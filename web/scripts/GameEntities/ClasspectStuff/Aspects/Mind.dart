import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Mind extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#3da35a"
        ..aspect_light = '#06FFC9'
        ..aspect_dark = '#04A885'
        ..shoe_light = '#6E0E2E'
        ..shoe_dark = '#4A0818'
        ..cloak_light = '#1D572E'
        ..cloak_mid = '#164524'
        ..cloak_dark = '#11371D'
        ..shirt_light = '#3DA35A'
        ..shirt_dark = '#2E7A43'
        ..pants_light = '#3B7E4F'
        ..pants_dark = '#265133';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Thought", "Rationality", "Decisions", "Consequences", "Choices", "Paths", "Trails", "Trials"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Machine", "Magician", "Magistrate", "Mechanic", "Mediator", "Messenger"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Mind", "Modulation", "Shock", "Awe", "Coin", "Judgement", "Mind", "Decision", "Spark", "Path", "Trial", "Variations", "Thunder", "Logical", "Telekinetic", "Brainiac", "Hysteria", "Deciso", "Thesis", "Imagination", "Psycho", "Control", "Execution", "Bolt"]);


    @override
    String denizenSongTitle = "Fugue"; //a musical core that is altered and changed and interwoven with itself. Also, a mental state of confusion and lo

    @override
    String denizenSongDesc = " A fractured chord is prepared. It is the one Regret plays to make insomnia reign. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Mind', 'Athena', 'Forseti', 'Janus', 'Anubis', 'Maat', 'Seshat', 'Thoth', 'Jyglag', 'Peryite', 'Nomos', 'Lugus', 'Sithus', 'Dike', 'Epimetheus', 'Metis', 'Morpheus', 'Omoikane', 'Argus', 'Hermha', 'Morha', 'Sespille', 'Selcric', 'Tzeench']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "manipulating the local consorts into providing dungeon clearing services",
        "presiding over increasingly hard consort court cases, punishing the guilty and pardoning the innocent",
        "pulling pranks as a minigame, with bonus points awarded for pranks performed on those who 'had it coming'"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "forcing mini bosses to choose between two equally horrible options ",
        "binding the minds of ogres and using them as battle mounts",
        "manipulating underlings into madness and infighting",
        "navigating the countless possible outcomes of whatever bullhit colour the local consorts want to repaint this temple. Great use of their time!"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "learning of the systemic corruption in the local consort's justice system",
        "rooting out corrupt consort officials, and exposing their underling backers",
        "setting up a self-sufficient consort justice system"
    ]);

    Mind(int id) :super(id, "Mind", isCanon: true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("freeWill", 2, true));
        player.associatedStats.add(new AssociatedStat("minLuck", 1, true));
        player.associatedStats.add(new AssociatedStat("RELATIONSHIPS", -1, true));
        player.associatedStats.add(new AssociatedStat("maxLuck", -1, true)); //LUCK DO3SN'T M4TT3R!!!
    }
}