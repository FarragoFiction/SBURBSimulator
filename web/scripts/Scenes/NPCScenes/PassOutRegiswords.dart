import "../../SBURBSim.dart";
import 'dart:html';

//jack passes out regiswords and quests to get rings/scepters to everyone he meets

class PassOutRegiswords extends Scene {

    int swordsPassedOut = 0;
    int maxSwordsPassedOut = 2;
    GameEntity patsy;
  PassOutRegiswords(Session session) : super(session);


  @override
  void renderContent(Element div) {
      gameEntity.available = false;
      patsy.available = false;
      //session.logger.info("Jack is passing out Regiswords again, this time to ${patsy.htmlTitle()}.");
      DivElement me = new DivElement();
      patsy.sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]));

      patsy.scenes.insert(0, new SeekRing(session));
      patsy.scenes.insert(0, new SeekScepter(session));
      patsy.scenes.insert(0, new GiveJackRing(session));
      patsy.scenes.insert(0, new GiveJackScepter(session));


      List<String> genericReasons = patsy.bureaucraticBullshit;

      if(genericReasons == null || genericReasons.isEmpty) genericReasons = <String>["really needs to get a parking ticket validated.","has to pay a fine for smuggling ice cream.","needs to get their small business loan approved.","is in the middle of a series of shenanigans."];

      me.setInnerHtml("<br>The ${patsy.htmlTitle()} ${session.rand.pickFrom(genericReasons)} They end up having to visit the ${gameEntity.htmlTitle()} for bureaucratic reasons, who immediately hands them a Regisword. They make it a policy to hand out Regiswords to just about anyone who enters their office.  The ${patsy.htmlTitle()} is instructed to not bother coming back without a Ring or Scepter.");
      div.append(me);
      swordsPassedOut ++;
  }

  GameEntity pickAPatsy() {
      List<GameEntity> patsies = new List.from(session.getReadOnlyAvailablePlayers());
      //royalty are kept separate so jack should NOT give the white queen a quest to get herh own ring.
      if(session.derse != null) patsies.addAll(session.derse.associatedEntities);
      if(session.prospit != null) patsies.addAll(session.prospit.associatedEntities);
      WeightedList<GameEntity> finalList = new WeightedList<GameEntity>();
      for(GameEntity g in patsies) {
        if(g is Carapace) {
            finalList.add(g, g.activationChance);
        }else {
            finalList.add(g, 0.01);
        }
      }
      return rand.pickFrom(finalList);
  }

  @override
  bool trigger(List<Player> playerList) {
    // if jack has no party leader and is not crowned, he passes out regiswords and quests to get the
      //rings and scepters, even to players.

      //trigger is: if i am not jack, and jack is not crowned, and jack has no party leader and i don't already have a 'get ring' quest

      //you're not  going to be your OWN patsy
     // ;
      if(swordsPassedOut >= maxSwordsPassedOut) return false;

      patsy = pickAPatsy();
      if(gameEntity == patsy || patsy == null ) return false;
      if(patsy is Carapace && session.numActiveCarapaces > session.maxCarapaces) return false;
      //;
      //no longer during beurocracy stuff
      if(gameEntity.crowned != null || gameEntity.partyLeader != null ) return false;
     // ;

      //he already gave you this quest.
      if(patsy.sylladex.containsWord("Regisword")) return false;
     //not so many regiswords, plz
      if(session.rand.nextDouble()< 0.5) return false;
      return true;
  }
}