import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Space extends Aspect {

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["GREENTIKE", "RIBBIT RUSTLER", "FROG-WRANGLER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Salamander","Salientia","Spacer","Scientist","Synergy","Spaceman"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String> ["Canon","Space","Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"]);


    @override
    double aspectQuestChance = 1.0; // No items. Frogs only. FINAL DESTINATION.


    @override
    String denizenSongTitle = "Sonata";//a composition for a soloist.  Space players are stuck doing something different from everyone,;

    @override
    String denizenSongDesc =  " An echoing note is plucked. It is the one Isolation plays to chart the depths of reality. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Space', 'Gaea', 'Nut', 'Echidna', 'Wadjet', 'Qetesh', 'Ptah', 'Geb', 'Fryja', 'Atlas', 'Hebe', 'Lork', 'Eve', 'Genesis', 'Morpheus', 'Veles ', 'Arche', 'Rekinom', 'Iago', 'Pilera', 'Tiamat', 'Gilgamesh', 'Implexel']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "seeking out out potential Frog sources",
        "restoring a half-ruined Frog shrine in the wilds of the Land",
        "interogating consorts as to what the point of Frogs even is",
        "navigating one's way through a deudly dungeon in complete darkness, relying only on one's spatial senses"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "stoking the forge and preparing to create a new universe",
        "cloning ribbiting assholes till you’re up to your eyeballs in frogs",
        "cleaning up volcanic debris from the Forge. Man that magma is hot",
        "alchemizing geothermal power infrastructure for the consort villagers. The local consorts babble excitedly at indoor lightning ",
        "making sure they don't accidentally clone a toad instead of a frog by mistake",
        "messing with a variety of frogs that were previously paradox cloned",
        "paradox cloning a variety of frogs, after making a serious note to mess with them later",
        "combining paradox slime from multiple frogs together to make paradox offspring",
        "listening to the ridiculously similar croaks of cloned frogs to figure out where their flaws are"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "trying to figure out why the Forge is unlit",
        "clearing various bullshit obstacles to lighting the Forge",
        "lighting the Forge"  //TODO requires a magic ring.
    ]);

    Space(int id):super(id, "Space", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("alchemy", 2, true));
        player.associatedStats.add(new AssociatedStat("hp", 1, true));
        player.associatedStats.add(new AssociatedStat("mobility", -2, true));
    }
}