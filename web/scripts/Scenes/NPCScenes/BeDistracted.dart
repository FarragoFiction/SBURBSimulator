import "../../SBURBSim.dart";
import 'dart:html';

class BeDistracted extends Scene {
    BeDistracted(Session session) : super(session);

  @override
  void renderContent(Element div) {
      print("NPC TEST: a carapace is being distracted");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

  String getText() {
      return "$gameEntity is distracted. <br>PLACEHOLDER:   JR wants this to be diff for each carapace, but how? Pass in valid distractions on init?";
  }

  @override
  bool trigger(List<Player> playerList) {
      //don't be too spammy. you don't have to do something EVERY tick. you're not a player.
      if(session.rand.nextDouble() > .7) return true;
      return false;
  }
}