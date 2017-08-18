import "../../GameEntity.dart";
import "Interest.dart";

class Writing extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("freeWill", 2, true)]);
    @override
    List<String> handles1 = <String>["wordy", "scribbling", "meandering", "pageturning", "mysterious", "knowledgeable", "reporting", "scribing", "tricky", "hardcover", "bookish", "page", "writing", "scribbler", "wordsmiths"];

    @override
    List<String> handles2 = <String>["Shakespeare", "Host", "Bard", "Drifter", "Reader", "Booker", "Missive", "Labret", "Lacuna", "Varvel", "Hagiomaniac", "Traveler", "Thesis"];

    @override
    List<String> levels = <String>["SHAKY SHAKESPEARE", "QUILL RUINER"];

    @override
    List<String> interestStrings =  <String>["Writing", "Fan Fiction", "Script Writing", "Character Creation", "Dungeon Mastering", "Authoring"];



    Writing() :super(3, "Writing", "lettered", "wordy");

}