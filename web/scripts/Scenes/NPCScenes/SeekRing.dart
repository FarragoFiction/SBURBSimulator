import "../../SBURBSim.dart";
import 'dart:html';

class SeekRing extends Scene {
    GameEntity target;
    Generator<String> tactic;
    Item ring;
    String oldName;
    String targetOldName;
    bool strifeTime = false;

    SeekRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      ring = target.ring;

      strifeTime = false;
      oldName = gameEntity.htmlTitleWithTip();
      targetOldName = target.htmlTitleWithTip();

      gameEntity.available = false;
      //session.logger.info("$gameEntity is seeking the ring.");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);
      if(strifeTime) {
          Team pTeam = new Team(this.session, <GameEntity>[gameEntity]);
          pTeam.canAbscond = false;
          Team dTeam = new Team(this.session, <GameEntity>[target]);
          dTeam.canAbscond = false;
          Strife strife = new Strife(this.session, [pTeam, dTeam]);
          strife.startTurn(div);
      }

  }


    String tryFighting() {
        String oldName = gameEntity.htmlTitle();
        //assasinate if strong enough, else strife.
        if(gameEntity.getStat(Stats.POWER) > target.getStat(Stats.HEALTH)) {
            //should auto loot
            takeRing();
            target.makeDead("being assasinated by ${gameEntity.title()}", gameEntity);
            //session.logger.info("AB: A ring was assasinated from a target.");
            return "The ${oldName} sneaks up behind the ${targetOldName} and assasinates them! They pull the $ring off their still twitching finger. They are now the ${gameEntity.title()}!";
        }else {
            return "The ${oldName} wants the $ring, they start a strife with the the ${targetOldName}!${prepareStrife()}";
        }
    }

    String tryStealing() {
        double rollValueLow = gameEntity.rollForLuck(Stats.MIN_LUCK);  //separate it out so that EITHER you are good at avoiding bad shit OR you are good at getting good shit.
        double rollValueHigh = gameEntity.rollForLuck(Stats.MAX_LUCK);
        if(rollValueHigh >300) {
            takeRing();
            //session.logger.info("AB: A ring was stolen from a target.");
            return "The ${oldName} sneaks up behind the ${targetOldName} and pick pockets them! They take the $ring and equip it! They are now the ${gameEntity.htmlTitleWithTip()}, and their target becomes the ${target.htmlTitleWithTip()}! ";
        }else if(rollValueLow < -300) {
            return "The ${oldName} tries to pickpocket the $ring from the ${targetOldName}, but get caught! The ${targetOldName} decides to Strife them!${prepareStrife()}";
        }else {
            return "The ${oldName} tries to pickpocket the $ring from the ${targetOldName}, but they fail. They abscond before they are caught! ";
        }
    }

    void takeRing() {
       // ;
        //;
        gameEntity.sylladex.add(target.ring);
        //for some reason isn't removing in sylladex? testing something.
        //;

        target.sylladex.remove(target.ring);
        //;
    }

    String tryAsking() {
        //thrown out
        Relationship theirRelationship = target.getRelationshipWith(gameEntity);
        if(theirRelationship != null && theirRelationship.value >10) {
            takeRing();
            //session.logger.info("AB: A ring was given from a target.");
            return "The ${oldName} politely approaches the ${targetOldName} and asks for the $ring. To everyone's surprise, the ${targetOldName} hands it over.  The ${oldName} is now the ${gameEntity.title()}! ";
        }else if((theirRelationship != null && theirRelationship.value < -10) || target.violent){
            return "The ${oldName} has the audacity to just waltz right up to the ${targetOldName} and demand the $ring. We are unsurprised that the ${targetOldName} is offended enough to strife. ${prepareStrife()}";
        }else {
            return "The ${oldName} has the audacity to just waltz right up to the ${targetOldName} and demand the $ring. We are unsurprised when it doesn't work.";
        }
    }

    String tryFinding() {
        //always works, but really hard to trigger
        takeRing();
        //session.logger.info("AB: A ring was just found out of nowhere.");

        return "The ${oldName} trips over practically nothing and somehow finds the $ring !? The  ${targetOldName} must have lost it. The ${oldName} is now the ${gameEntity.title()}. It's really kind of weird and anti-climatic. Oh well.";

    }

    String prepareStrife() {
        strifeTime = true;
        //session.logger.info("AB: A strife for a ring is trying to happen.");
        return "";
    }

  String getText() {

      return "<br>Seek Ring: ${tactic()}";
  }

  //todo sometimes someone who doesn't own the ring is chosen.
  @override
  bool trigger(List<Player> playerList) {
      strifeTime = false;
      tactic = null;
      target = null;
      GameEntity whiteRingOwner;
      if(session.prospitRing != null) whiteRingOwner = session.prospitRing.owner;
      GameEntity blackRingOwner;
      if(session.derseRing != null) blackRingOwner = session.derseRing.owner;

      //;

      //ring could be destroyed, or...somehow...not owned by who it thinks it is which is weird and wrong and what is happening.
      if(whiteRingOwner == null || whiteRingOwner.ring == null) whiteRingOwner = blackRingOwner;
      if(gameEntity == whiteRingOwner) whiteRingOwner == blackRingOwner;
      if(blackRingOwner == null || blackRingOwner.ring == null) blackRingOwner = whiteRingOwner;
      if(gameEntity == blackRingOwner) blackRingOwner == whiteRingOwner;

      //if both rings are destroyed...don't even bother.
      if(whiteRingOwner == null && blackRingOwner == null) return false;
      if(whiteRingOwner.ring == null && blackRingOwner.ring == null) return false;

      target = whiteRingOwner;
      //;

      Relationship prospitRel = gameEntity.getRelationshipWith(whiteRingOwner);
      Relationship derseRel = gameEntity.getRelationshipWith(blackRingOwner);
      //;

      //will be null if trying to steal from self
      if(prospitRel == null) {
          target == blackRingOwner;
      }else if(derseRel == null) {
          target == whiteRingOwner;
      }else if(derseRel.value < prospitRel.value ) {
          target = blackRingOwner;
      }
      bool theyLikeMe = false;

      if(target != gameEntity) {
          Relationship theirRelationship = target.getRelationshipWith(gameEntity);
          if(theirRelationship != null) theyLikeMe = theirRelationship.value >5;
      }



      if(gameEntity.charming && gameEntity.getStat(Stats.RELATIONSHIPS) > target.getStat(Stats.RELATIONSHIPS) && theyLikeMe && session.rand.nextDouble() > .7) tactic = tryAsking;
      if(gameEntity.lucky && gameEntity.getStat(Stats.MAX_LUCK) > target.getStat(Stats.MAX_LUCK) && session.rand.nextDouble() > .8) tactic = tryFinding;
      if(gameEntity.cunning && gameEntity.getStat(Stats.MOBILITY) > target.getStat(Stats.MOBILITY) && session.rand.nextDouble() > .8) tactic = tryStealing;
      if(gameEntity.violent && gameEntity.getStat(Stats.POWER) > target.getStat(Stats.POWER)) tactic = tryFighting;

      //find who has each ring.
      //for each bearer, ask:
      //if i am stronger than the ring holder, and violent, i will try to strife it off them
      //if i am lucky, or have high relationship with ring holder, i will just ask for it
      //if i am fast and lucky, i will try to steal it
      //not all carapaces have 'seek ring' as an option. only ambitious ones
      //this quest can be GIVEN to someone, though.
      //for example, should a big bad have the ring, all players and allies should get this quest

      return tactic != null && target != null && session.rand.nextDouble() > .7;
  }
}