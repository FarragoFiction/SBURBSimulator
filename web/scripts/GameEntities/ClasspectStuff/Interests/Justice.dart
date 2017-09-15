import "../../../SBURBSim.dart";

import "Interest.dart";

class Justice extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.POWER, 1, true), new AssociatedStat(Stats.HEALTH, 1, true)]);
    @override
    List<String> handles1 = <String>["karmic", "mysterious", "police", "mind", "keen", "retribution", "saving", "tracking", "hardboiled", "broken", "perceptive", "watching", "searching"];

    @override
    List<String> handles2 =  <String>["Detective", "Defender", "Laywer", "Loyalist", "Liaison", "Vigilante", "Tracker", "Moralist", "Retribution", "Watchman", "Searcher", "Perception", "Rebel"];

    @override
    List<String> levels = <String>["JUSTICE JUICER", "BALANCE RUMBLER"];

    @override
    List<String> interestStrings = <String>["Social Justice", "Detectives", "Mysteries", "Leadership", "Revolution", "Justice", "Equality", "Sherlock Holmes"];




    Justice() :super(6, "Justice", "fair-minded", "harsh");

}