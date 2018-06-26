
import "../../SBURBSim.dart";
import 'dart:html';

/*
    can have other target conditions, but has a special hardcoded one as well
    where you can ONLY target the original owner
 */
class StopScene extends SerializableScene {
    @override
    String name = "Stop Scene";
    GameEntity originalOwner;
    StopScene(Session session) : super(session);


    @override
    bool trigger(List<Player> playerList) {
        //session.logger.info("TEST BIG BAD: checking triggers");
        posedAsATeamAlready = false;
        livingTargets.clear();
        if(originalOwner == null || originalOwner.dead || !originalOwner.active) return false;
        livingTargets.add(originalOwner);


        //still can have normal targets, so defeat conditions can trigger with diff things
        for(TargetConditionLiving tc in triggerConditionsLiving) {
            livingTargets = new Set<GameEntity>.from(tc.filter(new List<GameEntity>.from(livingTargets)));
        }
        if(triggerConditionsLiving.isEmpty) livingTargets.clear();
        return livingTargets.isNotEmpty;
    }

}


