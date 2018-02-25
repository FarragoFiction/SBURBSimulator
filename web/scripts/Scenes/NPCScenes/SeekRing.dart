import "../../SBURBSim.dart";
import 'dart:html';

class SeekRing extends Scene {
    GameEntity target;
    Generator<String> tactic;
    Item ring;
    String oldName;

    SeekRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      oldName = gameEntity.name;

      gameEntity.available = false;
      session.logger.info("$gameEntity is seeking the ring.");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

    String tryFighting() {
        String oldName = gameEntity.name;
        //assasinate if strong enough, else strife.
        if(gameEntity.getStat(Stats.POWER) > target.getStat(Stats.HEALTH)) {
            //should auto loot
            target.makeDead("being assasinated by ${gameEntity.title()}", gameEntity);
            session.logger.info("AB: A ring was assasinated from a target.");
            return "The ${oldName} sneaks up behind the ${target.title()} and assasinates them! They pull the $ring off their still twitching finger. They are now the ${gameEntity.title()}!";
        }else {
            return "The ${oldName} wants the $ring, they start a strife with the the ${target.title()}!${doStrife()}";
        }
    }

    String tryStealing() {
        double rollValueLow = gameEntity.rollForLuck(Stats.MIN_LUCK);  //separate it out so that EITHER you are good at avoiding bad shit OR you are good at getting good shit.
        double rollValueHigh = gameEntity.rollForLuck(Stats.MAX_LUCK);
        if(rollValueHigh <300) {
            gameEntity.sylladex.add(ring);
            session.logger.info("AB: A ring was stolen from a target.");
            return "The ${oldName} sneaks up behind the ${target.title()} and pick pockets them! They take the $ring and equip it! They are now the ${gameEntity.title()}! ";
        }else if(rollValueLow < -300) {
            return "The ${oldName} tries to pickpocket the $ring from the ${target.title()}, but get caught! The ${target.title()} decides to Strife them!${doStrife()}";
        }else {
            return "The ${oldName} tries to pickpocket the $ring from the ${target.title()}, but they fail. They abscond before they are caught! ";
        }
    }

    String tryAsking() {
        //thrown out
        Relationship theirRelationship = target.getRelationshipWith(gameEntity);
        if(theirRelationship.value >10) {
            gameEntity.sylladex.add(ring);
            session.logger.info("AB: A ring was given from a target.");
            return "The ${oldName} politely approaches the ${target.title()} and asks for the $ring. To everyone's surprise, the ${target.title()} hands it over.  The ${oldName} is now the ${gameEntity.title()}! ";
        }else if(theirRelationship.value < -10){
            return "The ${oldName} has the audacity to just waltz right up to the ${target.title()} and demand the $ring. We are unsurprised that the ${target.title()} is offended enough to strife. ${doStrife()}";
        }else {
            return "The ${oldName} has the audacity to just waltz right up to the ${target.title()} and demand the $ring. We are unsurprised when it doesn't work.";
        }
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

      return "Seek Ring: ${tactic()}";
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
      //print("my relationship with white is  $prospitRel and black is $derseRel, my reltionships are ${gameEntity.relationships}");

      //will be null if trying to steal from self
      if(prospitRel == null) {
          target == blackRingOwner;
      }else if(derseRel == null) {
          target == whiteRingOwner;
      }else if(derseRel.value < prospitRel.value ) {
          target = blackRingOwner;
      }


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