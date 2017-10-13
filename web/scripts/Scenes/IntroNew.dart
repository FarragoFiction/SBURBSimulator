import "dart:html";
import "../SBURBSim.dart";


class IntroNew extends IntroScene {

    Player player = null;


    IntroNew(Session session): super(session, false);
  @override
  void renderContent(Element div, int i) {
    // TODO: implement renderContent
  }

  @override  //TODO is there no way to have an Intro trigger have more params than Scene?
  bool trigger(List<Player> playerList, Player player){
      this.playerList = playerList;
      this.player = player;
      return true; //this should never be in the main array. call manually.
  }

    Conversation getConversation() {
      List<PlusMinusConversationalPair> convo = new List<PlusMinusConversationalPair>()
      ..add(getEnterPair());
      //can be in different order
      if(rand.nextBool()) {
          convo..add(getLandPair());
          convo.add(getSpritePair());
      }else {
          convo..add(getSpritePair());
          convo.add(getLandPair());
      }
     return new Conversation(convo);
    }

    PlusMinusConversationalPair getEnterPair() {
        //..add(new PlusMinusConversationalPair(["Would you like to play a game?", " Let's play a game, asshole.", "Do you want to play a game?"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]..addAll(fuckOff)))

    }

    PlusMinusConversationalPair getLandPair() {

    }


    PlusMinusConversationalPair getSpritePair() {

    }
}