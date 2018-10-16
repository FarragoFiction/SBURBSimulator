import "../../SBURBSim.dart";
import 'dart:html';

//all of midnight crew have this by default, but anyone
//who jack gave a regisword to will also have this.
//just because they have this doesn't mean they will DO it, though.
class GiveJackScepter extends Scene {
    Carapace jack;
    GiveJackScepter(Session session) : super(session);
    //can only happen once
    bool triggered = false;

    bool strifeTime = false;



    @override
    void renderContent(Element div) {
        DivElement me = new DivElement();
        me.setInnerHtml(getText());
        div.append(me);
        triggered = true;

        if(strifeTime) {
            Team pTeam = new Team(this.session, <GameEntity>[gameEntity]);
            pTeam.canAbscond = false;
            Team dTeam = new Team(this.session, <GameEntity>[jack]);
            dTeam.canAbscond = false;
            Strife strife = new Strife(this.session, [pTeam, dTeam]);
            strife.startTurn(div);
        }
    }



    String getText() {
        Relationship r = gameEntity.getRelationshipWith(session.npcHandler.jack);
        if(r != null && r.value < -1*Relationship.CRUSHVALUE) {
            return strifeJack();
        }

        if(gameEntity is Player) {
            Player p = gameEntity as Player;
            //you don't know any better.
            if(p.gnosis <2) {
                return giveScepter();
            }else {
                return keepScepter();
            }
        }

        if(r != null && r.value < 0)
        {
            return keepScepter();
        }else {
            return giveScepter();
        }
    }

    //default
    String keepScepter() {
        session.logger.info("AB: someone is keeping the scepter for themselves.");
        return "After further consideration, the ${gameEntity.htmlTitle()} decides to keep the ${gameEntity.scepter} for themself.";

    }

    //hate jack
    String strifeJack() {
        session.logger.info("AB: someone is trying to fight jack rather than give them the scepter.");
        strifeTime = true;
        return "After further consideration, the ${gameEntity.htmlTitle()} decides to keep the ${gameEntity.scepter} for themself. In fact, they decided that the ${jack.htmlTitle()} is too dangerous to allow to live.";


    }

    //only if sburb lore is low or unallied with players
    String giveScepter() {
        session.logger.info("AB: $gameEntity is trying to give jack the scepter");
        Scepter r = gameEntity.scepter;
        String jackName = jack.name;
        jack.sylladex.add(gameEntity.scepter);
        return "The ${gameEntity.htmlTitle()} hands the ${r} over to the ${jackName}. This is clearly a good decision and nothing bad can come from ${jackName} becoming the ${jack.name}.";
    }

    @override
    bool trigger(List<Player> playerList) {
        jack = session.npcHandler.jack;
        // if jack has no party leader and is not crowned, he passes out regiswords and quests to get the
        //rings and scepters, even to players.
        //rand is so it can take a bit of time for them to get back to jack
        if(!triggered && gameEntity.scepter != null && !session.npcHandler.jack.dead && session.rand.nextDouble() <0.3) {
            return true;
        }
        return false;
    }
}