import "dart:html";
import "../SBURBSim.dart";


class IntroNew extends IntroScene {

    Player player = null;
    Player friend = null;
    bool goodLand = false;


    IntroNew(Session session): super(session, false);
  @override
  void renderContent(Element div, int i) {
      String narration = getNarration();
      String chat = "";
      if(friend != null) {
          //p2.getRelationshipWith(p1).value > 0
          List<Conversation> convos = getConversations();
          String player1Start = player.chatHandleShort() + ": ";
          String player2Start = friend.chatHandleShortCheckDup(player.chatHandleShort()) + ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

          chat = convos[0].returnStringConversation(player, friend, player1Start, player2Start,friend.getRelationshipWith(player).value > 0);
          chat += convos[0].returnStringConversation(player, friend, player1Start, player2Start,player.object_to_prototype.getStat(Stats.POWER)>200);
          chat += convos[0].returnStringConversation(player, friend, player1Start, player2Start,goodLand);
      }
      appendHtml(div, narration);
      if(friend != null) {
          //lookit me, doing canvas shit correctly. what even IS this???
          CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
          div.append(canvas);
          Drawing.drawChat(canvas, player, friend, chat,"discuss_sburb.png");
      }
  }

  String getNarration() {
        return "TODO: WRITE THIS SHIT FUTURE JR. (And don't fucking forget to have special stuff like replacing sprites. )";
  }

  @override
  bool trigger(List<Player> playerList, Player player){
      this.playerList = playerList;
      this.player = player;
      this.friend =  player.getBestFriendFromList(findLivingPlayers(this.session.players), "intro chat");
      if(friend == null){
          friend = player.getWorstEnemyFromList(findLivingPlayers(this.session.players));
      }
      return true; //this should never be in the main array. call manually.
  }

    List<Conversation> getConversations() {
      List<Conversation>ret = new List<Conversation>();
      //order is important cuz whether i do positive or negative matters if it's land or whatever
      ret.add(new Conversation(getEnterPair()));
      ret.add(new Conversation(getLandPair()));
      ret.add(new Conversation(getSpritePair()));
     return ret;
    }

    List<PlusMinusConversationalPair> getEnterPair() {
      //TODO grim dark, foreign, regular
        return getRegularEnterPair();

    }

    //this only picks a single line.
    List<PlusMinusConversationalPair> getRegularEnterPair() {
        List<PlusMinusConversationalPair> possible = new List<PlusMinusConversationalPair>();
        //generic
        possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's it like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));

        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible)];
    }

    //two sections, I'm in the land of x and y!// Cool, what's it like?// It's full of x and y.// Oh.
    //goodLand
    List<PlusMinusConversationalPair> getLandPair() {
        List<PlusMinusConversationalPair> possible1 = new List<PlusMinusConversationalPair>();
        List<PlusMinusConversationalPair> possible2 = new List<PlusMinusConversationalPair>();
        //generic
        possible1.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's it like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));

        possible2.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's it like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));


        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible1), rand.pickFrom(possible2)];
    }


    //i prototyped my kernel with a x. wait, isn't that....   long story.  ...
    List<PlusMinusConversationalPair> getSpritePair() {
        List<PlusMinusConversationalPair> possible1 = new List<PlusMinusConversationalPair>();
        List<PlusMinusConversationalPair> possible2 = new List<PlusMinusConversationalPair>();
        //generic
        possible1.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's it like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));

        possible2.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's it like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));


        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible1), rand.pickFrom(possible2)];
    }
}