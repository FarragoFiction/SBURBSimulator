import "../../GameEntity.dart";
import "Interest.dart";

class PopCulture extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("mobility", 2, true)]);

    @override
    List<String> handles1 = <String>["worthy", "mega", "player", "mighty", "knightly", "roguish", "super", "turbo", "titanic", "heroic", "bitchin", "power", "wonder", "wonderful", "sensational", "thors", "bat"];

    @override
    List<String> handles2 = <String>["Superhero", "Supervillain", "Hero", "Villain", "Liaison", "Director", "Repeat", "Blockbuster", "Movie", "Mission", "Legend", "Buddy", "Spy", "Bystander", "Talent"];

    @override
    List<String> levels = <String>["TRIVIA SMARTYPANTS", "NIGHTLY NABBER"];

    @override
    List<String> _interestStrings = <String>["Irony", "Action Movies", "Superheroes", "Supervillains", "Video Games", "Movies", "Television", "Comic Books", "TV", "Heroes"];


    PopCulture() :super(9, "PopCulture", "geeky", "frivolous");

}