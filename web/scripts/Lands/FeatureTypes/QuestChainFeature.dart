import "../Feature.dart";
import "../Quest.dart";
import "../Reward.dart";
import "dart:html";
import "../../SBURBSim.dart";

//if more than one quest chain is assigned to a land then you need to know how to trigger it. use predicate
//TODO when you print out the text for this allow modulariy, like PLAY THE X (where x is the associated word for the aspect of the main player)
//TODO make sure to remember that each quest in a chain could be at wildly different times. each quest should be self contained.
//if it's a bank heist then first quest is plan the heist, second is recruit your team, third is rob the bank and abscond, fourth is divy spoils.
class QuestChainFeature extends Feature {
   String name;
   List<Quest> quests; //quest will be removed when completed.
   ///if condition is met, then might be chosen to start. once started, goes linear.
   Predicate<Player> condition; //like playerIsStealthy
   bool finished = false;
   bool started = false;
   Reward reward;



    QuestChainFeature(this.name, this.quests, this.reward, this.condition);


    ///assume first player is the owner of the quest.
   ///this will handle all drawing, Quest itself just returns a string.
    void doQuest(Player p1, Player p2, String denizenName, String consortName, String consortSound, String smell, String sound, String feeling, String mcguffin, String mcguffinPhysical,  Element div ) {
        throw("TODO");
        /*TODO
            I need to call the first quest in the list, then append whatever it returns to myself. (along with my name and which quest I'm on.   Bank Heist, Chapter 2: <quest text>)
            then i need to remove that quest from the list
            if there are no quests left, set finished to true, and ask your reward to render itself.

         */
    }

    static bool playerIsStealthyAspect(Player p) {
        return p.aspect == Aspects.VOID || p.aspect == Aspects.BREATH;
    }

   static bool playerIsSneakyClass(Player p) {
       return p.class_name == SBURBClassManager.ROGUE || p.class_name == SBURBClassManager.THIEF;
   }

   static bool playerIsProtectiveClass(Player p) {
       return p.class_name == SBURBClassManager.KNIGHT || p.class_name == SBURBClassManager.PAGE;
   }

   //make quest chains be a weighted list so default option is ALWAYS very unlikely to trigger. or something.
   static bool defaultOption(Player p) {
       return true;
   }
}

//want to be able to quickly tell what sort of quest chain it is.
class PreDenizenQuestChain extends QuestChainFeature {

    PreDenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<Player> condition): super(name, quests, reward, condition);
}

class DenizenQuestChain extends QuestChainFeature {

    DenizenQuestChain(String name, List<Quest> quests, Reward reward,Predicate<Player> condition): super(name, quests, reward, condition);
}

class PostDenizenQuestChain extends QuestChainFeature {

    PostDenizenQuestChain(String name, List<Quest> quests, Reward reward,Predicate<Player> condition): super(name, quests, reward, condition);
}

