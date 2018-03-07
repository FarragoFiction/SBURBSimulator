import "../../SBURBSim.dart";
import 'dart:html';

class BeDistracted extends Scene {
    BeDistracted(Session session) : super(session);

  @override
  void renderContent(Element div) {
      //print("NPC TEST: a carapace is being distracted");
      gameEntity.available = false;
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

  String getText() {
      //print("game entity is $gameEntity");
      List<String> genericDistractions = <String>["is distracted looking out at Skaia.","got stuck glitching into a wall for a while","forgot what they were doing for a bit."];
      genericDistractions.addAll(gameEntity.distractions);
      return "<br>The ${gameEntity.title()} ${rand.pickFrom(genericDistractions)}";
  }

  @override
  bool trigger(List<Player> playerList) {
      //don't be too spammy. you don't have to do something EVERY tick. you're not a player.
     // print("will ${gameEntity.htmlTitle()} be distracted?");
      if(session.rand.nextDouble() > .8) return true;
      return false;
  }
}