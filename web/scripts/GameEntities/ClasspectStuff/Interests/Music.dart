import "../../GameEntity.dart";
import "Interest.dart";

class Music extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 1, true), new AssociatedStat("maxLuck", 1, true)]);
    @override
    List<String> handles1 = <String>["musical", "pianist", "melodious", "keyboard", "rhythmic", "singing", "tuneful", "harmonious", "beating", "pitch", "waltzing", "synthesized", "piano", "serenading", "mozarts", "swelling", "staccato", "pianissimo", "monotone", "polytempo"];

    List<String> handles2 = <String>["Siren", "Singer", "Tenor", "Trumpeter", "Baritone", "Dancer", "Ballerina", "Harpsicordist", "Musician", "Lutist", "Violist", "Rapper", "Harpist", "Lyricist", "Virtuoso", "Bass"];

    @override
    List<String> levels =<String>["SINGING SCURRYWORT", "MUSICAL MOPPET"];

    @override
    List<String> interestStrings = <String>["Rap", "Music", "Song Writing", "Musicals", "Dance", "Singing", "Ballet", "Playing Guitar", "Playing Piano", "Mixtapes", "Turntables"];


    Music() :super(1, "Music", "musical", "loud");

}