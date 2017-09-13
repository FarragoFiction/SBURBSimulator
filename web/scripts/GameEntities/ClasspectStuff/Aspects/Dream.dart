import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Dream extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff3399"
        ..aspect_light = '#cc87e8'
        ..aspect_dark = '#9545b7'
        ..shoe_light = '#ae769b'
        ..shoe_dark = '#8f577c'
        ..cloak_light = '#9630bf'
        ..cloak_mid = '#693773'
        ..cloak_dark = '#4c2154'
        ..shirt_light = '#fcf9bd'
        ..shirt_dark = '#e0d29e'
        ..pants_light = '#bdb968'
        ..pants_dark = '#ab9b55';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Clouds", "Clay", "Putty", "Art", "Design", "Dreams", "Repetition", "Creativity", "Imagination", "Plagerism"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["ADHDLED YOUTH", "LUCID DREAMER", "LUCID DREAMER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dreamer", "Dilettante", "Designer", "Delusion", "Dancer", "Doormat", "Decorator", "Delirium", "Disaster", "Disorder"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lunar", "Lucid",  "Prospit", "Derse", "Dream", "Creative", "Imagination"]);


    @override
    String denizenSongTitle = "Fantasia"; //a musical theme representing a particular character;

    @override
    String denizenSongDesc = " An orchestra begins to tune up. It is the one Obsession will play to celebrate. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    bool deadpan = false;

    @override  //muse names
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Dream', 'Dreamer','Calliope', 'Clio', 'Euterpe', 'Thalia', 'Melpomene', 'Terpsichore', 'Erato', 'Polyhmnia', 'Urania', 'Melete', 'Mneme', 'Aoide','Hypnos', 'Morpheus','Oneiros','Phobetor','Icelus', 'Somnus','Metztli','Yohualticetl','Khonsu','Chandra', 'Mėnuo','Nyx']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "brainstorming five different ways to solve the same problem",
        "navigating a dungeon where enemies constantly give you incorrect advice on how to procede",
        "navigating the exact same dungeon three different times, but you are teleported to the begining if you go the same way twice"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "helping each consort village to look completely unique",
        "distributing hundreds of different recovery plans to the various Consort villages",
        "accepting that sometimes repetition is fine for the smaller works, if it gives you the willpower needed for the bigger ones",
        "designing a dozen different epic statues depicting their defeat of the Denizen"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "realizing that their Denizen has literally done everything first",
        "proving to the local Consorts that while there is nothing new under the sun, what THEY are doing is unique",
        "exposing the Denizen as a dirty plagarist"
    ]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("alchemy", 2, true),
        new AssociatedStat("mobility", 1, true),
        new AssociatedStat("sanity", -2, true)
    ]);

    Dream(int id) :super(id, "Dream", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.dream(s, p);
    }
}