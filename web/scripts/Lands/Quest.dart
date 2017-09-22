import "../SBURBSim.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/DenizenFeature.dart";
class Quest {
    //not sure if i'll need all of these. just...trying things out.
    static String PLAYER1 = "PLAYER1TAG";
    static String DENIZEN = "DENIZENTAG";
    static String CONSORT = "CONSORTTAG";
    static String CONSORTSOUND = "CONSORTSOUNDTAG";
    static String MCGUFFIN = "MCGUFFINTAG";
    static String PHYSICALMCGUFFIN = "TAGPHYSICALMCGUFFIN";

    String text;

    Quest(this.text);


    //passed in everything they need to know to fill in all possible tags.
    String doQuest(Player p1, DenizenFeature denizen, ConsortFeature consort, String mcguffin, String physicalMcguffin) {
        String ret = text;
        ret = ret.replaceAll("$PLAYER1", "${p1.htmlTitleBasicNoTip()}");
        ret = ret.replaceAll("$CONSORT", "${consort.name}");
        ret = ret.replaceAll("$CONSORTSOUND", "${consort.sound}");
        ret = ret.replaceAll("$MCGUFFIN", "${mcguffin}");
        ret = ret.replaceAll("$PHYSICALMCGUFFIN", "${physicalMcguffin}");
        ret = ret.replaceAll("$DENIZEN", "${denizen.name}");
        return ret;
    }


}

//TODO FIGURE OUT IF THIS IS HOW I WANT TO DO FIGHTS OR NOT. MAKES SENSE TO MAKE THEM QUESTS HERE INSTEAD OF SEPARATE SCENES
//WOULD NEED TO TAKE IN A DENIZEN (NOT JUST A NAME). THEN SPAWN THE DENIZEN BASED ON STRENGTH SETTING AND WITH NAME
//MAYBE OFFLOAD THE FRAYMOTIF REWARD TO BE A QUEST CHAIN REWARD?
//TODO also do i want even more types of subquests? maybe ones that change the world in addition to printing out some text.
//TODO fights can be failed. if they are failed, then their quest chain shouldn't remove them.
//let's assume that if  a doQuest returns null, it was failed.
class BossFight extends Quest {
  BossFight(String text) : super(text);
}

class MiniBossFight extends Quest {
    MiniBossFight(String text) : super(text);
}