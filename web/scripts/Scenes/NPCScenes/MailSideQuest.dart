import "../../SBURBSim.dart";
import 'dart:html';

/*

technically anyone can have this, but i'll only give it to ZC on derse and PM on prospit.

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

  MailSideQuest(Session session) : super(session);

  @override
  void renderContent(Element div) {
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
              div.append(image);
          });
      }

      if(package == null) {
          session.logger.info("AB: The mail is going through. Does ${gameEntity.name} ever stop delivering?");
          return beginQuest(div);
      }else if(session.rand.nextBool()) {
        return continueQuest(div);
      }else {
          return endQuest(div);
      }
  }

  void findASender() {
      if(session.rand.nextBool()) {
         senderOfItem = rand.pickFrom(session.players);
      }else {
          senderOfItem = rand.pickFrom(session.activatedNPCS);
      }
  }

  void findAItem() {
      //Mail quests are WORTH IT. and JESUS FUCK if it turns out it was a ring.
      package = rand.pickFrom(senderOfItem.sylladex);
      package.traits.add(ItemTraitFactory.UNBEATABLE);

      gameEntity.sylladex.add(package); //should auto remove from sender, but let's be safe
      senderOfItem.sylladex.remove((package));
  }

  void findARecipient() {
      if(session.rand.nextBool()) {
          senderOfItem = rand.pickFrom(session.players);
      }else {
          senderOfItem = rand.pickFrom(session.activatedNPCS);
      }
  }

  void beginQuest(Element div) {
      findASender();
      findAItem();
      findARecipient();
      //TODO print out what all these are.
      DivElement ret = new DivElement();
      ret.setInnerHtml("The ${gameEntity.htmlTitle()} is entrusted with a vital task. The ${senderOfItem.htmlTitle()} gives them a ${package} to deliever to ${recipient.htmlTitle()} as soon as possible. The ${gameEntity.htmlTitle()} will not let the Mail down!");
      div.append(ret);
  }

  void continueQuest(Element div) {
      List<Lambda> questParts = <Lambda>[cantFindRecipient, bullshitDeteor];
      return session.rand.pickFrom(questParts)(div);
  }

  //if it's rank is higher than the recipient's specibus, this item is now their specibus
  //they get the 'kind' for it, too.
  void endQuest(Element div) {
      //TODO remember to null out item so i can start quest again next time.
  }


  void getInRandomStrife(Element div) {
    //TODO if you die, null out item
  }

  void cantFindRecipient(Element div) {
    //TODO  list of "they were just there a minute ago" bullshit
  }

  void bullshitDeteor(Element div) {
    //TODO list of possible deteors, just pick one and write it out
  }

  @override
  bool trigger(List<Player> playerList) {
    // TODO: implement trigger
      //should have a REALLY high chance of triggering. The MAIL is important.
      if(session.rand.nextDouble() > .8) return true;
      return false;
  }
}