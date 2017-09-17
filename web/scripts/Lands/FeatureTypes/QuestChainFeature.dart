import "../Feature.dart";
import "../Quest.dart";

//if more than one quest chain is assigned to a land then you need to know how to trigger it. TODO brainstorm this.
class QuestChain extends Feature {
   String name;
   List<Quest> quests;


    QuestChain(this.name, this.quests);
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

