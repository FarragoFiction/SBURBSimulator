import "../../GameEntity.dart";
import "Interest.dart";


class Academic extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("freeWill", -2, true)]);
    @override
    List<String> handles1 = <String>["serious", "researching", "machiavellian", "princeton", "pedagogical", "theoretical", "hypothetical", "meandering", "scholarly", "biological", "pants", "spectacled", "scientist", "scholastic", "scientific", "particular", "measured"];

    @override
    List<String> handles2 = <String>["Business", "Stuck", "Student", "Scholar", "Researcher", "Scientist", "Trainee", "Biologist", "Minerologist", "Lecturer", "Herbalist", "Dean", "Director", "Honcho", "Minder", "Verbalist", "Botanist"];

    @override
    List<String> levels = <String>["NERDY NOODLER", "SCAMPERING SCIENTIST"];

    @override
    List<String> _interestStrings =<String>["Archaeology", "Mathematics", "Astronomy", "Knowledge", "Physics", "Biology", "Chemistry", "Geneology", "Science", "Molecular Gastronomy", "Model Trains", "Politics", "Geography", "Cartography", "Typography", "History"];



    Academic() :super(13, "Academic", "smart", "nerdy");

}