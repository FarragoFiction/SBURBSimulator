import "../SBURBSim.dart";
class Quest {
    //not sure if i'll need all of these. just...trying things out.
    static String PLAYER1 = "PLAYER1TAG";
    static String PLAYER2 = "PLAYER2TAG";
    static String DENIZEN = "DENIZENTAG";
    static String CONSORT = "CONSORTTAG";
    static String CONSORTSOUND = "CONSORTSOUNDTAG";
    static String SMELL = "CONSORTTAG";
    static String SOUND = "CONSORTTAG";
    static String FEELING = "CONSORTTAG";
    static String MCGUFFIN = "MCGUFFINTAG";
    static String PHYSICALMCGUFFIN = "PHYSICALMCGUFFINTAG";

    String text;

    Quest(this.text);


    //passed in everything they need to know to fill in all possible tags.
    String doQuest(Player p1, Player p2, String denizenName, String consortName, String consortSound, String smell, String sound, String feeling, String mcguffin, String mcguffinPhysical) {
        throw("TODO: need to replace any tags in the quest with the passed in shit. then just return your text.");
    }


}