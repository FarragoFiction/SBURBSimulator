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
    bool canRepeat;  //not all circumstances has this matter.
    List<Quest> quests; //quest will be removed when completed.
    //stored for repeatable quest chains
    List<Quest> completedQuests = new List<Quest>();
    ///if condition is met, then might be chosen to start. once started, goes linear.
    Predicate<List<GameEntity>> condition; //like playerIsStealthy
    bool finished = false;
    bool started = false;
    Reward reward;
    int chapter = 1;

    @override
    String toHTML() {
        return "<div class = 'feature'>QuestChain: ${name}, Reward: ${reward}</div>";
    }

    QuestChainFeature(this.canRepeat, this.name, this.quests, this.reward, this.condition);


    @override
    String toString() {
        return "$runtimeType: $name";
    }

    QuestChainFeature clone() {
        return new QuestChainFeature(this.canRepeat,this.name, new List<Quest>.from(this.quests), this.reward, this.condition);
    }

    ///assume first player is the owner of the quest.
    ///this will handle all drawing, Quest itself just returns a string.
    bool doQuest(Player p1, GameEntity p2, DenizenFeature denizen, ConsortFeature consort, String symbolicMcguffin, String physicalMcguffin, Element div, Land land) {
        chapter ++;
        //p2 is for interaction effect and also reward.
        //whether you win or not, get power
        p1.increasePower();
        if(p2 != null) p2.increasePower();


        if(quests.isEmpty && canRepeat) {
            quests = new List.from(completedQuests);
            completedQuests.clear();
        }

        bool success = quests.first.doQuest(div, p1,p2,denizen, consort, symbolicMcguffin, physicalMcguffin);

        //only if you win. mostly only used for frogs and grist at this point.
        if(success) {
            p1.increaseLandLevel();
            completedQuests.add(quests.first);
            quests.remove(quests.first);
            if (quests.isEmpty) {
               // print("I've finished quest chain $name!,player is $p1");
                finished = true;
                reward.apply(div, p1, p2,  land);
            }
            return true;
        }else {
            return false;
        }
    }


    static bool playerIsStealthyAspect(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.VOID || p.aspect == Aspects.BREATH;
    }

    static bool twoPlayers(List<GameEntity> ps) {
        bool ret = ps.length > 1 && ps[1] != null && ps[1] is Player;
        ps[0].session.logger.info("checking for two players, ps is ${ps}, ret is $ret");
        return ret;
    }


    //useful for denizen choices, etc.
    static bool playerIsADick(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.getFriends().length < p.getEnemies().length;
    }

    //TODO have lands have generic grim dark quest chains with high weight, but themes can have their own, too
    static bool isGrimDark(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.grimDark > 2;
    }

    //for moon shit
    static bool hasDreamSelf(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.dreamSelf;
    }

    //for moon shit
    static bool hasNoDreamSelfNoBubbles(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return !p.dreamSelf && !p.session.stats.dreamBubbleAfterlife;
    }

    //for moon shit.
    static bool hasNoDreamSelfBubbles(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return !p.dreamSelf && p.session.stats.dreamBubbleAfterlife;
    }

    static bool murderMode(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.murderMode;
    }

    //whatever, 12x spam combo

    static bool bloodPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.BLOOD;
    }

    static bool mindPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.MIND;
    }

    static bool ragePlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.RAGE;
    }

    static bool voidPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.VOID;
    }

    static bool heartPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.HEART;
    }

    static bool timePlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.TIME;
    }

    static bool breathPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.BREATH;
    }

    static bool lightPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.LIGHT;
    }

    static bool spacePlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.SPACE;
    }

    static bool hopePlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.HOPE;
    }

    static bool lifePlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.LIFE;
    }

    static bool doomPlayer(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.DOOM;
    }



    static bool playerIsNice(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.getFriends().length > p.getEnemies().length;
    }

    static bool playerIsSneakyClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isSneaky;
    }

    static bool playerIsProtectiveClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isProtective;
    }

    static bool playerIsMagicalClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isMagical ;
    }
    static bool playerIsDestructiveClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isDestructive ;
    }
    static bool playerIsHelpfulClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isHelpful ;
    }
    static bool playerIsSmartClass(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.class_name.isSmart ;
    }

    static bool playerIsFateAspect(List<GameEntity> ps) {
        Player p = ps.first as Player;
        return p.aspect == Aspects.DOOM || p.aspect == Aspects.TIME;
    }

    //make quest chains be a weighted list so default option is ALWAYS very unlikely to trigger. or something.
    static bool defaultOption(List<GameEntity> ps) {
        return true;
    }
}

//want to be able to quickly tell what sort of quest chain it is.
class PreDenizenQuestChain extends QuestChainFeature {

    PreDenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(false, name, quests, reward, condition);
    @override
    PreDenizenQuestChain clone() {
        return new PreDenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}

class DenizenQuestChain extends QuestChainFeature {

    DenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(false, name, quests, reward, condition);
    @override
    DenizenQuestChain clone() {
        return new DenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}

class PostDenizenQuestChain extends QuestChainFeature {

    PostDenizenQuestChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(false, name, quests, reward, condition);
    @override
    PostDenizenQuestChain clone() {
        return new PostDenizenQuestChain(this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}


class PostDenizenFrogChain extends PostDenizenQuestChain {

    PostDenizenFrogChain(String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(name, quests, reward, condition);

    @override
    PostDenizenFrogChain clone() {
        return new PostDenizenFrogChain(this.name, new List<Quest>.from(this.quests), this.reward, this.condition);
    }

    @override
    bool doQuest(Player p1, GameEntity p2, DenizenFeature denizen, ConsortFeature consort, String symbolicMcguffin, String physicalMcguffin, Element div, Land land) {
        //takes 3 quests to finish.
        p1.landLevel += p1.session.goodFrogLevel/3;
        //p1.session.logger.info("land level raised to ${p1.landLevel}");
        return super.doQuest(p1, p2, denizen, consort, symbolicMcguffin, physicalMcguffin, div, land);
    }
}

class MoonQuestChainFeature extends QuestChainFeature {

    MoonQuestChainFeature(bool canRepeat, String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(canRepeat,name, quests, reward, condition);
    @override
    MoonQuestChainFeature clone() {
        return new MoonQuestChainFeature(this.canRepeat, this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}



class SkaiaQuestChainFeature extends QuestChainFeature {

    SkaiaQuestChainFeature(bool canRepeat, String name, List<Quest> quests, Reward reward, Predicate<List<Player>> condition) : super(canRepeat,name, quests, reward, condition);
    @override
    SkaiaQuestChainFeature clone() {
        return new SkaiaQuestChainFeature(this.canRepeat, this.name,  new List<Quest>.from(this.quests), this.reward, this.condition);
    }
}