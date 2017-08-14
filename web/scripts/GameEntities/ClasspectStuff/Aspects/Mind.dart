import 'Aspect.dart';

class Mind extends Aspect {

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

    Mind(int id):super(id, "Mind", isCanon:true);

}