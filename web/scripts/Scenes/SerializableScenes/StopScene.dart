
import "../../SBURBSim.dart";
import 'dart:html';

/*
    can have other target conditions, but has a special hardcoded one as well
    where you can ONLY target the original owner
 */
class StopScene extends SerializableScene {
    @override
    String name = "Reaction Scene";
    GameEntity originalOwner;
    StopScene(Session session) : super(session);


    @override
    bool trigger(List<Player> playerList) {
        //session.logger.info("TEST BIG BAD: checking triggers");
        posedAsATeamAlready = false;
        landTargets.clear();
        livingTargets.clear();
        if(originalOwner.dead) return false;
        if(!originalOwner.active) return false;
        livingTargets.add(originalOwner);
        //TODO should i also get party members for those npcs? otherwise can't get brain ghosts and robots and the like
        for(Player p in session.players) {
            if(p.active) {
                landTargets.add(p.land);
            }
        }

        //session.logger.info("i think active targets is $livingTargets");

        landTargets.addAll(session.moons);

        landTargets = new Set<Land>.from(shuffle(session.rand, new List<Land>.from(landTargets)));

        for(TargetConditionLiving tc in triggerConditionsLiving) {
            livingTargets = new Set<GameEntity>.from(tc.filter(new List<GameEntity>.from(livingTargets)));
        }
        if(triggerConditionsLiving.isEmpty) livingTargets.clear();


        for(TargetConditionLand tc in triggerConditionsLand) {
            landTargets = new Set<Land>.from(tc.filter(new List<Land>.from(landTargets), livingTargets));
        }
        if(triggerConditionsLand.isEmpty) landTargets.clear();
        //even if you have land targets, NEED to target the original owner
        if(livingTargets.isEmpty) return false;

        return landTargets.isNotEmpty || livingTargets.isNotEmpty;
    }

}


