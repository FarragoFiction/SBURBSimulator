import "dart:html";
import "../SBURBSim.dart";

/*
New and improved dialogue. Don't wanna fuck with narration too much. It's terrifying and also SUPPOSED to be rote.
 */
class IntroNew extends IntroScene {

    Player player = null;
    Player friend = null;
    bool goodLand = false;


    IntroNew(Session session): super(session, false);
  @override
  void renderContent(Element div, int i) {
      doNarration(div,i);
      String chat = "";
      if(friend != null && player.grimDark <2) {
          List<Conversation> convos = getConversations();
          String player1Start = player.chatHandleShort() + ": ";
          String player2Start = friend.chatHandleShortCheckDup(player.chatHandleShort()) + ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

          chat = convos[0].returnStringConversation(player, friend, player1Start, player2Start,friend.getRelationshipWith(player).value > 0);
          chat += convos[1].returnStringConversation(player, friend, player1Start, player2Start,player.object_to_prototype.getStat(Stats.POWER)>200);
          chat += convos[2].returnStringConversation(player, friend, player1Start, player2Start,goodLand);

          //lookit me, doing canvas shit correctly. what even IS this???
          CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
          div.append(canvas);
          Drawing.drawChat(canvas, player, friend, chat,"discuss_sburb.png");
      }else {
        appendHtml(div, "<br><Br>They do not feel like talking to anyone.");
      }
  }

  //just blindly grabbing it out of the old stuff. fuck the world, this is how i role. or roll. whichever.
  void doNarration(Element div, int i) {
      //throw "testing testing";
      if(i == 0) this.player.leader = true; //fuck you, you're the leader.
      session.mutator.replacePlayerIfCan(div, this.player);
      //foundRareSession(div, "This is just a test. " + this.session.session_id);
      String canvasHTML = "<canvas style='display:none' class = 'charSheet' id='firstcanvas" + this.player.id.toString()+"_" + this.session.session_id.toString()+"' width='400' height='1000'>  </canvas>";
      appendHtml(div, canvasHTML);
      var canvasDiv = querySelector("#firstcanvas"+ this.player.id.toString()+"_" + this.session.session_id.toString());
      Drawing.drawCharSheet(canvasDiv,this.player);
      this.player.generateDenizen();
      ImportantEvent alt = this.addImportantEvent();
      if(alt != null && alt.alternateScene(div)){
          return;
      }
      String narration = "";

      if(this.player.land == null){
          ////session.logger.info("This session is:  " + this.session.session_id + " and the " + this.player.title() + " is from session: " + this.player.ectoBiologicalSource + " and their land is: " + this.player.land);
      }
      if(!this.player.fromThisSession(this.session) || this.player.land == null){
          narration += "<br>The " + this.player.htmlTitle() + " has been in contact with the native players of this session for most of their lives. It's weird how time flows differently between universes. Now, after inumerable shenanigans, they will finally be able to meet up face to face.";
          if(this.player.dead==true){
              //session.logger.info(session.session_id.toString() + " dead player enters, " +this.player.title());
              narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess time flowing differently between universes is still a thing that is true, and they were able to contact them even before they died.  Shit, this is extra tragic.  <br>";
              appendHtml(div, narration);
              session.addAvailablePlayer(player);
              return;
          }
      }else{
          this.changePrototyping(div);
          narration += "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
          if(this.player.aspect == Aspects.VOID) narration += "They are " + this.player.voidDescription() +". ";
          narration += " They manage to prototype their kernel sprite with a " + this.player.object_to_prototype.htmlTitle() + " pre-entry. ";
          narration += this.corruptedSprite();

          narration += " They have many INTERESTS, including " +this.player.interest1.name + " and " + this.player.interest2.name + ". ";
          narration += " Their chat handle is " + this.player.chatHandle + ". ";
          if(this.player.leader){
              narration += "They are definitely the leader.";
          }
          if(this.player.godDestiny){
              narration += " They appear to be destined for greatness. ";
          }

          if(this.player.getStat(Stats.MIN_LUCK) + this.player.getStat(Stats.MAX_LUCK) >25){
              ////session.logger.info("initially lucky player: " +this.session.session_id);
              narration += " They have aaaaaaaall the luck. All of it.";
          }

          if(this.player.getStat(Stats.MAX_LUCK) < -25){
              ////session.logger.info("initially unlucky player: " +this.session.session_id);
              narration += " They have an insurmountable stockpile of TERRIBLE LUCK.";
          }

          if(this.player.fraymotifs.length > 0){
              ////session.logger.info("initially unlucky player: " +this.session.session_id);
              narration += " They have special powers, including " + turnArrayIntoHumanSentence(this.player.fraymotifs) + ". ";
          }

          if(this.player.dead==true){
              //session.logger.info(session.session_id.toString() + " dead player enters, " +this.player.title());
              narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess their GHOST or something is making sure their house and corpse makes it into the medium? And their client player, as appropriate. Their kernel somehow gets prototyped with a "+this.player.object_to_prototype.htmlTitle() + ". ";
              this.player.timesDied ++;

              this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
              if(this.session.npcHandler.kingsScepter != null) this.session.npcHandler.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
              if(this.player.object_to_prototype.armless){
                  //session.logger.info("armless prototyping in session: " + this.session.session_id.toString());
                  narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. ";
                  this.session.destroyBlackRing();
              }
              if(this.session.npcHandler.queensRing != null){
                  this.session.npcHandler.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
                  narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
              }
              narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
              appendHtml(div, narration);

              return;
          }

          narration += this.changeBoggle();
          narration += this.corruptedLand();

          for(num j = 0; j<this.player.relationships.length; j++){
              var r = this.player.relationships[j];
              ////session.logger.info("Initial relationship value is: " + r.value + " and grim dark is: " + this.player.grimDark);
              if(r.type() != "Friends" && r.type() != "Rivals"){
                  narration += "They are " + r.description() + ". ";
              }
          }
          if(this.player.trickster){
              narration += "They immediately heal their land in an explosion of bullshit candy giggle-magic. ";
          }
          this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
          if(this.session.npcHandler.kingsScepter != null) this.session.npcHandler.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
          if(this.player.object_to_prototype.armless && rand.nextDouble() > 0.93){
              //session.logger.info("armless prototyping in session: " + this.session.session_id.toString());
              narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. ";
              this.session.destroyBlackRing();
          }
          if(this.session.npcHandler.queensRing != null){
              this.session.npcHandler.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
              narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
          }
          narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
      }
      appendHtml(div, narration);
      session.addAvailablePlayer(player);
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
      //TODO have different things for foreign players

      //order is important cuz whether i do positive or negative matters if it's land or whatever
      ret.add(new Conversation(getEnterPair()));
      ret.add(new Conversation(getLandPair()));
      ret.add(new Conversation(getSpritePair()));
     return ret;
    }



    //this only picks a single line.
    List<PlusMinusConversationalPair> getEnterPair() {
        List<PlusMinusConversationalPair> possible = new List<PlusMinusConversationalPair>();
        //generic
        possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, what's your land like?","What's it like?","What do you see?", "Really? What's it like?"],["About time! Tell me what you see!","Fucking finally. Where are you? What did you do?"]));

        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible)];
    }

    //two sections, I'm in the land of x and y!// Cool, what's it like?// It's full of x and y.// Oh.
    //goodLand
    List<PlusMinusConversationalPair> getLandPair() {
        List<PlusMinusConversationalPair> lines = new List<PlusMinusConversationalPair>();
        String land = player.land.name;
        //start it off
        lines.add(new PlusMinusConversationalPair(["Apparently it's the land of $land?", "It's the land of $land.", "Some random ${player.land.consortFeature.name} said it was the $land?", "There's this giant sign that says it's the $land."], ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));

        double randomNum = rand.nextDouble();

        if(randomNum > .66) {
            return smellConvo(lines);
        }else if(randomNum > .33) {
            return feelConvo(lines);
        }else {
            return soundConvo(lines);
        }
  }

    List<PlusMinusConversationalPair> smellConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia smellQualia = player.land.smellsLike(rand);
        goodLand = smellQualia.quality > 0;
        String qualiaString = smellQualia.desc;
        if(smellQualia.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of smells like $qualiaString.", "It's weird, it smells like $qualiaString.", "Do you think there's a reason it smells like $qualiaString?"], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it smells like $qualiaString!", "I could get used to smelling $qualiaString!", "Holy shit, it smells fuckin FANTASTIC! Like...$qualiaString?"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, it reeks of $qualiaString!", "Oh god, I hope I fucking get a cold. I cannot stand the smell of $qualiaString.", "I think the smell of $qualiaString is gonna drive me shithive maggots.", "$qualiaString. It smells like fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }

        return lines;
    }

    List<PlusMinusConversationalPair> soundConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia sound = player.land.soundsLike(rand);
        goodLand = sound.quality > 0;
        String qualiaString = sound.desc;
        if(sound.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of sounds like $qualiaString.", "It's weird, it sounds like $qualiaString.", "Do you think there's a reason it sounds like $qualiaString?"], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it sounds like $qualiaString! So relaxing!", "I could get used to hearing $qualiaString!", "Holy shit, I love the $qualiaString I am hearing!"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, I can't get the sound of $qualiaString out of my head...", "I am going to hear $qualiaString in my nightmares for weeks.", "I think the sound of $qualiaString is gonna drive me shithive maggots.", "$qualiaString. I can barely fucking even THINK because of all this fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }
        return lines;
    }

    List<PlusMinusConversationalPair> feelConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia feel = player.land.feelsLike(rand);
        goodLand = feel.quality > 0;
        String qualiaString = feel.desc;
        if(feel.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of feels $qualiaString.", "It's weird, it feels $qualiaString.", "It's kind of $qualiaString..."], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it feels so $qualiaString!", "It's so $qualiaString here!", "Holy shit, I just love the way it feels here! Like...$qualiaString or something?"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, it feels so $qualiaString! I feel unclean.", "I am already getting sick of how $qualiaString it feels here.", "I think $qualiaString fucking land is gonna drive me shithive maggots.", "$qualiaString. It smells like fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }
        return lines;
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



    String corruptedLand(){

		if(player.land != null && player.land.corrupted ){
			this.player.corruptionLevelOther = 100;
			//session.logger.info("corrupted land" + this.session.session_id.toString());
			return "There is ...something very, very wrong about the ${this.player.land.name}. ";
		}
        return "";
    }
    String corruptedSprite(){
        if(this.player.sprite.corrupted ){
            return "There is ...something very, very wrong about the " + this.player.sprite.htmlTitle();
        }
        return "";
    }
    String changeBoggle(){
        if(this.player.aspect == Aspects.BLOOD){
            return " They boggle vacantly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.MIND){
            return " They ogle at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.RAGE){
            return " They glare with bafflement at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.TIME){
            return " They are very confused by the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.VOID){
            return " They stare blankly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.HEART){
            return " They run around excitedly in the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.BREATH){
            return " They grin excitedly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.LIGHT){
            return " They stare at the " + this.player.land.name + " with unrestrained curiosity. ";
        }else if(this.player.aspect == Aspects.SPACE){
            return " They do not even understand the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.HOPE){
            return " They are enthused about the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.LIFE){
            return " They are obviously pleased with " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.DOOM){
            return " They stare with trepidation at the " + this.player.land.name + ". ";
        }
        return  "They boggle vacantly at the " + this.player.land.name + ". ";
    }
    String changePrototyping(Element div){
        String ret = "";
        if(this.player.object_to_prototype.getStat(Stats.POWER) > 200 && rand.nextDouble() > .8){
            String divID = (div.id);
            String canvasHTML = "<br><canvas id='canvaskernel" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
            appendHtml(div, canvasHTML);
            CanvasElement canvas = querySelector("#canvaskernel"+ divID);
            List<Player> times = findAllAspectPlayers(this.session.players, Aspects.TIME); //they don't have to be in the medium, though
            Player timePlayer = rand.pickFrom(times); //ironically will probably allow more timeless sessions without crashes.
            Drawing.drawTimeGears(canvas);
            Drawing.drawSinglePlayer(canvas, timePlayer);
            ret = "A " + timePlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
            if(timePlayer.dead){
                ret += "It's a little alarming how much they are bleeding. ";
            }
            ret += " They come with a dire warning of a doomed timeline. ";
            ret += "They dropkick the " + this.player.object_to_prototype.htmlTitle() + " out of the way and jump into the " + this.player.htmlTitleBasic() + "'s kernel sprite instead. <br> ";
            this.player.object_to_prototype = timePlayer.clone();
            this.player.object_to_prototype.name = timePlayer.chatHandle;
            this.player.object_to_prototype.helpfulness = 1;
            this.player.object_to_prototype.player = true;
            //shout out to DinceJof for the great sprite phrase
            this.player.object_to_prototype.helpPhrase = " used to be a Player like you, until they took a splinter to the timeline, so they know how all this shit works. Super helpful.";
            //session.logger.info("time player sprite in session: " + this.session.session_id.toString());

        }else if((this.player.dead == true || this.player.isDreamSelf == true || this.player.dreamSelf == false) && rand.nextDouble() > .1){ //if tier 2 is ever a thing, make this 50% instead and have spries very attracted to extra corpes later on as well if they aren't already players or...what would even HAPPEN if you prototyped yourself twice....???
            ret = "Through outrageous shenanigans, one of the " + this.player.htmlTitle() + "'s superfluous corpses ends up prototyped into their kernel sprite. <br>";
            this.player.object_to_prototype =this.player.clone() ;//no, don't say 'corpsesprite';
            this.player.object_to_prototype.name = this.player.chatHandle;
            //session.logger.info("player sprite in session: " + this.session.session_id.toString());
            this.player.object_to_prototype.helpfulness = 1;
            this.player.object_to_prototype.player = true;
            this.player.object_to_prototype.helpPhrase = " is interested in trying to figure out how to play the game, since but for shenanigans they would be playing it themselves.";

        }
        appendHtml(div, ret);
        return "";
    }

    ImportantEvent addImportantEvent(){
        var current_mvp = findStrongestPlayer(this.session.players);
        ////session.logger.info("Entering session, mvp is: " + current_mvp.getStat(Stats.POWER));
        if(this.player.aspect == Aspects.TIME && this.player.object_to_prototype != null && !this.player.object_to_prototype.illegal){ //tier4 gnosis is weird
            return this.session.addImportantEvent(new TimePlayerEnteredSessionWihtoutFrog(this.session, current_mvp.getStat(Stats.POWER),this.player,null) );
        }else{
            return this.session.addImportantEvent(new PlayerEnteredSession(this.session, current_mvp.getStat(Stats.POWER),this.player,null) );
        }

    }
}