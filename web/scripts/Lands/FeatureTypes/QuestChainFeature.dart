import "../Feature.dart";
import "../Quest.dart";
import "../../SBURBSim.dart";

//if more than one quest chain is assigned to a land then you need to know how to trigger it. use predicate
class QuestChain extends Feature {
   String name;
   List<Quest> quests;
   ///if condition is met, then might be chosen to start. once started, goes linear.
   Predicate<Player> condition;
   bool finished = false;
   bool started = false;



    QuestChain(this.name, this.quests);

    bool playerIsStealthyAspect(Player p) {
        return p.aspect == Aspects.VOID || p.aspect == Aspects.BREATH;
    }

   bool playerIsSneakyClass(Player p) {
       return p.class_name == SBURBClassManager.ROGUE || p.class_name == SBURBClassManager.THIEF;
   }

   bool playerIsProtectiveClass(Player p) {
       return p.class_name == SBURBClassManager.KNIGHT || p.class_name == SBURBClassManager.PAGE;
   }
}

class PreDenizenQuestChain extends QuestChain {

    PreDenizenQuestChain(String name, List<Quest> quests): super(name, quests);
}

class DenizenQuestChain extends QuestChain {

    DenizenQuestChain(String name, List<Quest> quests): super(name, quests);
}

class PostDenizenQuestChain extends QuestChain {

    PostDenizenQuestChain(String name, List<Quest> quests): super(name, quests);
}

