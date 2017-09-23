import "../Feature.dart";
import "../Quest.dart";
import "../Reward.dart";
import "dart:html";
import "../../SBURBSim.dart";
import "ConsortFeature.dart";
import "EnemyFeature.dart";

//if more than one quest chain is assigned to a land then you need to know how to trigger it. use predicate
//TODO when you print out the text for this allow modulariy, like PLAY THE X (where x is the associated word for the aspect of the main player)
//TODO make sure to remember that each quest in a chain could be at wildly different times. each quest should be self contained.
//if it's a bank heist then first quest is plan the heist, second is recruit your team, third is rob the bank and abscond, fourth is divy spoils.
class QuestChainFeature extends Feature {
    String name;
    List<Quest> quests; //quest will be removed when completed.
    ///if condition is met, then might be chosen to start. once started, goes linear.
    Predicate<List<Player>> condition; //like playerIsStealthy
    bool finished = false;
    bool started = false;
    Reward reward;
    int chapter = 1;

    QuestChainFeature(this.name, this.quests, this.reward, this.condition);


    @override
    String toString() {
        return "${super.toString()}: ${this.name}";
    }

    QuestChainFeature clone() {
        return new QuestChainFeature(this.name, new List<Quest>.from(this.quests), this.reward, this.condition);
    }

    ///assume first player is the owner of the quest.
    ///this will handle all drawing, Quest itself just returns a string.
    bool doQuest(Player p1, Player p2, DenizenFeature denizen, ConsortFeature consort, String symbolicMcguffin, String physicalMcguffin, Element div) {
        chapter ++;
        //p2 is for interaction effect and also reward.
        //whether you win or not, get power
        p1.increasePower();
        if(p2 != null) p2.increasePower();

        QuestResult result = quests.first.doQuest(p1,denizen, consort, symbolicMcguffin, physicalMcguffin);
        //TODO if ret is null, quest was failed. do not remove, need to try again.
        appendHtml(div, "${result.text}");
        //only if you win. mostly only used for frogs and grist at this point.
        if(result.success) {
            p1.increaseLandLevel();
            removeFromArray(quests.first, quests);
            if (quests.isEmpty) {
                print("I've finished quest chain $name!");
                finished = true;
                reward.apply(div, p1, p2);
            }
            return true;
        }else {
            return false;
        }
    }

    //TODO how can I have specifically two player quests? I guess I could take in a List<Player>, and have most of them check p1 but have twoPlayer quests be a thing?

    static bool playerIsStealthyAspect(List<Player> ps) {
        Player p = ps.first;
        return p.aspect == Aspects.VOID || p.aspect == Aspects.BREATH;
    }

    static bool playerIsSneakyClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isSneaky;
    }

    static bool playerIsProtectiveClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isProtective;
    }

    static bool playerIsMagicalClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isMagical ;
    }
    static bool playerIsDestructiveClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isDestructive ;
    }
    static bool playerIsHelpfulClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isHelpful ;
    }
    static bool playerIsSmartClass(List<Player> ps) {
        Player p = ps.first;
        return p.class_name.isSmart ;
    }

    static bool playerIsFateAspect(List<Player> ps) {
        Player p = ps.first;
        return p.aspect == Aspects.DOOM || p.aspect == Aspects.TIME;
    }

    //make quest chains be a weighted list so default option is ALWAYS very unlikely to trigger. or something.
    static bool defaultOption(List<Player> ps) {
        return true;
    }
}

//want to be able to quickly tell what sort of quest chain it is.
class PreDenizenQuestChain extends QuestChainFeature {

    PreDenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(name, quests, reward, condition);
    @override
    PreDenizenQuestChain clone() {
        return new PreDenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}

class DenizenQuestChain extends QuestChainFeature {

    DenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(name, quests, reward, condition);
    @override
    DenizenQuestChain clone() {
        return new DenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}

class PostDenizenQuestChain extends QuestChainFeature {

    PostDenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(name, quests, reward, condition);
    @override
    PostDenizenQuestChain clone() {
        return new PostDenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}

