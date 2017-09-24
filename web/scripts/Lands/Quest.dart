import "../SBURBSim.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "FeatureTypes/EnemyFeature.dart";
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
    QuestResult doQuest(Player p1, DenizenFeature denizen, ConsortFeature consort, String mcguffin, String physicalMcguffin) {
        return replaceTags(true, text, p1,  denizen,  consort,  mcguffin,  physicalMcguffin);
    }

    QuestResult replaceTags(bool success, String ret,Player p1, DenizenFeature denizen, ConsortFeature consort, String mcguffin, String physicalMcguffin) {
        ret = ret.replaceAll("$PLAYER1", "${p1.htmlTitleBasicNoTip()}");
        ret = ret.replaceAll("$CONSORT", "${consort.name}");
        ret = ret.replaceAll("$CONSORTSOUND", "${consort.sound}");
        ret = ret.replaceAll("$MCGUFFIN", "${mcguffin}");
        ret = ret.replaceAll("$PHYSICALMCGUFFIN", "${physicalMcguffin}");
        ret = ret.replaceAll("$DENIZEN", "${denizen.name}");


        return new QuestResult(ret, success);
    }


}

//TODO FIGURE OUT IF THIS IS HOW I WANT TO DO FIGHTS OR NOT. MAKES SENSE TO MAKE THEM QUESTS HERE INSTEAD OF SEPARATE SCENES
//WOULD NEED TO TAKE IN A DENIZEN (NOT JUST A NAME). THEN SPAWN THE DENIZEN BASED ON STRENGTH SETTING AND WITH NAME
//MAYBE OFFLOAD THE FRAYMOTIF REWARD TO BE A QUEST CHAIN REWARD?
//TODO also do i want even more types of subquests? maybe ones that change the world in addition to printing out some text.
//TODO fights can be failed. if they are failed, then their quest chain shouldn't remove them.
//let's assume that if  a doQuest returns null, it was failed.
class BossFight extends Quest {
    EnemyFeature enemy;
    BossFight(String text) : super(text);
}


//dead quests can be failed and when you fail them it's game over.
class FailableQuest extends Quest {
    double odds;
    String failureText;
    ///odds are between 0 and 1, 1 basically means "act like a regular quest", and 0 means insta fail.
    FailableQuest(String text, this.failureText, this.odds) : super(text);

    //passed in everything they need to know to fill in all possible tags.
    @override
    QuestResult doQuest(Player p1, DenizenFeature denizen, ConsortFeature consort, String mcguffin, String physicalMcguffin) {
        if(p1.session.rand.nextDouble() < odds) {
            return replaceTags(true, text, p1,  denizen,  consort,  mcguffin,  physicalMcguffin);
        }else {
            return replaceTags(false, failureText, p1,  denizen,  consort,  mcguffin,  physicalMcguffin);
        }
    }
}

class QuestResult {
    String text;
    bool success;
    QuestResult(this.text, this.success);
}