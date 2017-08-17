import "Interest.dart";
import "../../GameEntity.dart";


class Athletic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("MANGRIT", 2, true)]);
    @override
    List<String> handles1 = <String>["kinetic", "muscley", "preening", "mighty", "running", "sporty", "tennis", "hard", "ball", "winning", "trophy", "sports", "physical", "sturdy", "strapping", "hardy", "brawny", "burly", "robust", "strong", "muscular", "phenomenal"];

    @override
    List<String> handles2 =<String>["Swimmer", "Trainer", "Baller", "Handler", "Runner", "Leaper", "Racer", "Vaulter", "Major", "Tracker", "Heavy", "Brawn", "Darter", "Brawler"];

    @override
    List<String> levels = <String>["MUSCLES HOARDER", "BODY BOOSTER"];

    @override
    List<String> _interestStrings = <String>["Yoga", "Fitness", "Sports", "Boxing", "Track and Field", "Swimming", "Baseball", "Hockey", "Football", "Basketball", "Weight Lifting"];


    Athletic() :super(4, "Athletic", "athletic", "dumb");

}