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
    String doQuest(Player p1, Player p2, String denizenName, String consortName,  String consortSound, String mcguffin, String mcguffinPhysical) {
        return "TODO: need to replace tags.  $text";
    }


}

//TODO FIGURE OUT IF THIS IS HOW I WANT TO DO FIGHTS OR NOT. MAKES SENSE TO MAKE THEM QUESTS HERE INSTEAD OF SEPARATE SCENES
//WOULD NEED TO TAKE IN A DENIZEN (NOT JUST A NAME). THEN SPAWN THE DENIZEN BASED ON STRENGTH SETTING AND WITH NAME
//MAYBE OFFLOAD THE FRAYMOTIF REWARD TO BE A QUEST CHAIN REWARD?

class BossFight extends Quest {
  BossFight(String text) : super(text);
}

class MiniBossFight extends Quest {
    MiniBossFight(String text) : super(text);
}