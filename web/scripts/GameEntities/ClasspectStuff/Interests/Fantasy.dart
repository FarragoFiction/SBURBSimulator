import "../../GameEntity.dart";
import "Interest.dart";

class Fantasy extends InterestCategory {


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("maxLuck", 1, true), new AssociatedStat("alchemy", 1, true)]);
    @override
    List<String> handles1 = <String>["musing", "pacific", "minotaurs", "kappas", "restful", "serene", "titans", "hazy", "best", "peaceful", "witchs", "sylphic", "sylvan", "shivan", "hellkite", "malachite"];

    @override
    List<String> handles2 =<String>["Believer", "Dragon", "Magician", "Sandman", "Shinigami", "Tengu", "Harpy", "Dwarf", "Vampire", "Lamia", "Roc", "Mermaid", "Siren", "Manticore", "Banshee", "Basilisk", "Boggart"];

    @override
    List<String> levels = <String>["FAKEY FAKE LOVER", "FANTASTIC DREAMER"];

    @override
    List<String> _interestStrings = <String>["Wizards", "Horrorterrors", "Mermaids", "Unicorns", "Science Fiction", "Fantasy", "Ninjas", "Aliens", "Conspiracies", "Faeries", "Elves", "Vampires", "Undead"];


    Fantasy() :super(7, "Fantasy", "imaginative", "whimpy");

}