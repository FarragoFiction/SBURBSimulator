import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Heart extends Aspect {

    @override
    String denizenSongTitle = "Leitmotif" ;//a musical theme representing a particular character;

    @override
    String denizenSongDesc = " A chord begins to echo. It is the one Damnation will play at their brith. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";



    @override
    bool deadpan = true; // heart cares not for your trickster bullshit

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Heart', 'Aphrodite', 'Baldur', 'Eros', 'Hathor', 'Philotes', 'Anubis', 'Psyche', 'Mora', 'Isis', 'Jupiter', 'Narcissus', 'Hecate', 'Izanagi', 'Izanami', 'Ishtar', 'Anteros', 'Agape', 'Peitho', 'Mahara', 'Naidraug', 'Snoitome', 'Walthidian', 'Slanesh', 'Benu']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "providing a matchmaking service for the local consorts (ships guaranteed)",
        "doing battle with shadow clones that are eventually defeated when you accept them as a part of you",
        "correctly picking out which item represents them out of a vault of a thousand bullshit shitty stuffed animals"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "rescuing a copy of themselves from extreme peril",
        "creating clones of themselves to complete a variety of bullshit puzzles and fights",
        "swapping around the souls of underlings, causing mass mayhem",
        "removing the urge to kill from the identity of underlings, rendering them harmless pacifists"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "starting an underground rebel group to free the consorts from the oppressive underling government",
        "having a huge public protest against the underling government, displaying several banned fashion items",
        "convincing the local consorts that the only thing that can stifle their identity is their own fear"
    ]);

    Heart(int id):super(id, "Heart", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("RELATIONSHIPS", 1, true));
        player.associatedStats.addAll(player.getInterestAssociatedStats(player.interest1));
        player.associatedStats.addAll(player.getInterestAssociatedStats(player.interest2));
    }
}