import "../../GameEntity.dart";
import "Interest.dart";

class Music extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 1, true), new AssociatedStat("maxLuck", 1, true)]);
    @override
    List<String> handles1 = <String>["musical", "pianist", "melodious", "keyboard", "rhythmic", "singing", "tuneful", "harmonious", "beating", "pitch", "waltzing", "synthesized", "piano", "serenading", "mozarts", "swelling", "staccato", "pianissimo", "monotone", "polytempo"];

    List<String> handles2 = <String>["Siren", "Singer", "Tenor", "Trumpeter", "Baritone", "Dancer", "Ballerina", "Harpsicordist", "Musician", "Lutist", "Violist", "Rapper", "Harpist", "Lyricist", "Virtuoso", "Bass"];


    Music() :super(1, "Music", "musical", "loud");

}