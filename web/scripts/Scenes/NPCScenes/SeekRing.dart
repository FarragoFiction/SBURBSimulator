import "../../SBURBSim.dart";
import 'dart:html';

class SeekRing extends Scene {
    GameEntity target;
    Generator<String> tactic;
    Item ring;

    SeekRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      session.logger.info("$gameEntity is seeking the ring.");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

    String tryFighting() {
        //assasinate if strong enough, else strife.
        if(gameEntity.getStat(Stats.POWER) > target.getStat(Stats.HEALTH)) {
            //should auto loot
            target.makeDead("being assasinated by ${gameEntity.title()}", gameEntity);
            session.logger.info("AB: A ring was assasinated from a target.");
            return "The ${gameEntity.title()} sneaks up behind the ${target.title()} and assasinates them! They pull the $ring off their still twitching finger. ";
        }else {
            return doStrife();
        }
    }

    String tryStealing() {
        double rollValueLow = gameEntity.rollForLuck(Stats.MIN_LUCK);  //separate it out so that EITHER you are good at avoiding bad shit OR you are good at getting good shit.
        double rollValueHigh = gameEntity.rollForLuck(Stats.MAX_LUCK);
        //luck if it works or not, if caught, if target dislikes you, strife or insta die, else thrown out
        return "Seek Ring: $gameEntity try to steal ring from $target";

    }

    String tryAsking() {
        //thrown out
        return "Seek Ring: $gameEntity try to ask for ring from $target";

    }

    String tryFinding() {
        //always works, but really hard to trigger
        return "Seek Ring: $gameEntity try to find ring from $target";
    }

    String doStrife() {
      //TODO actually have a strife.
      return "They have a strife???";
    }

  String getText() {

      return tactic();
  }

  @override
  bool trigger(List<Player> playerList) {
      tactic = null;
      target = null;
      GameEntity whiteRingOwner = session.prospit.queensRing.owner;
      GameEntity blackRingOwner = session.derse.queensRing.owner;

      target = whiteRingOwner;
      ring = target.ring;
      print("i am $gameEntity, white is $whiteRingOwner and black is $blackRingOwner");

      Relationship prospitRel = gameEntity.getRelationshipWith(whiteRingOwner);
      Relationship derseRel = gameEntity.getRelationshipWith(blackRingOwner);
      print("my relationship with white is  $prospitRel and black is $derseRel, my reltionships are ${gameEntity.relationships}");


      if(derseRel.value < prospitRel.value ) target = blackRingOwner;

      print("RING TEST: I want to steal the ring from ${target}. My relationship with prospit is ${prospitRel.value} vs ${derseRel.value} for the other one");

      if(gameEntity.charming && gameEntity.getStat(Stats.RELATIONSHIPS) > target.getStat(Stats.RELATIONSHIPS)) tactic = tryAsking;
      if(gameEntity.lucky && gameEntity.getStat(Stats.MAX_LUCK) > target.getStat(Stats.MAX_LUCK) && session.rand.nextDouble() > .7) tactic = tryFinding;
      if(gameEntity.cunning && gameEntity.getStat(Stats.MOBILITY) > target.getStat(Stats.MOBILITY)) tactic = tryStealing;
      if(gameEntity.violent && gameEntity.getStat(Stats.POWER) > target.getStat(Stats.POWER)) tactic = tryFighting;

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