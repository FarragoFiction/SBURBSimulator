import "../../SBURBSim.dart";
import 'dart:html';

class SeekRing extends Scene {
    GameEntity target;
    Action tactic;

    SeekRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      session.logger.info("$gameEntity is seeking the ring.");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

    void tryFighting() {

    }

    void tryStealing() {

    }

    void tryAsking() {

    }

    void tryFinding() {

    }

  String getText() {

      return "TODO: pick a tactic. try for the ring.";
  }

  @override
  bool trigger(List<Player> playerList) {
      tactic = null;
      target = null;
      GameEntity whiteRingOwner = session.prospit.queensRing.owner;
      GameEntity blackRingOwner = session.derse.queensRing.owner;

      target = whiteRingOwner;
      print("i am $gameEntity, white is $whiteRingOwner and black is $blackRingOwner");

      Relationship prospitRel = gameEntity.getRelationshipWith(whiteRingOwner);
      Relationship derseRel = gameEntity.getRelationshipWith(blackRingOwner);
      print("my relationship with white is  $prospitRel and black is $derseRel, my reltionships are ${gameEntity.relationships}");


      if(derseRel.value < prospitRel.value ) target = blackRingOwner;

      print("RING TEST: I want to steal the ring from ${target}. My relationship with prospit is ${prospitRel.value} vs ${derseRel.value} for the other one");

      if(gameEntity.violent && gameEntity.getStat(Stats.POWER) > target.getStat(Stats.POWER)) tactic = tryFighting;
      if(gameEntity.cunning && gameEntity.getStat(Stats.MOBILITY) > target.getStat(Stats.MOBILITY)) tactic = tryStealing;
      if(gameEntity.charming && gameEntity.getStat(Stats.RELATIONSHIPS) > target.getStat(Stats.RELATIONSHIPS)) tactic = tryAsking;
      if(gameEntity.lucky && gameEntity.getStat(Stats.MAX_LUCK) > target.getStat(Stats.MAX_LUCK)) tactic = tryFinding;
      
      //find who has each ring.
      //for each bearer, ask:
      //if i am stronger than the ring holder, and violent, i will try to strife it off them
      //if i am lucky, or have high relationship with ring holder, i will just ask for it
      //if i am fast and lucky, i will try to steal it
      //not all carapaces have 'seek ring' as an option. only ambitious ones
      //this quest can be GIVEN to someone, though.
      //for example, should a big bad have the ring, all players and allies should get this quest
      return tactic != null && target != null;
  }
}