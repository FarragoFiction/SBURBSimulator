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
//TODO
  }

  void findAItem() {
//TODO
  }

  void findARecipient() {
//TODO
  }

  void beginQuest(Element div) {
//TODO
  }

  void continueQuest(Element div) {
//TODO
  }

  //if it's rank is higher than the recipient's specibus, this item is now their specibus
  //they get the 'kind' for it, too.
  void endQuest(Element div) {
      //TODO remember to null out item so i can start quest again next time.
  }


  void getInRandomStrife(Element div) {
//TODO
  }

  void cantFindRecipient(Element div) {
    //TODO  if you die, null out item.
  }

  void bullsitDeteor(Element div) {
    //TODO
  }

  @override
  bool trigger(List<Player> playerList) {
    // TODO: implement trigger
      //should have a REALLY high chance of triggering. The MAIL is important.
      if(session.rand.nextDouble() > .8) return true;
      return false;
  }
}