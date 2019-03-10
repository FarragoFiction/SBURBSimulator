import "../../SBURBSim.dart";
import 'dart:html';

/*

technically anyone can have this, but i'll only give it to ZC on derse and PM on prospit.
and maybe if they are your companion you can do mail quests, too.

Mail quests pick a random target to deliver to (any player or active carapace,
and a random item (something a player or a carapce already owns) to deliver.

first part of quest is picking up the item. know who currently has it. they will ALWAYS
give it up, even if it's a ring. (that's just the Rules of the Mail and not even Jack will disobey).

second - ?? part is some bullshit thing keeping you from delivering.
    random chance of: fighting a random npc not related to the quest because of a misunderstanding
                    : getting a regisword from jack
                    : going where you think the recipient will be only to find they've moved on
                    : having a deteor where you have to do some bullshit side quest to make progress (like getting a key for a door)

Final part is delivering the item. If it has a higher rank than the target's current specibus, they equip it instead
(regardless of kind, they also get a strife deck or whatever for it, like the bunny)

Point of these quests is shuffling items around.

 */
class MailSideQuest extends Scene {
  Item package;
  GameEntity senderOfItem;
  GameEntity recipient;

  //longer it takes to deliver, the more difficult it's assumed to be
  int difficulty = 0;

  MailSideQuest(Session session) : super(session);

  @override
  void renderContent(Element div) {
      gameEntity.available = false;
      DivElement container = new DivElement();
      div.append(container);
      if(!doNotRender) {
          ImageElement image;
          if (session.derse == this) {
              image = new ImageElement(src: "images/Rewards/mail.png");
          } else {
              image = new ImageElement(src: "images/Rewards/mail.png");
          }
          //can do this because it's not canvas
          //although really if my rendering pipeline were diff i could do on canvas, too.
          image.onLoad.listen((e) {
              container.append(image);
          });
      }



      if(package == null) {
          difficulty = 0;
          session.stats.mailQuest = true;
          senderOfItem = null;
          recipient = null;
          return beginQuest(div);
      }else if(!gameEntity.sylladex.contains(package)) {
          return failedQuestLostItem(div);
      }else if(recipient.dead) {
          return failedQuestDeadRecipient(div);
      }else if(session.rand.nextDouble()>.2) {
          difficulty ++;
        return continueQuest(div);
      }else {
          difficulty ++;
          session.logger.info("AB: The mail ($package) went through. Does ${gameEntity.title()} ever stop delivering?");
          return endQuest(div);
      }
  }

  void findASender() {
      senderOfItem = findSomeoneBesidesMeWithItems();
  }

  void findAItem() {
      package = rand.pickFrom(senderOfItem.sylladex);
      //Mail quests are WORTH IT. and JESUS FUCK if it turns out it was a ring.
      package.traits.add(ItemTraitFactory.UNBEATABLE);

      gameEntity.sylladex.add(package); //should auto remove from sender, but let's be safe
      senderOfItem.sylladex.remove((package));
  }

  void findARecipient() {
      //... I'm okay with the fact that someone can mail an item to themselves.
      //maybe they are exploiting the buff mechanic
      recipient = findSomeoneBesidesMe();
  }


  void failedQuestDeadRecipient(Element div) {
      session.logger.info("AB: The mail went through, but to a corpse. Does ${gameEntity.name} ever stop delivering?");

      DivElement ret = new DivElement();
      ret.setInnerHtml("The ${gameEntity.htmlTitle()} suddenly stops, dead in their tracks. They stare down at the dead ${recipient.htmlTitle()}. It is with a heavy heart they place the ${package} on them, respectfully. The Mail did Not Fail, but nor did it win this day.");
      div.append(ret);
      givePackageToRecipient();
      package = null;
  }

  void failedQuestLostItem(Element div) {
      session.logger.info("AB: The mail got lost. Shit.");

      DivElement ret = new DivElement();
      ret.setInnerHtml("The ${gameEntity.htmlTitle()} suddenly stops, dead in their tracks. They pat around their pockets frantically. Where is the ${package}!? The one the ${senderOfItem.htmlTitle()} entrusted them to deliever to ${recipient.htmlTitle()}!? Oh god. Oh no. How did this happen? They have FAILED THE MAIL.");
      div.append(ret);
      package = null;
  }

  void beginQuest(Element div) {
      DivElement ret = new DivElement();

      findASender();
      if(senderOfItem == null) {
          ret.setInnerHtml("The ${gameEntity.htmlTitle()} wants to deliver some mail but can't find any one in need!");
          package = null;
          div.append(ret);
          return;
      }

      findAItem();
      if(senderOfItem == null) {
          ret.setInnerHtml("The ${gameEntity.htmlTitle()} wants to deliver some mail but can't find any one in need!");
          div.append(ret);
          package = null;
          return;
      }
      findARecipient();
      if(recipient == null) {
          ret.setInnerHtml("The ${gameEntity.htmlTitle()} wants to deliver some mail but can't find any one in need!");
          div.append(ret);
          package = null;
          return;
      }
      String crown = "";
      if(package is Ring || package is Scepter) {
          crown = "Huh. Maybe they are tired of the heavy burden a $package represents? <span class = 'void'>Attached is a Note: Haha, nope, I have no intention of being part of this back stab parade.</span>";
          session.stats.mailedCrownAbdication = true;
      }
      ret.setInnerHtml("The ${gameEntity.htmlTitle()} is entrusted with a vital task. The ${senderOfItem.htmlTitle()} gives them a ${package} to deliver to the ${recipient.htmlTitle()} as soon as possible. $crown The ${gameEntity.htmlTitle()} will not let the Mail down!");
      div.append(ret);
  }

  void continueQuest(Element div) {
      List<Lambda<Element>> questParts = <Lambda<Element>>[cantFindRecipient, bullshitDeteor];
      return session.rand.pickFrom(questParts)(div);
  }

  bool givePackageToRecipient() {
      bool activateCrownGlitch = session.rand.nextBool();
      if(gameEntity.specibus.rank < package.rank) {
          if((package is Ring || package is Scepter) && activateCrownGlitch) {
              recipient.sylladex.add(recipient.specibus);
              Specibus s = new Specibus(package.fullName, package.traits.first,
                  new List.from(package.traits));
              recipient.specibus = s;
              gameEntity.sylladex.remove((package));
              return true;
          }else {
              //you have the common sense not to turn the Crown into a specibus, which makes it glitch out
              recipient.sylladex.add(package); //should auto remove from sender, but let's be safe
              gameEntity.sylladex.remove((package));
              return false;
          }
      }else {
          recipient.sylladex.add(package); //should auto remove from sender, but let's be safe
          gameEntity.sylladex.remove((package));
          return false;
      }

  }

  //if it's rank is higher than the recipient's specibus, this item is now their specibus
  //they get the 'kind' for it, too.
  void endQuest(Element div) {
      session.logger.info("AB: The mail went through. Does ${gameEntity.name} ever stop delivering?");

      bool equiped = givePackageToRecipient();
      DivElement ret = new DivElement();
      String text = "With a proud flourish, the ${gameEntity.htmlTitleWithTip()} finishes delivering the ${package} to the ${recipient.htmlTitleWithTip()}.";
      if(difficulty > 4) text = "With a frustrated huff, the ${gameEntity.htmlTitleWithTip()} shoves the ${package} at the ${recipient.htmlTitleWithTip()}.";

      if(equiped) {
          text = "$text The ${recipient.htmlTitle()} also gets a specibus card so they can equip it, too! It's...huh. Wow. How strong even IS this ${package}?";
      }
      ret.setInnerHtml(text);
      div.append(ret);
      package = null;
      if(gameEntity is Player) (gameEntity as Player).increasePower();
  }

  GameEntity findSomeoneBesidesMe() {
      GameEntity target;
      if(session.rand.nextBool()) {
          List<Player> players = new List.from(session.players);
          players.remove(gameEntity);
          target = rand.pickFrom(players);
      }else {
          List<GameEntity> entities = new List.from(session.activatedNPCS);
          entities.remove(gameEntity); //do no matter what
          target = rand.pickFrom(entities);
      }
      return target;
  }

  GameEntity findSomeoneBesidesMeWithItems() {
      GameEntity target;
      List<GameEntity> entities;
      if(session.rand.nextBool()) {
          entities = new List.from(session.players);
          entities.remove(gameEntity);
      }else {
          entities = new List.from(session.npcHandler.allEntities);
          entities.remove(gameEntity); //do no matter what
      }

      List<GameEntity> toRemove = new List<GameEntity>();

      for(GameEntity g in entities) {
        if(g.sylladex.isEmpty || g.dead) toRemove.add(g);
      }

      for(GameEntity g in toRemove) {
        entities.remove(g);
      }

      target = rand.pickFrom(entities);

      return target;
  }


  void getInRandomStrife(Element div) {
      session.logger.info("AB: It's a mail fight.");

      GameEntity target = findSomeoneBesidesMe();

      Team pTeam = new Team(this.session, <GameEntity>[gameEntity]);
      pTeam.canAbscond = false;
      Team dTeam = new Team(this.session, <GameEntity>[target]);
      dTeam.canAbscond = false;
      Strife strife = new Strife(this.session, [pTeam, dTeam]);

      DivElement preFight = new DivElement();
      preFight.setInnerHtml("Shit. There's been a huge misunderstanding about the mail and now the ${gameEntity.htmlTitle()} has to fight the ${target.htmlTitle()}. This is so stupid.");
      div.append(preFight);

      strife.startTurn(div);

      DivElement ret = new DivElement();

      if(gameEntity.dead) {
        package = null; //you don't have it anymore as a deliverable thing
        ret.setInnerHtml("The mail. Has failed.");
      }else {
          ret.setInnerHtml("The mail will go through.");
      }
      div.append(ret);

  }

  Land findLandToBeOn([Land besides]) {
      WeightedList<Land> targets = new WeightedList<Land>();
      //extra chance for the target to be on their home base
      if(recipient is Player) {
            Player p = recipient;
            if(p.land != null) targets.add(p.land, 3);
      }

      if(recipient is Carapace) {
          Carapace p = recipient;
          if(p.type == Carapace.PROSPIT) {
                if(session.prospit != null) targets.add(session.prospit,3);
          }else {
              if(session.derse != null) targets.add(session.derse,3);
          }
      }

      for(Player p in session.players) {
          if(p.land != null) targets.add(p.land);
      }

      for(Moon m in session.moons) {
          if(m != null) targets.add(m);
      }

      if(besides != null) {
          //clear out them all
          while(targets.contains(besides)){
            targets.remove(besides);
          }
      }

      return session.rand.pickFrom(targets);
  }

  void cantFindRecipient(Element div) {
      session.logger.info("AB: Mail keeps missing $recipient.");

      Land currentLand = findLandToBeOn();
      List<String> bullshit = <String>["The ${gameEntity.htmlTitle()} arrives at ${currentLand} where the ${recipient.htmlTitle()} should be, but a ${currentLand.consortFeature.sound}ing ${currentLand.consortFeature.name} says they just missed them. Drat.","The ${gameEntity.htmlTitle()} arrives at ${currentLand} only to find the ${recipient.htmlTitle()} apparently just left.","The ${gameEntity.htmlTitle()} searches  ${currentLand.name} for a while, but just can't find the ${recipient.htmlTitle()}. "];
      DivElement ret = new DivElement();
      ret.setInnerHtml(session.rand.pickFrom(bullshit));
      div.append(ret);
  }

  void bullshitDeteor(Element div) {
      session.logger.info("AB: The mail keeps getting delayed.");

      Land currentLand = findLandToBeOn();
      Land detour = findLandToBeOn(currentLand);
      List<String> frustrations = <String>["Of course.","For fucks sake.","Why don't they just let the mail go through!?","The ${gameEntity.htmlTitle()} tries not to get too frustrated.", "The The ${gameEntity.htmlTitle()} idly wishes they were doing the OTHER kind of shipping instead."];

      List<String> bullshit = <String>["The ${gameEntity.htmlTitle()} realizes that to get to the ${recipient.htmlTitle()}, they need to get a key for a bridge on the ${currentLand} and the key is only kept on the ${detour}. ","A ${currentLand.consortFeature.sound}ing ${currentLand.consortFeature.name} won't let the ${gameEntity.htmlTitle()} past without a rare item that is only kept on the ${detour}. ","The ${gameEntity.htmlTitle()} has to bribe the worlds worst ${currentLand.consortFeature.name} with a delicacy that you can only find on the ${detour}.  "];
      DivElement ret = new DivElement();
      ret.setInnerHtml("${session.rand.pickFrom(bullshit)} ${rand.pickFrom(frustrations)}");
      div.append(ret);
  }

  @override
  bool trigger(List<Player> playerList) {
      //should have a REALLY high chance of triggering. The MAIL is important.
      //BUT not guaranteed, can still do dumb shit like alchemize with the package.
      if(package != null && session.rand.nextDouble() > .01) return true;
      if(session.rand.nextDouble() > .03  && gameEntity is Carapace) return true;
      if(session.rand.nextDouble() > .06  && !(gameEntity is Carapace) && !(session is DeadSession)) {
          //session.logger.info("AB: Non carapace is delivering the mail. Okay. Whatever floats your boat.");
          return true;
      }

      if(session.rand.nextDouble() > .09  && !(gameEntity is Carapace) && (session is DeadSession)) {
          session.logger.info("AB: Non carapace is delivering the mail in a dead session. Okay. Whatever floats your boat.");
          return true;
      }

      return false;
  }
}