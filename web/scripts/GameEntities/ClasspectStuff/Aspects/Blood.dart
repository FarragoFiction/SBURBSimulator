import 'Aspect.dart';

class Blood extends Aspect {

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Blood', 'Hera', 'Hestia', 'Bastet', 'Bes', 'Vesta', 'Eleos', 'Sanguine', 'Medusa', 'Frigg', 'Debella', 'Juno', 'Moloch', 'Baal', 'Eusebeia', 'Horkos', 'Homonia', 'Harmonia', 'Philotes']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "uniting warring consort nations against a common enemy",
        "organizing 5 bickering consorts long enough to transverse a dungeon with any degree of competence",
        "learning the true meaning of this human disease called friendship"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "undoing the last remnants of Denizen-inflicted emotional damage in the consorts",
        "putting together a crack team of emotionally bonded consorts to help the recovery of their land",
        "weeping tears of joy as their consorts manage to help each other instead of running to a player anytime the smallest thing goes wrong",
        "preaching a resounding message of ‘don't be a total dick all the time’ to a clamoring crowd of consorts"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "convincing the local consorts to rise up against the Denizen",
        "give unending speeches about the power of friendship and how they are all fighting for loved ones back home to confused and impressionable consorts",
        "completely overthrowing the Denizen's underlings in a massive battle"
    ]);

    Blood(int id):super(id, "Blood", isCanon:true);
}