import "Interest.dart";
import "../../GameEntity.dart";

class Comedy extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("minLuck", -1, true),
        new AssociatedStat("maxLuck", 1, true)
    ]);

    @override
    List<String> handles1 = <String>["mischievous", "knavish", "mercurial", "beagle", "sarcastic", "satirical", "mime", "pantomime", "practicing", "pranking", "wokka", "kooky", "haha", "humor", "talkative", "harlequins", "hoho"];

    @override
    List<String> handles2 =<String>["Laugher", "Humorist", "Trickster", "Sellout", "Dummy", "Silly", "Bum", "Huckster", "Raconteur", "Mime", "Leaper", "Vaudevillian", "Baboon", "Boor"];

    @override
    List<String> levels =  <String>["PRATFALL PRIEST", "BEAGLE PUSS DARTABOUT"];

    @override
    List<String> interestStrings = <String>["Puppets", "Pranks", "Comedy", "Jokes", "Puns", "Stand-up Comedy", "Humor", "Comics", "Satire", "Knock Knock Jokes"];


    Comedy() : super(0, "Comedy", "funny", "dorky");
}
